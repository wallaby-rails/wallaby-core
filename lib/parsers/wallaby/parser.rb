# frozen_string_literal: true

module Wallaby
  # a parser to handle colon query
  class Parser < Parslet::Parser
    # Case insensitive string match
    # @param str [String]
    def stri(str)
      str.chars.map! { |c| match "[#{c.upcase}#{c.downcase}]" }.reduce :>>
    end

    root(:statement)
    rule(:statement) { expression >> (spaces >> expression).repeat }
    rule(:expression) { colon_query | general_keyword }
    rule(:colon_query) do
      name.as(:left) >> operator.as(:op) >> keywords.as(:right)
    end
    rule(:name) { (spaces.absent? >> colon.absent? >> any).repeat(1) }
    rule(:operator) { colon >> match('[^\s\'\"\:\,0-9a-zA-Z]').repeat(0, 3) }
    rule(:keywords) { general_keyword >> (comma >> general_keyword).repeat }
    rule(:general_keyword) { quoted_keyword | keyword }

    # basic elements
    rule(:quoted_keyword) do
      open_quote >>
        (close_quote.absent? >> any).repeat.as(:string) >>
        close_quote
    end
    rule(:keyword) do
      null.as(:null) | boolean.as(:boolean) | number.as(:number) | \
        ((spaces | comma).absent? >> any).repeat.as(:string)
    end
    rule(:number) { (digits >> dot).maybe >> digits }

    # atomic entities
    rule(:null) { stri('nil') | stri('null') }
    rule(:boolean) { stri('true') | stri('false') }
    rule(:digits) { match('\d').repeat(1) }
    rule(:dot) { str('.') }
    rule(:comma) { str(',') }
    rule(:spaces) { match('\s').repeat(1) }
    rule(:colon) { str(':') }

    # open-close elements
    rule(:open_quote) { match('[\'\"]').capture(:quote) }
    rule(:close_quote) { dynamic { |_src, ctx| str(ctx.captures[:quote]) } }
  end
end
