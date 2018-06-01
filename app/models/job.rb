# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  category_id :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#
# Indexes
#
#  index_jobs_on_user_id  (user_id)
#

class Job < ApplicationRecord

  acts_as_taggable

  belongs_to :user
  belongs_to :category

  scope :sorted, lambda {order('created_at DESC')}

  scope :with_tag, -> (tag) { tagged_with(tag) if tag.present? }

end
