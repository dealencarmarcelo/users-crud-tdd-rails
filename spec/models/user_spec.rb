require 'rails_helper'
require 'shoulda/matchers'

describe User, type: :model do
    let(:user) { build(:user) }

    it { should validate_presence_of(:fullname) }
    it { should validate_presence_of(:surname) }

    it { should validate_presence_of(:email) }
    it { should allow_values('isimple@example.com', 'very.common@example.com', 'disposable.style.email.with+symbol@example.com', 'other.email-with-hyphen@example.com').for(:email) }
    it { should_not allow_values('Abc.example.com', 'A@b@c@example.com').for(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should validate_presence_of(:password_digest) }
    it { should validate_length_of(:password_digest).is_at_least(6) }

    it { should validate_presence_of(:phone) }
    it { should validate_length_of(:phone).is_equal_to(14) }
end
