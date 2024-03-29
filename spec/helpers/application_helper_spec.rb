# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#pretty_format' do
    let(:raw_data) { { bill: 'bob' }.to_json }
    let!(:parser) do
      allow_any_instance_of(Partner).to receive(:update_apis)
      allow_any_instance_of(Source).to receive(:update_apis)
      allow(LinkCheckRule).to receive(:create)
      build(:parser)
    end

    context 'parser found' do
      it 'should find the parser & get the format' do
        expect(Parser).to receive(:find).with('abc123') { parser }
        expect(parser).to receive(:xml?)
        helper.pretty_format('abc123', raw_data)
      end

      before do
        allow(Parser).to receive(:find) { parser }
      end

      context 'json' do
        before { allow(parser).to receive(:xml?) { false } }
        it 'should pretty generate the JSON if it is json' do
          expect(JSON).to receive(:pretty_generate).with({ 'bill' => 'bob' })
          helper.pretty_format('abc123', raw_data)
        end
      end

      context 'xml' do
        before { allow(parser).to receive(:xml?) { true } }

        it 'should not pretty generate the XML' do
          expect(JSON).not_to receive(:pretty_generate).with(raw_data)
          helper.pretty_format('abc123', raw_data)
        end
      end
    end

    context 'parser not found' do
      it 'should return the raw data if the parser is not found' do
        expect(helper.pretty_format('abc123', raw_data)).to eq raw_data
      end
    end
  end

  describe '#format_backtrace' do
    it 'returns a div sith small lines' do
      expect(helper.format_backtrace(['foo', 'bar'])).to eq '<div><small>foo</small><small>bar</small></div>'
    end
  end

  describe 'safe_users_path' do
    context 'admin user' do
      it 'should be able to access users_path' do
        allow(helper).to receive(:current_user) { create(:user, :admin) }
        expect(helper.safe_users_path).to eq users_path
      end
    end

    context 'standard user' do
      it 'should not be able to access users_path' do
        allow(helper).to receive(:current_user) { create(:user) }
        expect(helper.safe_users_path).to eq root_path
      end
    end
  end

  describe 'can_show_button' do
    context 'authorised' do
      it 'should return empty string' do
        allow(helper).to receive(:can?) { true }
        expect(helper.can_show_button(:create, Source)).to eq ''
      end
    end

    context 'unauthorised' do
      it 'should return disabled' do
        allow(helper).to receive(:can?) { false }
        expect(helper.can_show_button(:create, Source)).to eq 'disabled'
      end
    end
  end

  describe 'human_readable_duration seconds' do
    context 'when seconds is nil' do
      it 'returns empty string' do
        expect(helper.human_readable_duration(nil)).to eq ''
      end
    end

    context 'when seconds is 1' do
      it 'returns 1 sec' do
        expect(helper.human_readable_duration(1)).to eq '1 sec'
      end
    end

    context 'when seconds is 60' do
      it 'returns 1 min' do
        expect(helper.human_readable_duration(60)).to eq '1 min'
      end
    end


    context 'when seconds is 120' do
      it 'returns 2 mins' do
        expect(helper.human_readable_duration(120)).to eq '2 mins'
      end
    end

    context 'when seconds is 3600' do
      it 'returns 1 hr' do
        expect(helper.human_readable_duration(3600)).to eq '1 hr'
      end
    end

    context 'when seconds is 86400' do
      it 'returns 1 day' do
        expect(helper.human_readable_duration(86400)).to eq '1 day'
      end

      it 'returns 2 day' do
        expect(helper.human_readable_duration(86400 * 2)).to eq '2 days'
      end
    end
  end
end
