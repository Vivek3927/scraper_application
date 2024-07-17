class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :location
      t.text :short_description
      t.string :yc_batch
      t.string :website
      t.string :founders
      t.text :linkedin_urls

      t.timestamps
    end
  end
end
