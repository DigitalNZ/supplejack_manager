require 'rails_helper'

RSpec.describe Admin::User, type: :model do
  let(:admin_user) { Admin::User.new('development') }

  describe 'attributes' do
    it 'can be initialized with an environmnet' do
      expect(admin_user.environment).to eq 'development'
    end
  end
end
