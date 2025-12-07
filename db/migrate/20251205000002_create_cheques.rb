class CreateCheques < ActiveRecord::Migration[8.1]
  def change
    create_table :cheques, id: :uuid do |c|
      c.integer :value, null: false, default: 0
      c.integer :processing_days, null: false, default: 0
      c.date :due_date, null: false
      c.timestamps

      c.uuid :bordero_id, null: false
    end

    add_foreign_key :cheques, :borderos
    add_index :cheques, :bordero_id
  end
end
