# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe HarvestSchedulesController do
  let(:schedule) { instance_double(HarvestSchedule).as_null_object }
  let(:paused_schedule) { instance_double(HarvestSchedule).as_null_object }
  let(:user) { instance_double(User, role: 'admin').as_null_object }

  before(:each) do
    allow(controller).to receive(:authenticate_user!) { true }
    allow(controller).to receive(:current_user) { user }
  end

  describe 'PUT update_all' do

    before do
      expect(schedule).to receive(:status) { 'active' }
      expect(schedule).to receive(:update_attributes).with({ 'status' => 'stopped' })
    end

    it 'update the scheduled harvets' do
      expect(HarvestSchedule).to receive(:all) { [schedule] }
      put :update_all, environment: 'staging', harvest_schedule: { status: 'stopped' }
    end

    it 'does not update individually paused scheduled harvests' do
      expect(HarvestSchedule).to receive(:all) { [schedule, paused_schedule] }
      expect(paused_schedule).to receive(:status) { 'paused' }
      expect(paused_schedule).to_not receive(:update_attributes).with({ 'status' => 'stopped' })

      put :update_all, environment: 'staging', harvest_schedule: { status: 'stopped' }
    end
  end

  describe 'GET index' do
    before(:each) do
      allow(schedule).to receive(:status) { 'active' }
    end

    it "returns all harvest schedules" do
      expect(HarvestSchedule).to receive(:all) { [schedule] }
      get :index, environment: "staging"
      expect(assigns(:harvest_schedules)).to eq [schedule]
    end

    it "assigns recurrent and one_off schedules" do
      s1 = double(:schedule, recurrent: true, next_run_at: DateTime.now, status: 'active' )
      s2 = double(:schedyle, recurrent: false, start_time: DateTime.now, status: 'active' )
      allow(HarvestSchedule).to receive(:all) { [s1, s2] }
      get :index, environment: "staging"
      expect(assigns(:recurrent_schedules)).to eq [s1]
      expect(assigns(:one_off_schedules)).to eq [s2]
    end
  end

  describe 'POST create' do
    before do
        stub_request(:post, "http://127.0.0.1:3002/harvest_schedules.json").
         with(body: "{\"cron\":\"* * * * *\",\"parser_id\":\"1\",\"start_time\":\"2017-11-27 10:29:33 +1300\"}",
              headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Token token=WORKER_KEY', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
         to_return(status: 200, body: "", headers: {})
      end

      it 'initializes a new harvest schedule' do
        post :create, harvest_schedule: { cron: '* * * * *', parser_id: '1', start_time: '2017-11-27 10:29:33 +1300' }, environment: 'staging'
      end

      it 'should redirect to the index' do
        post :create, harvest_schedule: {cron: "* * * * *", parser_id: '1', start_time: '2017-11-27 10:29:33 +1300' }, environment: "staging"
        expect(response).to redirect_to(environment_harvest_schedules_path("staging"))
      end
    end

    describe "PUT Update" do
      before(:each) do
        allow(HarvestSchedule).to receive(:find).with("1") { schedule }
      end

      it "finds the harvest schedule" do
        expect(HarvestSchedule).to receive(:find).with("1") { schedule }
        put :update, id: 1, environment: "staging"
        expect(assigns(:harvest_schedule)).to eq schedule
      end

      it "should update the attributes" do
        expect(schedule).to receive(:update_attributes).with({"cron" => "1 1 1 1 1"})
        put :update, id: 1, harvest_schedule: {cron: "1 1 1 1 1"}, environment: "staging"
      end

      it "should redirect to the index" do
        put :update, id: 1, harvest_schedule: {cron: "* * * * *"}, environment: "staging"
        expect(response).to redirect_to(environment_harvest_schedules_path("staging"))
      end
    end
  end
