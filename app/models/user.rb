# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  email                        :string           default(""), not null
#  encrypted_password           :string           default(""), not null
#  reset_password_token         :string
#  reset_password_sent_at       :datetime
#  remember_created_at          :datetime
#  sign_in_count                :integer          default(0), not null
#  current_sign_in_at           :datetime
#  last_sign_in_at              :datetime
#  current_sign_in_ip           :inet
#  last_sign_in_ip              :inet
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  provider                     :string
#  uid                          :string
#  name                         :string
#  token                        :string
#  gender                       :integer          default("male")
#  address                      :string
#  date_of_birth                :datetime
#  year_of_graduation           :integer
#  work_place                   :string
#  course_studied               :string
#  field_of_expertise           :string
#  bio                          :string
#  slug                         :string
#  profile_picture_file_name    :string
#  profile_picture_content_type :string
#  profile_picture_file_size    :integer
#  profile_picture_updated_at   :datetime
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :profile_picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\z/

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :discussions, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_discussions, through: :likes, source: :discussion

  validates :gender, presence: :true
  validates_uniqueness_of :name

  enum gender: { male: 0, female: 1, not_sure: 2, prefer_not_to_disclose: 3 }

  def chg_password(attributes)
    update(password: attributes[:new_password], password_confirmation: attributes[:new_password_confirmation])
  end



  def self.from_omniauth(auth, signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user.present?
      user
    else
      # Check whether there is already a user with the same
      # email address
      user_with_email = User.find_by_email(auth.info.email)
      if user_with_email.present?
        user = user_with_email
      else
        user = User.new
        if auth.provider == "facebook"
          user.provider = auth.provider
          user.uid = auth.uid
          user.token = auth.credentials.token
          user.name = auth.extra.raw_info.name
          user.email = auth.extra.raw_info.email
          # Facebook's token doesn't last forever
          user.save
        elsif auth.provider == "linkedin"

          user.provider = auth.provider
          user.uid = auth.uid
          user.token = auth.credentials.token
          user.name = auth.info.name
          user.email = auth.info.email
          user.save
        elsif auth.provider == "twitter"

          user.provider = auth.provider
          user.uid = auth.uid
          user.oauth_token = auth.credentials.token

          user.oauth_user_name = auth.extra.raw_info.name

        elsif auth.provider == "google_oauth2"
          user.provider = auth.provider
          user.uid = auth.uid
          user.token = auth.credentials.token
          user.name = auth.info.name
          user.email = auth.info.email
          # Google's token doesn't last forever
          user.save
        end
      end
    end
    return user
  end
  # For Twitter (save the session eventhough we redirect user to registration page first)
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end
  # For Twitter (disable password validation)
  def password_required?
    super && provider.blank?
  end


end
