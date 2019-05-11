module Database
  module_function

  Setting = DB[:settings]

  SETTABLES = %i[role greeting].freeze

  def settable(name, &block)
    s = name.to_s.downcase

    self.const_set(s.capitalize, Class.new(Sequel::Model(Setting.where(setting: s))) do
      dataset_module do
        def for(sid)
          first(entity_id: sid)
        end

        def upsert(**fields)
          fields[:updated_at] = Sequel::CURRENT_TIMESTAMP
          fields[:setting] = s
          returning.insert_conflict(
                     target: [:entity_id, :setting],
                     update: fields
                   ).insert(fields.merge(created_at: fields[:updated_at]))
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
          first(entity_id: sid).tap do |record|
            unless record.nil?
              Database::Greeting.first(id: record[:id]).destroy
              record[:deleted] = true
            end
          end
        end
      end
    end)
  end

  SETTABLES.each(&self.method(:settable))
end
