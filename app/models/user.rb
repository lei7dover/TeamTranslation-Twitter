class User < ActiveRecord::Base
  has_many :rants
  acts_as_authentic do |c|
    c.login_field = :username
  end
  has_many :follower_relationships, class_name: "Relationship", foreign_key:"followed_id"
  has_many :followed_relationships, class_name: "Relationship", foreign_key:"follower_id"
  has_many :followers, through: :follower_relationships
  has_many :followeds, through: :followed_relationships

  def following? user
    self.followeds.include? user
  end

  def follow user
    Relationship.create follower_id: self.id, followed_id: user.id
  end

  def relate(user)
    Relationship.where(follower_id: self.id,
    followed_id: user.id).first_or_initialize
  end

  def all_following
    followeds
  end

end
