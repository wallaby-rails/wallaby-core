# frozen_string_literal: true

module Wallaby
  # Paginator related attributes
  module Paginatable
    # Model paginator for current modal class. It comes from:
    #
    # - controller configuration {Wallaby::Configurable::ClassMethods#model_paginator .model_paginator}
    # - a generic paginator based on {Wallaby::Configurable::ClassMethods#application_paginator .application_paginator}
    # @return [Class] model paginator class
    def current_paginator
      @current_paginator ||=
        (controller_configuration.model_paginator \
          || Map.paginator_map(current_model_class, controller_configuration.application_paginator)).try do |klass|
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
    # @see Wallaby::ModelServicer#paginate
    def paginate(query, options)
      options[:paginate] ? current_servicer.paginate(query, params) : query
    end
  end
end
