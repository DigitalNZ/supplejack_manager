# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Abstract Job Dashboard', type: :feature do
  context 'a user that is logged out' do
    scenario 'gets redirected to the sign in page' do
      visit environment_abstract_jobs_path(environment: 'staging')
      expect(page.current_path).to eq new_user_session_path
    end
  end

  context 'logged in' do
    let(:user) { create(:user, :admin) }

    before do
      allow_any_instance_of(Partner).to receive(:update_apis)
      allow_any_instance_of(Source).to receive(:update_apis)
      allow(LinkCheckRule).to receive(:create)

      sign_in user
    end

    context 'Active jobs', js: true do
      let(:source) { create(:source) }
      let(:parser) { create(:parser, source: source) }
      let(:abstract_job) do
        build(:abstract_job, status: 'active',
                             mode: 'Normal',
                             user_id: user.id,
                             parser_id: parser.id,
                             start_time: Time.zone.now - 1.hour,
                             _type: 'HarvestJob',
                             version_id: '999')
      end

      before :each do
        allow(AbstractJob).to receive(:search).and_return Kaminari::PaginatableArray.new([abstract_job], limit: 50, offset: 0, total_count: 1)
        visit environment_abstract_jobs_path(status: 'active', environment: 'staging')
      end

      scenario 'displays active job details' do
        expect(page.has_content?(abstract_job.parser.name))
        expect(page.has_content?(abstract_job.mode))
        expect(page.has_content?(abstract_job.user.name))
        expect(page.has_content?(I18n.l(abstract_job.start_time, format: :long)))
        expect(page.has_content?(abstract_job.records_count))
      end

      scenario 'has links to the parser and the harvest job details' do
        expect(page).to have_link(abstract_job.parser.name, href: parser_parser_version_path(parser_id: parser.id, id: abstract_job.version_id))
        expect(page).to have_link('Details', href: environment_harvest_job_path('staging', id: abstract_job.id))
        expect(page).to_not have_content('Status')
      end
    end

    context 'Finished jobs', js: true do
      let(:source) { create(:source) }
      let(:parser) { create(:parser, source: source) }
      let(:abstract_job) do
        build(:abstract_job, status: 'finished',
                             mode: 'Normal',
                             user_id: user.id,
                             parser_id: parser.id,
                             start_time: Time.zone.now - 1.hour,
                             _type: 'HarvestJob',
                             version_id: '999',
                             duration: 1111.11)
      end

      before :each do
        allow(AbstractJob).to receive(:search).and_return Kaminari::PaginatableArray.new([abstract_job], limit: 50, offset: 0, total_count: 1)
        visit environment_abstract_jobs_path(status: 'finished', environment: 'staging')
      end

      scenario 'displays finished job duration' do
        expect(page).to have_content('18 mins 31 secs')
        expect(page).to_not have_content('Status')
      end
    end

    context 'All jobs', js: true do
      let(:source) { create(:source) }
      let(:parser) { create(:parser, source: source) }
      let(:abstract_job) do
        build(:abstract_job, status: 'finished',
                             mode: 'Normal',
                             user_id: user.id,
                             parser_id: parser.id,
                             start_time: Time.zone.now - 1.hour,
                             _type: 'HarvestJob',
                             version_id: '999',
                             duration: 1111.11)
      end
      let(:abstract_job_2) do
        build(:abstract_job, status: 'active',
                             mode: 'Normal',
                             user_id: user.id,
                             parser_id: parser.id,
                             start_time: Time.zone.now - 1.hour,
                             _type: 'HarvestJob',
                             version_id: '999',
                             duration: 1111.11)
      end

      before :each do
        allow(AbstractJob).to receive(:search).and_return Kaminari::PaginatableArray.new([abstract_job], limit: 50, offset: 0, total_count: 1)
        visit environment_abstract_jobs_path(status: 'all', environment: 'staging')
      end

      scenario do
        expect(page).to have_content('Status')
        expect(page).to have_content('Finished')
        expect(page).to have_content('Active')
        expect(page).to have_content('Duration')

        expect(page.find('td:first-child a')[:href]).to include environment_abstract_jobs_path(
          'staging',
          status: 'all',
          parser_id: abstract_job.parser.id
        )
      end
    end
  end
end
