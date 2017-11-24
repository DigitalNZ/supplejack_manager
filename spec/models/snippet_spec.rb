# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require "spec_helper"

describe Snippet do

  describe ".find_by_name" do

    let!(:snippet) { FactoryBot.create(:snippet, name: "Copyright") }

    it "finds the snippet by name" do
      Snippet.should_receive(:where).with( { name: "Copyright" }) { [snippet] }
      Snippet.find_by_name("Copyright", :staging)
    end

    it "returns the current version of the snippet" do
      Snippet.stub(:where) { [snippet] }
      snippet.should_receive(:current_version).with(:staging)
      Snippet.find_by_name("Copyright", :staging)
    end

    it "returns nil when it doesn't find the snippet" do
      Snippet.find_by_name("Mapping", :staging).should be_nil
    end

  end

  context "file paths" do

    let(:snippet) { FactoryBot.build(:snippet, name: "Copyright Rules") }

    describe "#file_name" do
      it "returns a correct file_name" do
        snippet.file_name.should eq "copyright_rules.rb"
      end
    end

    describe "path" do
      it "returns the file path relative to the repository root dir" do
        snippet.path.should eq "snippets/copyright_rules.rb"
      end
    end

  end

end
