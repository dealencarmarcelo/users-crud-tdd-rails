class User < ApplicationRecord
    has_secure_password
    acts_as_paranoid

    validates_presence_of :fullname, :surname, :email
    validates :phone, presence: true, length: { is: 14 }
    
    validates :password_digest, presence: true, length: { minimum: 6 }

    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    validates_uniqueness_of :email, case_sensitive: false
    
    validates_uniqueness_of :phone

end