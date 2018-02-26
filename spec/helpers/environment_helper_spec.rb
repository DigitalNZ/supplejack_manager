# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnvironmentHelpers do
  let(:env_vars) { APPLICATION_ENVIRONMENT_VARIABLES }
  let(:params) { { environment: 'test' } }

  class ModelWithMultipleEnvironments
    include EnvironmentHelpers

    class << self
      attr_accessor :site, :user
    end
  end

  describe 'dynamic_methods' do
    let(:dummy) { ModelWithMultipleEnvironments.new }

    it 'responds to harvest_jobs_path' do
      expect(dummy).to respond_to(:harvest_jobs_path)
    end

    it 'responds to harvest_schedules_path' do
      expect(dummy).to respond_to(:harvest_schedules_path)
    end

    it 'responds to harvest_job_path' do
      expect(dummy).to respond_to(:harvest_job_path)
    end

    it 'responds to harvest_schedule_path' do
      expect(dummy).to respond_to(:harvest_schedule_path)
    end
  end

  describe '#set_worker_environment_for' do
    let(:klass) { OpenStruct.new(site: 'site', user: 'user') }

    it 'sets the correct environment variables for the provided class' do
      set_worker_environment_for(klass, 'test')
      expect(klass.site).to eq env_vars['test']['WORKER_HOST']
      expect(klass.user).to eq env_vars['test']['WORKER_KEY']
    end
  end

  describe '#fetch_env_vars' do
    it 'returns a hash of the available environment variables' do
      expect(fetch_env_vars).to have_key('WORKER_HOST')
      expect(fetch_env_vars).to have_key('HARVESTER_API_KEY')
      expect(fetch_env_vars).to have_key('API_HOST')
      expect(fetch_env_vars).to have_key('API_MONGOID_HOSTS')
      expect(fetch_env_vars).to have_key('WORKER_KEY')
    end
  end

  describe '#change_worker_env' do
    it 'sets the worker environment to be what is in the environment hash' do
      ModelWithMultipleEnvironments.change_worker_env!('test')
      expect(ModelWithMultipleEnvironments.site).to eq env_vars['test']['WORKER_HOST']
      expect(ModelWithMultipleEnvironments.user).to eq env_vars['test']['WORKER_KEY']
    end
  end
end
