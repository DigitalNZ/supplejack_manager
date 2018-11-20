# frozen_string_literal: true

require 'rails_helper'

describe Source do
  let(:source) { build(:source) }

  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(source.valid?).to be true
    end

    it 'is not valid without a source_id' do
      s = build(:source, source_id: nil)
      expect(s.valid?).to be false
    end

    it 'must have a partner' do
      s = build(:source, partner_id: nil)
      expect(s.valid?).to be false
    end

    it 'must have a unique source_id' do
      create(:source, source_id: 'test')
      s2 = build(:source, source_id: 'test')

      expect(s2.valid?).to be false
    end
  end

  describe 'after create' do
    it 'calls create_link_check_rule' do
      expect(source).to receive(:create_link_check_rule)
      source.save
    end
  end

  describe 'after save' do
    it 'calls update_apis' do
      expect(source).to receive(:update_apis)
      source.save
    end

    it 'calls slugfy_source_id' do
      expect(source).to receive(:slugfy_source_id)
      source.save
    end
  end

  describe '#create_link_check_rule' do
    it 'should create the rule in each backend_environment' do
      APPLICATION_ENVS.each do |env|
        expect(source).to receive(:set_worker_environment_for).with(LinkCheckRule, env)
        expect(LinkCheckRule).to receive(:create)
      end
      source.send(:create_link_check_rule)
    end

    it 'should create an inactive LinkCheckRule' do
      expect(LinkCheckRule).to receive(:create).with(source_id: source.id, active: false)
      source.send(:create_link_check_rule)
    end
  end

  describe '#slugfy_source_id' do
    it 'removes excess whitespace and replaces them with underscores in the source_id' do
      source.source_id = 'Source     4'
      source.save!
      expect(source.source_id).to eq 'source_4'
    end

    it 'only includes alphanumeric characters in the source_id' do
      source.source_id = '@84 $ource!!'
      source.save!
      expect(source.source_id).to eq '84_ource'
    end
  end

  describe 'creating a new source' do
    let(:new_source) { Source.new(source_id: 'New source', partner: create(:partner)) }

    it 'creates a new source slugfying the source_id with #slugfy_source_id' do
      new_source.save!
      expect(new_source.source_id).to eq 'new_source'
    end
  end
end
