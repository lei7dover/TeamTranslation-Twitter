class Rant < ActiveRecord::Base
  belongs_to :user
  validates :content, length: {maximum: 170}
  acts_as_followable

  def self.timeline(user)
    following_ids = user.all_following.map(&:id)
    all_ids= following_ids << user.id
    Rant.where(user_id: all_ids).order("created_at DESC")
  end

end
