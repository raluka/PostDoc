class CreateEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :emails do |t|
      t.references :mailbox, null: false, foreign_key: {
        on_delete: :cascade,
        on_update: :cascade
      }
      t.string :template_id, null: false
      t.string :rendered_html, null: false

      t.jsonb :email_payload
      t.jsonb :template_payload

      t.timestamps
    end
  end
end
