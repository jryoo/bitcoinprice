class AddCarrierToMembers < ActiveRecord::Migration
  def change
    add_column :members, :carrier, :string
  end
end
