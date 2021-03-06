require 'rails_helper'

describe "Edit idea page" do
	let(:user_moderator){ FactoryGirl.create(:user_moderator) }
	let(:idea){ FactoryGirl.create(:idea) }
	let!(:tag){ FactoryGirl.create(:tag) }

  it "should contain label Tags and a default tag"	do  	
  	page.set_rack_session(:user_id => user_moderator.id)
  	page.visit edit_idea_path(idea)
  	expect(page).to have_content 'Tags'
  	expect(page).to have_content 'tag text'
  end

  it "should contain correct tags and checkboxes are correctly checked"	do
  	idea.tags << FactoryGirl.create(:tag, text:"Kumpula")
  	page.set_rack_session(:user_id => user_moderator.id)
  	page.visit edit_idea_path(idea)
        expect(find('input[value="tag text"]')).not_to be_checked
        expect(find('input[value="Kumpula"]')).to be_checked
  end

  it "uncheck tag works correctly" do
    idea.tags << FactoryGirl.create(:tag, text:"Kumpula")
    page.set_rack_session(:user_id => user_moderator.id)
    page.visit edit_idea_path(idea)
    expect(find('input[value="tag text"]')).not_to be_checked
    expect(find('input[value="Kumpula"]')).to be_checked

    find('input[value="Kumpula"]').set(false)    
    expect(find('input[value="Kumpula"]')).not_to be_checked

    click_button('Update Idea')
    click_link('Muokkaa')
    expect(find('input[value="Kumpula"]')).not_to be_checked
  end

  it "check tag works correctly" do
    idea.tags << FactoryGirl.create(:tag, text:"Kumpula")
    page.set_rack_session(:user_id => user_moderator.id)
    page.visit edit_idea_path(idea)
    expect(find('input[value="tag text"]')).not_to be_checked
    expect(find('input[value="Kumpula"]')).to be_checked

    find('input[value="tag text"]').set(true)
    expect(find('input[value="tag text"]')).to be_checked

    click_button('Update Idea')
    click_link('Muokkaa')
    expect(find('input[value="tag text"]')).to be_checked    
  end
    
  it "check that enable moderator works correctly" do
    page.set_rack_session(:user_id => user_moderator.id)
    page.visit edit_idea_path(idea)
    expect(page).to have_content('Moderointi päälle')
      click_link("Moderointi päälle")
      expect(page).to have_content('Kommenttien moderointi päällä')

      click_link('Muokkaa')
      expect(page).to have_content('Moderointi pois')
      click_link("Moderointi pois")
      expect(page).to have_content('Kommenttien moderointi pois päältä')
  end
end
