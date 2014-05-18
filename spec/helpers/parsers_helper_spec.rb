# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require "spec_helper"

describe ParsersHelper do

  let(:version) { mock(:version, id: "123", tags: ["production"]).as_null_object }
  let(:parser) { mock(:parser, id: "333", current_version: nil) }

  describe "#version_tags" do

    context "current production tag" do
      before(:each) do
        parser.stub(:current_version).with(:production) { version }
      end

      it "displays the production tag" do
        helper.environment_tags(version, parser).should eq %{<div class="version-tag-container"><span class="version-tag production current"><span class="arrow arrow-left"></span>P</span></div>}
      end
    end

    context "current staging tag" do
      before(:each) do
        version.stub(:tags) { ["staging"] }
        parser.stub(:current_version).with(:staging) { version }
      end

      it "displays the production tag" do
        helper.environment_tags(version, parser).should eq %{<div class="version-tag-container"><span class="version-tag staging current"><span class="arrow arrow-left"></span>S</span></div>}
      end
    end

    context "current is production and staging" do
      before(:each) do
        version.stub(:tags) { ["staging", "production"] }
        parser.stub(:current_version).with(:staging) { version }
        parser.stub(:current_version).with(:production) { version }
      end

      it "displays the production tag nested in the staging tag" do
        helper.environment_tags(version, parser).should eq %{<div class="version-tag-container"><span class="version-tag staging current"><span class="arrow arrow-left"></span>S</span><span class="version-tag production current"><span class="arrow arrow-left"></span>P</span></div>}
      end
    end

    context "older tags" do
      let(:current_version) { mock(:version, id: "444", tags: ["production"]) }

      before(:each) do
        parser.stub(:current_version).with(:production) { current_version }
        parser.stub(:current_version).with(:staging) { current_version }
      end

      context "older production tag" do
        it "returns a small production bubble" do
          helper.environment_tags(version, parser).should eq %{<div class="version-tag-container"><span class="version-tag production">P</span></div>}
        end
      end

      context "older staging tag" do
        it "returns a small staging bubble" do
          version.stub(:tags) { ["staging"] }
          helper.environment_tags(version, parser).should eq %{<div class="version-tag-container"><span class="version-tag staging">S</span></div>}
        end
      end

      context "older staging and production tags" do
        it "returns a two small bubbles" do
          version.stub(:tags) { ["staging", "production"] }
          helper.environment_tags(version, parser).should eq %{<div class="version-tag-container"><span class="version-tag staging">S</span><span class="version-tag production">P</span></div>}
        end
      end
    end
  end
  
end