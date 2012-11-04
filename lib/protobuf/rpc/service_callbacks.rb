module Protobuf
  module Rpc
    module ServiceCallbacks
      include ActiveSupport::Callbacks

      def self.included(other)
        other.class_eval do
          extend Protobuf::Rpc::ServiceCallbacks::ClassMethods
          include Protobuf::Rpc::ServiceCallbacks::InstanceMethods
        end
      end

      module ClassMethods

        [:after, :around, :before].each do |type|
          # Setter DSL method for given filter types.
          #
          define_method "#{type}_filter" do |*args|
            set_filters(type, *args)
          end
        end

        # Filters hash keyed based on filter type (e.g. :before, :after, :around),
        # whose values are Sets.
        #
        def filters
          @filters ||= Hash.new { |h,k| h[k] = [] }
        end

        private


        def defined_filters
          @defined_filters ||= Hash.new { |h,k| h[k] = Set.new }
        end

        # Check to see if the filter has been defined.
        #
        def filter_defined?(type, filter)
          defined_filters[type].include?(filter)
        end

        # Remember that we stored the filter.
        #
        def remember_filter(type, filter)
          defined_filters[type] << filter
        end

        # Takes a list of actually (or potentially) callable objects.
        # TODO add support for if/unless
        # TODO add support for only/except sub-filters
        #
        def set_filters(type, *args)
          opts = args.last.is_a?(Hash) ? args.pop : {}
          args.each do |filter|
            next if filter_defined?(type, filter)
            filters[type] << filter
            remember_filter(type, filter)
          end
        end

      end

      module InstanceMethods

        private

        # Enumerator block given to Set#each to simply call the given filter.
        # See #run_after_filters, #run_before_filters
        #
        def enumerated_filter_call
          lambda { |filter| __send__(filter) }
        end

        # Get back to class filters.
        #
        def filters
          self.class.filters
        end

        # Loop over the after filters and invoke them.
        #
        def run_after_filters
          filters[:after].each(&enumerated_filter_call)
        end

        # Reverse build a chain of around filters. To implement an around chain,
        # simply build a method that yields control when it expects the underlying
        # method to be invoked. If the endpoint should not be run (due to some
        # condition), simply do not yield.
        #
        # Around filters are invoked in the order they are defined, outer to inner,
        # with the inner-most method called being the actual rpc endpoint.
        #
        # Let's say you have a class defined with the following filters:
        #
        #   class MyService
        #     around_filter :filter1, :filter2, :filter3
        #
        #     def my_endpoint
        #       # do stuff
        #     end
        #   end
        #
        # When the my_endpoint method is invoked using Service#callable_rpc_method,
        # It is similar to this call chain:
        #
        #   filter1 do
        #     filter2 do
        #       filter3 do
        #         my_endpoint
        #       end
        #     end
        #   end
        #
        def run_around_filters(final)
          filters[:around].reverse.inject(final) { |previous, filter|
            lambda { __send__(filter, &previous) }
          }.call
        end

        # Loop over the before filters and invoke them.
        #
        def run_before_filters
          filters[:before].each(&enumerated_filter_call)
        end


        # Entry method to call each filter type in the appropriate order. This should
        # be used instead of the other run methods directly.
        #
        def run_filters(&final)
          run_before_filters
          run_around_filters(final)
          run_after_filters
        end

      end

    end
  end
end
