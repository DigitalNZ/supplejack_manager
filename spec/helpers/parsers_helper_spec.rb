require 'rails_helper'

describe ParsersHelper do
  let(:parser) do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
    build(:parser)
  end
  let(:version) { build(:version, versionable: parser, tags: ['production'])}

  describe "#version_tags" do
    context "current production tag" do
      before(:each) do
        allow(parser).to receive(:current_version).with(:production) { version }
      end

      it "displays the production tag" do
        expect(helper.environment_tags(version, parser)).to eq %{<div class="version-tag-container"><span class="version-tag production current"><span class="arrow arrow-left"></span>P</span></div>}
      end
    end

    context "current staging tag" do
      before(:each) do
        allow(version).to receive(:tags) { ["staging"] }
        allow(parser).to receive(:current_version).with(:staging) { version }
      end

      it "displays the production tag" do
        expect(helper.environment_tags(version, parser)).to eq %{<div class="version-tag-container"><span class="version-tag staging current"><span class="arrow arrow-left"></span>S</span></div>}
      end
    end

    context "current is production and staging" do
      before(:each) do
        allow(version).to receive(:tags) { ["staging", "production"] }
        allow(parser).to receive(:current_version).with(:staging) { version }
        allow(parser).to receive(:current_version).with(:production) { version }
      end

      it "displays the production tag nested in the staging tag" do
        expect(helper.environment_tags(version, parser)).to eq %{<div class="version-tag-container"><span class="version-tag staging current"><span class="arrow arrow-left"></span>S</span><span class="version-tag production current"><span class="arrow arrow-left"></span>P</span></div>}
      end
    end

    context '#localize_date_time' do
      it 'return date in dd M yyyy hh:mm format' do
        expect(localize_date_time(Time.zone.now)).to match(/^[0-9]{2} [a-zA-Z]{3} [0-9]{4} [0-9]{2}:[0-9]{2}/)
      end
    end

    context "older tags" do
      let(:current_version) { build(:version, tags: ['production']) }

      before(:each) do
        allow(parser).to receive(:current_version).with(:production) { current_version }
        allow(parser).to receive(:current_version).with(:staging) { current_version }
      end

      context "older production tag" do
        it "returns a small production bubble" do
          expect(helper.environment_tags(version, parser)).to eq %{<div class="version-tag-container"><span class="version-tag production">P</span></div>}
        end
      end

      context "older staging tag" do
        it "returns a small staging bubble" do
          allow(version).to receive(:tags) { ["staging"] }
          expect(helper.environment_tags(version, parser)).to eq %{<div class="version-tag-container"><span class="version-tag staging">S</span></div>}
        end
      end

      context "older staging and production tags" do
        it "returns a two small bubbles" do
          allow(version).to receive(:tags) { ["staging", "production"] }
          expect(helper.environment_tags(version, parser)).to eq %{<div class="version-tag-container"><span class="version-tag staging">S</span><span class="version-tag production">P</span></div>}
        end
      end
    end
  end
end
