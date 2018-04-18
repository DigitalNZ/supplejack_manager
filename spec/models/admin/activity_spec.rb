require 'rails_helper'

RSpec.describe Admin::Activity, type: :model do
  let(:activity) { Admin::Activity.new('development') }

  describe 'attributes' do
    it 'can be initialized with an environmnet' do
      expect(activity.environment).to eq 'development'
    end
  end
end
