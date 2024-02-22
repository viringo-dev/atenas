require 'rails_helper'

RSpec.describe User, type: :model do

  describe "Validations" do
    subject { build_stubbed(:user) } 
    it { should validate_presence_of(:password).with_message(I18n.t("activerecord.errors.models.user.attributes.password.blank")) }
    it { should validate_presence_of(:name).with_message(I18n.t("activerecord.errors.models.user.attributes.name.blank")) }
    it { should validate_presence_of(:surname).with_message(I18n.t("activerecord.errors.models.user.attributes.surname.blank")) }
    it { should validate_presence_of(:email).with_message(I18n.t("activerecord.errors.models.user.attributes.email.blank")) }
    it { should validate_presence_of(:username).with_message(I18n.t("activerecord.errors.models.user.attributes.username.blank")) }

    it "is not valid with email foo@example" do
      subject.email = "foo@example"
      expect(subject).to_not be_valid
    end

    it "is valid with email foo@example.com" do
      subject.email = "foo@example.com"
      expect(subject).to be_valid
    end

    it "is not valid if phone contains letters" do
      subject.phone = "98765432a"
      expect(subject).to_not be_valid
    end

    it "is valid if phone contains only numbers" do
      subject.phone = "987654321"
      expect(subject).to be_valid
    end

    it "is not valid if phone contains numbers and country code" do
      subject.phone = "+51 987654321"
      expect(subject).to_not be_valid
    end

    it "is not valid if username contains space or symbol different than underscore" do
      subject.username = "foo bar"
      expect(subject).to_not be_valid
      subject.username = "foo$bar"
      expect(subject).to_not be_valid
      subject.username = "foo-bar"
      expect(subject).to_not be_valid
    end

    it "is valid if username contains number, letter, or underscore" do
      subject.username = "foobar"
      expect(subject).to be_valid
      subject.username = "foo_bar"
      expect(subject).to be_valid
      subject.username = "foobar2000"
      expect(subject).to be_valid
    end

    it "is not valid if password length is less than 8" do
      subject.password = "abd123"
      expect(subject).to_not be_valid
    end

    it "is valid if password length is greather or equal than 8" do
      subject.password = "abcd1234"
      expect(subject).to be_valid
    end

    it "is not valid if password does not contain numbers and letters" do
      subject.password = "12345678"
      expect(subject).to_not be_valid
      subject.password = "abcdefgh"
      expect(subject).to_not be_valid
    end

    it "is valid if password contains numbers and letters" do
      subject.password = "abcd1234"
      expect(subject).to be_valid
    end
  end

  describe "Callbacks" do
    describe "downcase_email" do
      context "when email has uppercased characters" do
        subject { create(:user, email: "FOO@EXAMPLE.COM") } 
        it "should convert to downcase" do
          expect(subject.email).to eq("foo@example.com")
        end
      end
    end
  end
end
