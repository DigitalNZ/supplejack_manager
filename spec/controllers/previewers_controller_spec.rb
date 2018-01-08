# The majority of The Supplejack Manager code is Crown copyright (C) 2014,
# New Zealand Government,
# and is licensed under the GNU General Public License, version 3.
# Some components are third party components that are licensed under
# the MIT license or otherwise publicly available.
# See https://github.com/DigitalNZ/supplejack_manager for details.
#
# Supplejack was created by DigitalNZ at the National Library of NZ and
# the Department of Internal Affairs.
# http://digitalnz.org/supplejack

require 'spec_helper'

describe PreviewersController do
  let(:parser)    { build(:parser) }
  # TODO
  let(:previewer) { double(:previewer).as_null_object }
  let(:user)      { create(:user) }

  before do
    sign_in user
  end

  describe 'set_previewer' do
    before do
      allow(Parser).to receive(:find) { parser }
      allow(Previewer).to receive(:new) { previewer }
      allow(controller).to receive(:params) { { parser_id: '1234', parser: {}, format: :js } }
    end

    it 'finds the parser' do
      expect(Parser).to receive(:find).with('1234') { parser }
      controller.set_previewer
    end
  end

  describe 'POST create' do
    before do
      allow(Parser).to receive(:find) { parser }
      allow(Previewer).to receive(:new) { previewer }
    end

    it 'should call before filters for find_parser_and_version' do
      expect(controller).to receive(:validate_parser_content)
      post :create, parser_id: '1234', parser: {}, format: :js
    end

    it 'should call before filters for set_previewer' do
      expect(controller).to receive(:set_previewer)
      post :create, parser_id: '1234', parser: {}, format: :js
    end

    it 'initializes a previewer object' do
      post :create, parser_id: '1234',
           parser: { content: 'Data' }, index: 10, format: :js
      expect(assigns(:previewer)).to eq previewer
    end

    it 'sets parser_error as false' do
      post :create, parser_id: '1234',
           parser: { content: 'variable = 1' }, index: 10, format: :js
      expect(assigns(:parser_error)).to eq false
    end

    it 'sets parser_error with error details' do
      post :create, parser_id: '1234',
           parser: { content: 'variable += 1' },
           index: 10, format: :js
      expect(assigns(:parser_error)).to eq({ :type => NoMethodError,
                                         :message => "undefined method `+' for nil:NilClass" })
    end

    it 'initializes a new previewer in test mode' do
      expect(Previewer).to receive(:new).with(parser, 'Data',
                                          anything, 10, nil) { previewer }
      post :create, parser_id: '1234',
           parser: { content: 'Data' },
           index: 10, environment: 'test', format: :js
    end

    it 'should preview the records from a existing harvest' do
      expect(Previewer).to receive(:new).with(parser, 'Data',
                                          anything, 10, true)
      post :create, parser_id: parser.id,
           parser: { content: 'Data' },
           index: 10, environment: 'test', review: true, format: :js
    end
  end
end
