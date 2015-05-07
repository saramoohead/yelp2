require 'rails_helper'

feature 'user tracking' do

  context 'if user is not signed in' do
    it "user should see 'sign in' and 'sign' up link" do
      visit ('/')
      expect(page).to have_link('Sign in')
      expect(page).to have_link('Sign up')
    end

    it "and user should not see 'sign out' link" do
      visit ('/')
      expect(page).not_to have_link('Sign out')
    end
  end

  context "if user is signed in" do
    before do
      visit('/')
      click_link('Sign up')
      fill_in('Email', with: 'test@example.com')
      fill_in('Password', with: 'testtest')
      fill_in('Password confirmation', with: 'testtest')
      click_button('Sign up')
    end

    it "user should see 'sign out' link" do
      visit ('/')
      expect(page).to have_link('Sign out')
    end

    it "user should not see 'sign in' and 'sign in' link" do
      visit ('/')
      expect(page).not_to have_link('Sign in')
      expect(page).not_to have_link('Sign up')
    end
  end

end
