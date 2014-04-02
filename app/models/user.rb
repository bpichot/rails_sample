# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  encrypted_password :string(255)
#  salt               :string(255)
#
require 'digest'

class User < ActiveRecord::Base
    attr_accessor :password
    attr_accessible :email, :name, :password, :password_confirmation

    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates :name, :presence => true,
        :length => {:maximum => 50}
    validates :email, :presence => true,
        :format => {:with => email_regex},
        :uniqueness => {:case_sensitive => false}
    validates :password, :presence => true,
                         :confirmation => true,
                         :length => {:within => 6..40}

    before_save :encrypt_password

    def has_password?(submitted_password)
        self.encrypted_password == encrypt(submitted_password)
    end

    def self.authenticate(submitted_email, submitted_password)
        user = self.find_by_email(submitted_email)
        return nil if user.nil?
        return user if user.has_password?(submitted_password)
    end

    private

        def encrypt_password
            self.salt = make_salt if new_record?
            self.encrypted_password = encrypt(password)
        end

        def encrypt(string)
            secure_password("#{salt}--#{string}")
        end

        def make_salt
            secure_password("#{Time.now.utc}--#{self.password}")
        end

        def secure_password(string)
            Digest::SHA256.hexdigest(string)
        end
end
