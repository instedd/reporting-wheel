class AddUserIdToWheel < ActiveRecord::Migration
  def self.up
    add_column :wheels, :user_id, :integer

    # Make default User
    user = User.create! :username => 'instedd', :password => 'instedd', :password_confirmation => 'instedd'

    # Add all wheels to the default user
    Wheel.all.each do |wheel|
      wheel.user = user
      wheel.save!
    end
  end

  def self.down
    remove_column :wheels, :user_id
  end
end