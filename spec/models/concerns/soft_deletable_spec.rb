require 'rails_helper'

class Progress
  include Mongoid::Document
  include SoftDeletable
end

describe SoftDeletable do
  let(:source)  { create(:source) }
  let(:user)    { create(:user) }
  let(:program) { Progress.new }

	describe "attributes" do
		context "after being deleted" do
			before { program.delete }

			it "has the 'deleted_at' timestamp" do
				expect(program).to have_attribute :deleted_at
				expect(program.deleted_at).to be_a DateTime
			end

			after { program.deleted_at = nil }
		end
	end

	describe "#delete" do
    context "successfully 'deletes' the program" do
      before(:each) do
        program.deleted_at = nil
        program.save!
        Timecop.freeze
      end

      it "sets the 'deleted_at' timestamp" do
        expect(program.deleted_at).to be nil
        program.delete
        expect(program.deleted_at.to_i).to eql DateTime.now.to_i
      end

      it "returns true" do
        expect(program.delete).to be true
      end

      after do
        Timecop.return
      end
    end
  end

  describe "#deleted?" do
  	context "program has been deleted" do
  		before { program.deleted_at = DateTime.now }

  		it "returns true" do 
  			expect(program.deleted?).to be true
  		end
  	end

  	context "program has not been deleted" do
  		before { program.deleted_at = nil }

  		it "returns false" do 
  			expect(program.deleted?).to be false
  		end
  	end
  end
end