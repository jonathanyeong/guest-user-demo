class AllowAnonymousSignIn < ActiveRecord::Migration[8.0]
  def change
    # Remove email address index since we're making email address nullable
    remove_index :users, :email_address
    # Set these columns as nullable so we can create a guest user
    change_column_null :users, :email_address, true
    change_column_null :users, :password_digest, true
    # Provider type will be an enum in the model: Anonymous is the only type right now
    add_column :users, :provider_type, :string
    # A UUID to assign a user (so someone can't easily guess another user ID)
    add_column :users, :uid, :string
    # The UID is the new index for faster searches and uniqueness constraint
    add_index :users, :uid, unique: true
  end
end
