require 'rails_helper'

feature 'reviewing restaurants' do
  context 'when restaurants have been added' do
    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'display all restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
    
    scenario 'let a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end

  end

  context 'if not signed in, user cannot' do
    before {Restaurant.create name: 'KFC'}
    scenario 'create restaurant' do
      visit '/restaurants'
      expect(page).not_to have_link 'Add a restaurant'
    end
    scenario 'edit restaurant' do
      visit '/restaurants'
      expect(page).not_to have_link 'Edit KFC'
    end
    scenario 'delete restaurant' do
      visit '/restaurants'
      expect(page).not_to have_link 'Delete KFC'
    end
  end

  def user_sign_in
    visit '/restaurants'
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
  end

  context 'if user is signed in' do
    before {user_sign_in}

    context 'and no restaurants have been added' do
      scenario 'display a prompt to add a restaurant' do
        visit '/restaurants'
        expect(page).to have_content 'No restaurants yet'
        expect(page).to have_link 'Add a restaurant'
      end
    end

    context 'user can add a restaurant' do
      scenario 'by filling out a form' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KFC'
        click_button 'Create Restaurant'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end

      scenario 'that has a valid length of restaurant name' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  
    context 'user can edit restaurants' do

      before {Restaurant.create name: 'KFC'}

      scenario 'by editing the details' do
        visit '/restaurants'
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(current_path).to eq '/restaurants'
      end

    end

    context 'user can delete restaurants' do

      before { Restaurant.create name: 'KFC' }

      scenario 'by clicking the delete link' do
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted successfully'
      end

    end
  end
end
