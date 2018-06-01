# == Schema Information
#
# Table name: discussions
#
#  id         :integer          not null, primary key
#  body       :text
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_discussions_on_slug     (slug) UNIQUE
#  index_discussions_on_user_id  (user_id)
#

class Discussion < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  acts_as_commentable

  scope :sorted, lambda {order('created_at DESC')}

  def already_likes?(post)
    self.likes.find(:all, :conditions => ['post_id = ?', post.id]).size > 0
  end

  def user_likes(current_user, post_id)
    likes.find(:first, :conditions => ['user_id = ? AND post_id = ?', current_user, post_id] ).nil?
  end

  def liked(discussion)
    likes.find where [:discussion_id => discussion.id ]
  end

  validates :body, presence: true

end
