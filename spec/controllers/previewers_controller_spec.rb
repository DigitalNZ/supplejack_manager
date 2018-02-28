require 'rails_helper'

describe PreviewersController do
  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  let(:source) { create(:source) }
  let(:parser) { create(:parser, source_id: source) }
  let(:user)   { create(:user, :admin) }

  before do
    sign_in user
    allow_any_instance_of(Previewer).to receive(:create_preview_job) { true }
  end

  describe 'POST create' do
    it 'should call before filters for find_parser_and_version' do
      expect(controller).to receive(:validate_parser_content)
      post :create, params: { parser_id: parser.id, parser: { content: 'content' }, format: :js }
    end

    it 'should call before filters for set_previewer' do
      expect(controller).to receive(:set_previewer)
      post :create, params: { parser_id: parser.id, parser: { content: 'content' }, format: :js }
    end

    it 'sets parser_error as false' do
      post :create, params: { parser_id: parser.id,
           parser: { content: 'variable = 1' }, index: 10, format: :js }
      expect(assigns(:parser_error)).to eq false
    end

    it 'sets parser_error with error details' do
      post :create, params: { parser_id: parser.id,
           parser: { content: 'variable += 1' },
           index: 10, format: :js }
      expect(assigns(:parser_error)).to eq({ :type => NoMethodError,
                                         :message => "undefined method `+' for nil:NilClass" })
    end

    it 'initializes a new previewer in test mode' do
      post :create, params: { parser_id: parser.id,
           parser: { content: 'Data' },
           index: 10, environment: 'test', format: :js }
    end

    it 'should preview the records from a existing harvest' do
      expect_any_instance_of(Previewer).to receive(:create_preview_job)
      post :create, params: { parser_id: parser.id,
           parser: { content: 'Data' },
           index: 10, environment: 'test', review: true, format: :js }
    end
  end
end
