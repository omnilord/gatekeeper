module Database
  class Greeting < Sequel::Model(Setting.where(setting: 'greeting'))
    dataset_module do
      def for(sid)
        first(entity_id: sid)
      end

      def upsert(**fields)
        fields[:updated_at] = Sequel::CURRENT_TIMESTAMP
        fields[:setting] = 'greeting'
        returning.insert_conflict(
                   target: [:entity_id, :setting],
                   update: fields
                 )
                 .insert(fields.merge(created_at: fields[:updated_at]))
      end

      def toggle(sid, active = nil)
        record = self.for(sid)

        unless record.nil?
          toggle_val = !(active.nil? ? record.active : !active)
          
          if record.active != toggle_val
            record.updated_at = Sequel::CURRENT_TIMESTAMP
            record.active = toggle_val
            record.save
          end
        end

        record
      end

      def remove(sid)
        first(entity_id: sid).tap do |greeting|
          unless greeting.nil?
            Database::Greeting.first(id: greeting[:id]).destroy
            greeting[:deleted] = true
          end
        end
      end
    end


    def validate
      super
      errors.add(:value, 'Message must be present.') if value['message'].length < 3
      errors.add(:value, 'Message cannot be longer than 2000 characters.') if value['message'].length > 2000
    end
  end
end
