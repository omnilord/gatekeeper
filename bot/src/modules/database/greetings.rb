module Database
  class Greeting < Sequel::Model(Setting.where(setting: 'greeting', active: true))
    dataset_module do
      def for(id)
        where(entity_id: id)&.first
      end
    end
  end
end
