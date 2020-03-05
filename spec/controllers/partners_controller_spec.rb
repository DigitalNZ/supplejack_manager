# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PartnersController do
  let(:partners) { create_list(:partner, 3) }
  let(:partner)  { build(:partner) }
  let(:user)     { create(:user, role: 'admin') }

  before(:each) do
    sign_in user
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
  end

  describe "GET 'index'" do
    it 'assigns all partners to @partners' do
      expect(Partner).to receive(:all) { partners }
      get :index
      expect(assigns(:partners)).to eq partners
    end

    it 'renders the index view' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET 'new'" do
    it 'it should render the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'should should assign new partner to @partner' do
      get :new
      expect(assigns(:partner)).to be_a_new(Partner)
    end
  end

  describe "POST 'create'" do
    context 'valid input' do
      before(:each) do
        @valid_partner = { name: 'Sample partner' }
      end

      it 'redirects to index template' do
        post :create, params: { partner: @valid_partner }
        expect(response).to redirect_to(partners_path)
      end

      it 'should save the partner' do
        expect {
          post :create, params: { partner: @valid_partner }
        }.to change(Partner, :count).by(1)
      end
    end

    context 'invalid input' do
      it 'renders new template' do
        post :create, params: { partner: { name: '' } }
        expect(response).to render_template(:new)
      end

      it 'should not save the partner' do
        expect {
          post :create, params: { partner: { name: '' } }
        }.to change(Partner, :count).by(0)
      end
    end
  end

  describe "GET 'edit'" do
    it 'it should render the edit template' do
      allow(Partner).to receive(:find).with('1') { partner }
      get :edit, params: { id: 1 }
      expect(response).to render_template(:edit)
    end

    it 'should should assign the partner to @partner' do
      expect(Partner).to receive(:find).with('1') { partner }
      get :edit, params: { id: 1 }
      expect(assigns(:partner)).to eq partner
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      allow(Partner).to receive(:find) { partner }
    end

    context 'valid input' do
      it 'should update the partner' do
        put :update, params: { partner: { name: 'partner' }, id: partner.id }
        partner.reload
        expect(partner.name).to eq 'partner'
      end

      it 'redirects to partners path' do
        put :update, params: { partner: { name: 'partner' }, id: partner.id }
        partner.reload
        expect(response).to redirect_to(partners_path)
      end
    end

    context 'invalid input' do
      before do
        partner.save
      end
      it 'should not update the partner' do
        put :update, params: { id: partner.id, partner: { name: '' } }
        partner.reload
        expect(partner.name).to eq partner.name
      end

      it 'renders edit' do
        put :update, params: { id: partner.id, partner: { name: '' } }
        expect(response).to render_template(:edit)
      end
    end
  end
end
