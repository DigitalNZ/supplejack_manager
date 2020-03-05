
require 'rails_helper'

RSpec.describe HomeController do
  let!(:parsers) do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
    [build(:parser)]
  end

  before(:each) do
    sign_in create(:user)
  end

  describe 'GET index' do
    before(:each) do
      allow(AbstractJob).to receive(:find) { {} }
      allow(CollectionStatistics).to receive(:first) { build(:collection_statistics) }
      allow(CollectionStatistics).to receive(:index_statistics) { { '2013-12-26' => { suppressed: 1, activated: 2, deleted: 3 }} }
      allow(Parser).to receive_message_chain(:desc, :limit)
      allow(HarvestSchedule).to receive(:find)
    end

    context "#set environment" do
      it "sets the environment to first available environment" do
        get :index
        expect(controller.params[:environment]).to eq APPLICATION_ENVS.first.to_s
      end

      it "sets the environment to production and cache the environment" do
        get :index, params: { environment: 'production' }
        expect(controller.params[:environment]).to eq 'production'
        get :index
        expect(controller.params[:environment]).to eq 'production'
      end
    end

    context "jobs" do
      context "successful query" do
        before(:each) do
          expect(AbstractJob).to receive(:find).with(:all, hash_including(:from)).exactly(3).times { [1,2,3] }
        end

        it "sets the count of active jobs" do
          get :index
          expect(assigns(:stats)[:active_jobs]).to eq 3
        end

        it "sets the count of finished jobs" do
          get :index
          expect(assigns(:stats)[:finished_jobs]).to eq 3
        end

        it "sets the count of failed jobs" do
          get :index
          expect(assigns(:stats)[:failed_jobs]).to eq 3
        end

      end
      context "error thrown" do
        it "sets the counts to n/a when exceptions occour" do
          allow(AbstractJob).to receive(:find).and_raise(StandardError.new)
          get :index
          expect(assigns(:stats)[:failed_jobs]).to eq 'n/a'
        end

      end

    end

    context "collection statistics" do

      it "sets the count of reactivated records" do
        get :index
        expect(assigns(:stats)[:activated]).to eq 2
      end

      it "sets the count of suppressed records" do
        get :index
        expect(assigns(:stats)[:suppressed]).to eq 1
      end

      it "sets the count of deleted records" do
        get :index
        expect(assigns(:stats)[:deleted]).to eq 3
      end

      it "sets the counts to 0 when exceptions occour" do
        allow(CollectionStatistics).to receive(:index_statistics).and_raise(StandardError.new)
        get :index
        expect(assigns(:stats)[:activated]).to eq 'n/a'
      end

    end

    context "recently edited parsers" do
      it 'sets the list of recently edited parsers' do
        allow(Parser).to receive_message_chain(:desc, :limit) { parsers }
        get :index
        expect(assigns(:parsers)).to eq parsers
      end

      it "sets parsers to nil when exceptions occour" do
        allow(Parser).to receive(:desc).and_raise(StandardError.new)
        get :index
        expect(assigns(:parsers)).to be_nil
      end
    end

    context "next scheduled jobs" do
      let(:schedules) { [build(:harvest_schedule)] }

      it "sets the list of next scheduled jobs" do
        expect(HarvestSchedule).to receive(:find).with(:all, :from => :next) { schedules }
        get :index
        expect(assigns(:scheduled_jobs)).to eq schedules
      end

      it "sets scheduled_jobs to nil when exceptions occour" do
        allow(HarvestSchedule).to receive(:find).and_raise(StandardError.new)
        get :index
        expect(assigns(:scheduled_jobs)).to be_nil
      end
    end

    context "failures" do
      it "sets the flash message when an exception occours" do
        allow(HarvestSchedule).to receive(:find).and_raise(StandardError.new)
        expect(controller).to receive(:t).with('dashboard.error') { 'Error message' }
        get :index
        expect(flash.now[:alert]).to eq 'Error message'
      end
    end
  end
end
