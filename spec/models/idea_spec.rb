require 'rails_helper'

RSpec.describe Idea, type: :model do
    let(:user){ FactoryGirl.create(:user) }
    let(:user_admin){ FactoryGirl.create(:user_admin) }
    let(:user_moderator){ FactoryGirl.create(:user_moderator) }

  it "has factory make idea" do
    idea = FactoryGirl.create(:idea)
    expect(idea.topic).to eq("idea topic")
    expect(idea.text).to eq("idea text")
    expect(idea.histories).not_to be_empty      

    idea.tags << [FactoryGirl.create(:tag)]
    expect(idea.tags).not_to be_empty
  end

  it "is created with correct default moderate value" do
    idea = FactoryGirl.create(:idea)
    expect(idea.moderate).to be false
  end

  it "is created with correct moderate value" do
    idea = FactoryGirl.create(:idea_moderate_enabled)
    expect(idea.moderate).to be true
  end

  it "has factory make idea with all" do
    idea = FactoryGirl.create(:idea)    
    idea.likes << FactoryGirl.create(:like, idea_id: idea.id)
    expect(idea.topic).to eq("idea topic")
    expect(idea.text).to eq("idea text")
    expect(idea.likes.count).to eq(1)
    expect(idea.histories).not_to be_empty      

    idea.tags << [FactoryGirl.create(:tag)]
    expect(idea.tags).not_to be_empty
  end

  it "has factory make idea with no histories" do
    idea = FactoryGirl.build(:idea, histories: [])    
    expect(idea).not_to be_valid
  end

  it "has factory make idea with no text" do
    idea = FactoryGirl.build(:idea, text: nil)
    expect(idea).not_to be_valid
  end

  it "has factory make idea with too long topic" do
    idea = FactoryGirl.build(:idea, topic: "This topic is too long for it to be valid, and should make the idea invalid and thus this test should work, nice")
    expect(idea).not_to be_valid
  end

  it "has factory make idea with too short topic" do
    idea = FactoryGirl.build(:idea, topic: "1")
    expect(idea).not_to be_valid
  end

    it "has factory make idea with blank topic" do
    idea = FactoryGirl.build(:idea, topic: "           ")
    expect(idea).not_to be_valid
  end

    it "has factory make idea with no topic" do
    idea = FactoryGirl.build(:idea, topic: nil)
    expect(idea).not_to be_valid
  end


end
