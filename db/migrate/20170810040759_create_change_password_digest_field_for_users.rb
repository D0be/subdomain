class CreateChangePasswordDigestFieldForUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column('Users', 'passwor_digest', 'password_digest')  
  end
end
