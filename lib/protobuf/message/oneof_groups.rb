module Protobuf
  class Message
    module OneofGroups
      def self.extended(other)
        other.extend(ClassMethods)
      end

      module ClassMethods
        # Define a oneOf group
        #
        def oneof_group(group_name, field_names)
          oneof_groups[group_name] = field_names
        end

        def get_oneof_group(group_name)
          oneof_groups[group_name]
        end

        def raise_if_oneof_group_name_collision(group_name)
          if get_oneof_group(group_name)
            fail DuplicateOneofGroupNameError, %(Oneof group name #{group_name} has already been used in "#{name}".)
          end
        end

        def oneof_groups
          @oneof_groups ||= {}
        end
      end
    end
  end
end
