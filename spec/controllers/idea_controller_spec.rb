require 'rails_helper'

RSpec.describe IdeasController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:user_admin) { FactoryGirl.create(:user_admin) }
  let(:user_moderator) { FactoryGirl.create(:user_moderator) }

  it 'can be published by moderator' do
    session[:user_id] = user_moderator.id
    @idea = FactoryGirl.create(:idea)
    expect { post :publish, params: { id: @idea.id } }.to change(@idea.histories, :count).by(1)
    expect(response).to redirect_to ideas_path
  end

  it 'cannot be published by non-moderator' do
    session[:user_id] = user.id
    @idea = FactoryGirl.create(:idea)
    expect { post :publish, params: { id: @idea.id } }.not_to change(@idea.histories, :count)
    expect(response).to redirect_to ideas_path
  end

  it 'topic is updated by moderator' do
    session[:user_id] = user_moderator.id
    @idea = FactoryGirl.create(:idea, topic: 'test topic to be updated')
    put :update, params: { id: @idea.id, idea: FactoryGirl.attributes_for(:idea, topic: 'updated topic') }
    @idea.reload
    expect(@idea.topic).to eq('updated topic')
    expect redirect_to @idea
  end

  it 'cannot be updated if not moderator' do
    session[:user_id] = user.id
    @idea = FactoryGirl.create(:idea, topic: 'test topic shall not update')
    put :update, params: { id: @idea.id, idea: FactoryGirl.attributes_for(:idea, topic: 'updated topic') }
    @idea.reload
    expect(@idea.topic).to eq('test topic shall not update')
    expect redirect_to ideas_path
  end

  it 'cannot be updated if not signed in' do
    session[:user_id] = user.id
    @idea = FactoryGirl.create(:idea, topic: 'test topic')
    session[:user_id] = nil
    put :update, params: { id: @idea.id, idea: FactoryGirl.attributes_for(:idea, topic: 'updated topic') }
    @idea.reload
    expect(@idea.topic).to eq('test topic')
    expect redirect_to ideas_path
  end



  describe "POST #create" do
    it "creates new if logged in and check that moderate value is correct" do
      session[:user_id] = user.id
      expect{
        post :create, params: { idea: FactoryGirl.attributes_for(:idea) }
        }.to change(Idea, :count).by(1)
      expect(Idea.first.moderate).to be false
    end
  end


end
