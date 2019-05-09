class CreateSettingsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.bigint :entity_id, null: false, index: true
      t.text :setting, null: false
      t.boolean :active, null: false, default: true
      t.jsonb :value

      t.timestamps
    end

    add_index :settings, [:entity_id, :setting], unique: true
  end
end
