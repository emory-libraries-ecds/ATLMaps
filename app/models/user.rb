# Model class for a User.
class User < ApplicationRecord
    has_one :login
    belongs_to :institution
    has_many :collaboration
    has_many :projects, through: :collaboration, dependent: :destroy
    has_many :user_tagged, dependent: :destroy

    validates :email, uniqueness: { allow_blank: true }

    # def number_tagged
    #     user_tagged.count
    # end

    def confirmed
        return login.email_confirmed? || login.provider?
    end

    def confirmation_token
        return if login.confirm_token.present?
        login.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
end
