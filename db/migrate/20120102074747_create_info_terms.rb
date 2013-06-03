class CreateInfoTerms < ActiveRecord::Migration
  def change
    create_table :info_terms do |t|
      t.references :subject_info
      t.references :term

      t.timestamps
    end
    add_index :info_terms, :subject_info_id
    add_index :info_terms, :term_id
  end
end
