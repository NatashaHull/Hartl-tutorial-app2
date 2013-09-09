require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end


  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end

      describe "without name" do
        before do
          signup("Name" => "")
          click_button submit
        end

        it { should have_content('1 error') }
        it { should have_content("Name can't be blank") }
      end

      describe "without email" do
        before do
          signup("Email" => "")
          click_button submit
        end

        it { should have_content('2 errors') }
        it { should have_content("Email can't be blank") }
        it { should have_content("Email is invalid") }
      end

      describe "without password" do
        before do
          signup("Password" => "")
          click_button submit
        end

        it { should have_content('2 errors') }
        it { should have_content("Password can't be blank") }
        it { should have_content("Password is too short (minimum is 6 characters)") }
      end

      describe "without password confirmation" do
        before do
          signup("Confirmation" => "")
          click_button submit
        end

        it { should have_content('2 errors') }
        it { should have_content("Password confirmation doesn't match Password") }
        it { should have_content("Password confirmation can't be blank") }
      end

      describe "invalid email" do
        before do
          signup("Email" => "foo")
          click_button submit
        end

        it { should have_content('1 error') }
        it { should have_content("Email is invalid") }
      end

      describe "invalid password" do
        before do
          signup("Password" => "foo", "Confirmation" => "foo")
          click_button submit
        end

        it { should have_content('1 error') }
        it { should have_content("Password is too short (minimum is 6 characters)") }
      end

      describe "password != password confirmation" do
        before do
          signup("Confirmation" => "foo")
          click_button submit
        end

        it { should have_content('1 error') }
        it { should have_content("Password confirmation doesn't match Password") }
      end
    end

    describe "with valid information" do
      before { signup }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link("Sign out") }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end
end