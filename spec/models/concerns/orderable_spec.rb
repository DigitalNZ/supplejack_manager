require 'rails_helper'

shared_examples_for 'an ordered collection' do
  let(:model) { described_class }

  context 'scopes' do
     describe '#latest' do
      it "orders all #{described_class}s by #updated_at attribute" do
        model_3 = create(model.to_s.underscore.to_sym, updated_at: 3.day.ago)
        model_1 = create(model.to_s.underscore.to_sym, updated_at: 1.day.ago)
        model_2 = create(model.to_s.underscore.to_sym, updated_at: 2.day.ago)

        expect(model.latest).to eq [model_1, model_2, model_3]
      end
    end
  end
end