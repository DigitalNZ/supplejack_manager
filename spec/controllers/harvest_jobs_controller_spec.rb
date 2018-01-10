# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe HarvestJobsController do
  let(:job) { build(:harvest_job) }

  before(:each) do
    sign_in create(:user)
  end

  describe '#GET show' do
    it 'finds the harvest job' do
      expect(HarvestJob).to receive(:find) { job }
      get :show, params: { id: 1, format: 'js', environment: 'staging' }
      expect(assigns(:harvest_job)).to eq job
    end
  end

  describe 'PUT Update' do
    before(:each) do
      allow(HarvestJob).to receive(:find).with('1') { job }
    end

    it 'should update the attributes' do
      expect(job).to receive(:update_attributes).with({'status' => 'finished'})
      put :update, params: { id: 1, harvest_job: {status: 'finished'}, format: 'js', environment: 'staging' }
    end
  end
end
