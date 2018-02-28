
require 'rails_helper'

describe HarvestSchedulesController do
  let(:schedule) { build(:harvest_schedule) }
  let(:paused_schedule) { build(:harvest_schedule) }

  before(:each) do
    sign_in create(:user, :admin)
  end

  describe 'PUT update_all' do

    before do
      expect(schedule).to receive(:status) { 'active' }
      expect(schedule).to receive(:update_attributes)
    end

    it 'update the scheduled harvets' do
      expect(HarvestSchedule).to receive(:all) { [schedule] }
      put :update_all, params: { environment: 'staging', harvest_schedule: { status: 'stopped' } }
    end

    it 'does not update individually paused scheduled harvests' do
      expect(HarvestSchedule).to receive(:all) { [schedule, paused_schedule] }
      expect(paused_schedule).to receive(:status) { 'paused' }
      expect(paused_schedule).to_not receive(:update_attributes)

      put :update_all, params: { environment: 'staging', harvest_schedule: { status: 'stopped' }}
    end
  end

  describe '#new' do
    context 'html' do
      it 'returns the :new template' do
        get :new, params: { environment: 'staging' }
        expect(response).to render_template :new
      end

      it 'assigns a new @harvest_schedule' do
        get :new, params: { environment: 'staging' }
        expect(assigns(:harvest_schedule)).to be_a_new(HarvestSchedule)
      end
    end

    context 'js' do
      let(:harvest_schedule) { build(:harvest_schedule) }

      it 'returns the :new js template' do
        get :new, params: { environment: 'staging' }, format: :js
        expect(response).to render_template :new
      end

      it 'assigns the correct @harvest_schedule' do
        get :new, params: { environment: 'staging', harvest_schedule: harvest_schedule }
        expect(assigns(:harvest_schedule)).to eq harvest_schedule
      end
    end
  end

  describe 'GET index' do
    before(:each) do
      allow(schedule).to receive(:status) { 'active' }
    end

    it "returns all harvest schedules" do
      expect(HarvestSchedule).to receive(:all) { [schedule] }
      get :index, params: { environment: "staging" }
      expect(assigns(:harvest_schedules)).to eq [schedule]
    end

    it 'assigns recurrent and one_off schedules' do
      s1 = build(:harvest_schedule, recurrent: true, next_run_at: DateTime.now, status: 'active')
      s2 = build(:harvest_schedule, recurrent: false, start_time: DateTime.now, status: 'active')

      allow(HarvestSchedule).to receive(:all) { [s1, s2] }
      get :index, params: { environment: "staging" }
      expect(assigns(:recurrent_schedules)).to eq [s1]
      expect(assigns(:one_off_schedules)).to eq [s2]
    end
  end

  describe 'POST create' do
    before do
      allow_any_instance_of(HarvestSchedule).to receive(:save) { true }
    end

      it 'initializes a new harvest schedule' do
        post :create, params: { harvest_schedule: { cron: '* * * * *', parser_id: '1', start_time: '2017-11-27 10:29:33 +1300' }, environment: 'staging' }
      end

      it 'should redirect to the index' do
        post :create, params: { harvest_schedule: { cron: "* * * * *", parser_id: '1', start_time: '2017-11-27 10:29:33 +1300' }, environment: "staging" }
        expect(response).to redirect_to(environment_harvest_schedules_path("staging"))
      end
    end

    describe "PUT Update" do
      before(:each) do
        allow(HarvestSchedule).to receive(:find).with('1') { schedule }
      end

      it 'finds the harvest schedule' do
        expect(HarvestSchedule).to receive(:find).with('1') { schedule }
        put :update, params: { id: 1, environment: 'staging', harvest_schedule: { test: 'hey' } }
        expect(assigns(:harvest_schedule)).to eq schedule
      end

      it "should update the attributes" do
        expect(schedule).to receive(:update_attributes)
        put :update, params: { id: 1, harvest_schedule: {cron: '1 1 1 1 1'}, environment: 'staging' }
      end

      it "should redirect to the index" do
        put :update, params: { id: 1, harvest_schedule: {cron: "* * * * *"}, environment: "staging" }
        expect(response).to redirect_to(environment_harvest_schedules_path("staging"))
      end
    end
  end
