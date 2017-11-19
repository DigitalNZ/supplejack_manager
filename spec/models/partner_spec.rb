# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are
# third party components that are licensed under the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

RSpec.describe Partner do
  before do
    RestClient.stub(:post)
  end

  describe 'validations' do
    it 'is not valid without a name' do
      expect(Partner.new.valid?).to be false
    end

    it 'is not valid unless name is unique' do
      FactoryGirl.create(:partner, name: 'partner')
      p2 = FactoryGirl.build(:partner, name: 'partner')
      expect(p2.valid?).to be false
    end
  end

  describe 'after save' do
    it 'syncs with the apis' do
      p = FactoryGirl.build(:partner)
      expect(p).to receive(:update_apis)
      p.save
    end
  end

  describe '#update_apis' do
    let(:partner) { FactoryGirl.create(:partner) }

    it 'updates each environments' do
      APPLICATION_ENVS.each do |env|
        env = APPLICATION_ENVIRONMENT_VARIABLES[env]
        expect(RestClient).to receive(:post).with("#{env['API_HOST']}/harvester/partners", anything)

        partner.update_apis
      end
    end
  end
end
