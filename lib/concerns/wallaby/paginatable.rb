# frozen_string_literal: true

module Wallaby
  # Paginator related attributes
  module Paginatable
    # Model paginator for current modal class.
    # @return [Class] model paginator class
    # @see PaginatorFinder#execute
    def current_paginator
      @current_paginator ||=
        PaginatorFinder.new(
          script_name: script_name,
          model_class: current_model_class,
          current_controller_class: controller_configuration
        ).execute.try do |klass|
          Logger.debug %(Current paginator: #{klass}), sourcing: false
          klass.new current_model_class, collection, params
        end
    end

    # To paginate the collection but only when either `page` or `per` param is given,
    # or HTML response is requested
    # @param query [#each]
    # @param options [Hash]
    # @option options [Boolean] :paginate whether collection should be paginated
    # @return [#each]
    # @see ModelServicer#paginate
    def paginate(query, options = { paginate: true })
      options[:paginate] ? current_servicer.paginate(query, params) : query
    end
  end
end
