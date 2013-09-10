require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

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
          signup("Confirm Password" => "")
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
          signup("Password" => "foo", "Confirm Password" => "foo")
          click_button submit
        end

        it { should have_content('1 error') }
        it { should have_content("Password is too short (minimum is 6 characters)") }
      end

      describe "password != password confirmation" do
        before do
          signup("Confirm Password" => "foo")
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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        update(user, "Name" => new_name, "Email" => new_email)
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end