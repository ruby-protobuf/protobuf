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

        def after_filter(*args)
          set_filters(:after, args)
        end

        def around_filter(*args)
          set_filters(:around, args)
        end

        def before_filter(*args)
          set_filters(:before, args)
        end

        private

        def set_filters(type, *args)
          opts = args.last.is_a?(Hash) ? args.pop : {}
          args.each do |callable|
            case
            when callable.respond_to?(:call) then
              # no-op
            when self.instance_methods.include?(callable) then
              callable = method(callable)
            else
              raise "Filter #{callable} must be an instance method or be callable"
            end

            filters[type] = callable
          end
        end

        def filters
          @filters ||= Hash.new { |h,k| h[k] = Set.new }
        end

      end

      module InstanceMethods

        private

        def enumerated_filter_call
          lambda { |filter| filter.call }
        end

        def run_after_filters
          filters[:after].each(&enumerated_filter_call)
        end

        def run_around_filters(final)
          filters[:around].reverse.inject(final) { |previous, filter|
            lambda { __send__(filter, &previous) }
          }.call
        end

        def run_before_filters
          filters[:before].each(&enumerated_filter_call)
        end


        def run_filters(&final)
          run_before_filters
          run_around_filters(final)
          run_after_filters
        end

      end

    end
  end
end
