# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionStatisticsController do
  let(:collection_statistics) { build(:collection_statistics) }

  before(:each) do
    sign_in create(:user)
  end

  describe 'GET index' do
    it 'should get all of the collection statistics' do
      expect(CollectionStatistics).to receive(:all) { [collection_statistics] }
      get :index, params: { environment: 'staging' }
      expect(assigns(:collection_statistics)).to eq '2022-03-16' => { suppressed: 1, activated: 0, deleted: 0 }
    end
  end

  describe 'GET show' do
    it 'should do a find :all with the day' do
      expect(CollectionStatistics).to receive(:find).with(:all, params: { collection_statistics: { day: Date.today.to_s } }) { collection_statistics }
      get :show, params: { id: Date.today.to_s, environment: 'staging' }
      expect(assigns(:collection_statistics)).to eq collection_statistics
    end
  end
end
