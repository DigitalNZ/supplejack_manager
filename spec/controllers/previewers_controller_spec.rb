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
  before do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:current_user) { mock(:user, id: 123) }
  end

  let(:parser) { mock(:parser).as_null_object }
  let(:previewer) { mock(:previewer).as_null_object }
  let(:harvester) { mock(:harvester).as_null_object }

  describe 'set_previewer' do
    before do
      Parser.stub(:find) { parser }
      Previewer.stub(:new) { previewer } 
      controller.stub(:params) { { parser_id: '1234', parser: {}, format: :js } }
    end

    it 'finds the parser' do
      Parser.should_receive(:find).with('1234') { parser }
      controller.set_previewer
    end
  end

  describe 'POST create' do
    before do
      Parser.stub(:find) { parser }
      Previewer.stub(:new) { previewer }
    end

    it 'should call before filters for find_parser_and_version' do
      controller.should_receive(:validate_parser_content)
      post :create, parser_id: '1234', parser: {}, format: :js
    end

    it 'should call before filters for set_previewer' do
      controller.should_receive(:set_previewer)
      post :create, parser_id: '1234', parser: {}, format: :js
    end

    it 'initializes a previewer object' do
      Previewer.should_receive(:new).with(parser,
                                          'Data', 123,
                                          10, nil) { previewer }
      post :create, parser_id: '1234',
           parser: { content: 'Data' }, index: 10, format: :js
      assigns(:previewer).should eq previewer
    end

    it 'sets parser_error as false' do
      post :create, parser_id: '1234',
           parser: { content: 'variable = 1' }, index: 10, format: :js
      assigns(:parser_error).should eq false
    end

    it 'sets parser_error with error details' do
      post :create, parser_id: '1234',
           parser: { content: 'variable += 1' },
           index: 10, format: :js
      assigns(:parser_error).should eq({ 'type' => NoMethodError,
                                         'message'=>"undefined method `+' for nil:NilClass" })
    end

    it 'initializes a new previewer in test mode' do
      Previewer.should_receive(:new).with(parser, 'Data',
                                          123, 10, nil) { previewer }
      post :create, parser_id: '1234',
           parser: { content: 'Data' },
           index: 10, environment: 'test', format: :js
    end

    it 'should preview the records from a existing harvest' do
      Previewer.should_receive(:new).with(parser, 'Data',
                                          123, 10, true) { previewer }
      post :create, parser_id: '1234',
           parser: { content: 'Data' },
           index: 10, environment: 'test', review: true, format: :js
    end
  end
end
