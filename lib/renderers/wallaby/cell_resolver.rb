module Wallaby
  # Resolver to provide support for cell and partial
  # @since 5.2.0
  class CellResolver < ActionView::OptimizedFileSystemResolver
    # A cell query looks like:
    #
    # ```
    # app/views/wallaby/resources/index/integer{_en,}{_html,}.rb
    # ```
    #
    # Wallaby adds it to the front of the whole query as below:
    #
    # ```
    # {app/views/wallaby/resources/index/integer{_en,}{_html,}.rb,
    # app/views/wallaby/resources/index/_integer{.en,}{.html,}{.erb,}}
    # ```
    # @param path [String]
    # @param details [Hash]
    #   see {https://api.rubyonrails.org/classes/ActionView/LookupContext/ViewPaths.html#method-i-detail_args_for
    #   Detials from ViewPaths}
    # @return [String] a path query
    if Rails::VERSION::MAJOR >= 6
      def find_template_paths_from_details(path, details)
        # Instead of checking for every possible path, as our other globs would
        # do, scan the directory for files with the right prefix.
        query = "#{escape_entry(File.join(@path, path))}*"

        base_dir, file_name, locales, formats = additional_query(query, details)
        query = "{#{"#{base_dir}/#{file_name}{#{locales}}{#{formats}}.rb"},#{query}}" if base_dir

        regex = build_regex(path, details)

        Dir[query].uniq.reject do |filename|
          # This regex match does double duty of finding only files which match
          # details (instead of just matching the prefix) and also filtering for
          # case-insensitive file systems.
          !regex.match?(filename) ||
              File.directory?(filename)
        end.sort_by do |filename|
          # Because we scanned the directory, instead of checking for files
          # one-by-one, they will be returned in an arbitrary order.
          # We can use the matches found by the regex and sort by their index in
          # details.
          match = filename.match(regex)
          EXTENSIONS.keys.reverse.map do |ext|
            if ext == :variants && details[ext] == :any
              match[ext].nil? ? 0 : 1
            elsif match[ext].nil?
              # No match should be last
              details[ext].length
            else
              found = match[ext].to_sym
              details[ext].index(found)
            end
          end
        end
      end

      def additional_query(query, details)
        origin = query
        file_name = origin[%r{(?<=/_)[^/\{]+}]
        return unless file_name
        base_dir = origin.gsub(%r{/[^/]*$}, '')
        locales = convert details[:locale]
        formats = convert details[:formats]
        [base_dir, file_name, locales, formats]
      end

      def build_regex(path, details)
        query = escape_entry(File.join(@path, path))

        exts = EXTENSIONS.map do |ext, prefix|
          match =
              if ext == :variants && details[ext] == :any
                ".*?"
              else
                details[ext].compact.uniq.map { |e| Regexp.escape(e) }.join("|")
              end
          prefix = Regexp.escape(prefix)
          "(#{prefix}(?<#{ext}>#{match}))?"
        end.join
        base_dir, file_name, locales, formats = additional_query(query, details)
        query = "#{"#{base_dir}/#{file_name}(#{locales[0..-2]})*(#{formats[0..-2]})*.rb"}|#{query}" if base_dir
        %r{\A#{query}#{exts}\z}
      end
    else
      def build_query(path, details)
        origin = super
        file_name = origin[%r{(?<=/_)[^/\{]+}]
        return origin unless file_name
        base_dir = origin.gsub(%r{/[^/]*$}, '')
        locales = convert details[:locale]
        formats = convert details[:formats]
        cell = "#{base_dir}/#{file_name}{#{locales}}{#{formats}}.rb"
        "{#{cell},#{origin}}"
      end
    end

    private

    # @example concat a list of values into a string
    #   convert(['html', 'csv']) # => '_html,_cvs,'
    # @param values [Array<String>]
    def convert(values)
      (values.map { |v| "_#{v}" } << '').join ','
    end
  end
end
