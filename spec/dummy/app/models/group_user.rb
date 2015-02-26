class GroupUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  has_many :group_users
  has_many :users, through: :group_users
end
