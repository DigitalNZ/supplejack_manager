require 'spec_helper'

RSpec.describe Admin::User, type: :model do
  let(:admin_user) { Admin::User.new('development', 1) }

  describe 'attributes' do
    it 'can be initialized with an environmnet' do
      expect(admin_user.environment).to eq 'development'
    end

    it 'can be intialized with a page' do
      expect(admin_user.page).to eq 1
    end
  end
end
