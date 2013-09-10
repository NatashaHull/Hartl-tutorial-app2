include ApplicationHelper

def signup(options={})
  fill_in "Name",         with: "Example User"
  fill_in "Email",        with: "user@example.com"
  fill_in "Password",     with: "foobar"
  fill_in "Confirm Password", with: "foobar"
  options.each do |k, v|
    fill_in k, with: v
  end
end

def signin(user, options={})
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  options.each do |k, v|
    fill_in k, with: v
  end
end

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    signin(user)
    click_button "Sign in"
  end
end

def update(user, options={})
  fill_in "Name",             with: user.name
  fill_in "Email",            with: user.email
  fill_in "Password",         with: user.password
  fill_in "Confirm Password", with: user.password
  options.each do |k, v|
    fill_in k, with: v
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end