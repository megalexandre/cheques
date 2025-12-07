class CreateBorderos < ActiveRecord::Migration[8.1]
  def change
    enable_extension 'pgcrypto'

    create_table :borderos, id: :uuid do |t|
      t.date :exchange_date, null: false
      t.decimal :monthly_interest, precision: 10, scale: 4, null: false

      t.timestamps
    end
  end
end
