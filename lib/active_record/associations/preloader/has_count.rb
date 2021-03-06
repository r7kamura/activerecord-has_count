module ActiveRecord
  module Associations
    class Preloader
      class HasCount < SingularAssociation
        def association_key_name
          reflection.foreign_key
        end

        def owner_key_name
          reflection.active_record_primary_key
        end

        private

        def preload(preloader)
          associated_records_by_owner(preloader).each do |owner, associated_records|
            count = associated_records.count

            association = owner.association(reflection.name)
            association.target = count
          end
        end

        def load_slices(slices)
          @preloaded_records = slices.flat_map { |slice|
            records_for(slice)
          }

          @preloaded_records.map { |record|
            key = record
            [record, key]
          }
        end

        def query_scope(ids)
          scope.where(association_key.in(ids)).pluck(association_key_name)
        end
      end

      private

      def preloader_for_with_has_count(reflection, owners, rhs_klass)
        preloader = preloader_for_without_has_count(reflection, owners, rhs_klass)
        return preloader if preloader

        case reflection.macro
        when :has_count
          HasCount
        end
      end
      alias_method_chain :preloader_for, :has_count
    end
  end
end
