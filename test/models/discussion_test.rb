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

require 'test_helper'

class DiscussionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
