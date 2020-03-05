require 'rails_helper'

RSpec.describe Parser do
  let(:source) { create(:source) }
  let(:parser) { create(:parser, source_id: source.id, name: 'NZ Museums') }

  before do
    allow_any_instance_of(Partner).to receive(:update_apis)
    allow_any_instance_of(Source).to receive(:update_apis)
    allow(LinkCheckRule).to receive(:create)
  end

  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:parser)).to be_valid
    end

    it "should not be valid with a invalid strategy" do
      parser.strategy = "sitemap"
      expect(parser).not_to be_valid
    end

    it "should not be valid with a invalid data type" do
      parser.data_type = "random"
      expect(parser).not_to be_valid
    end

    it "should not be valid without a name" do
      parser.name = nil
      expect(parser).not_to be_valid
    end

    it "should not be valid with a duplicated name" do
      parser2 = build(:parser, name: parser.name)
      expect(parser2).not_to be_valid
    end

    it 'must have a name that can be used as a class name' do
      parser3 = build(:parser, name: "Hey'bro!")
      parser3.valid?
      expect(parser3.errors.messages[:name].first).to eq 'Parser name includes invalid characters. The name can only contain Alphabetical or Numeric characters, and can not start with a number.'
      expect(parser3).not_to be_valid
    end

    it 'cannot have slashes in the class name' do
      parser4 = build(:parser, name: 'Jeu/asd')
      parser4.valid?
      expect(parser4.errors.messages[:name].first).to eq 'Your Parser Name includes invalid characters. Please remove the /.'
      expect(parser4).not_to be_valid
    end
  end

  describe "before:destroy" do
    it "should destroy all HarvestSchedules for the given parser." do
      expect(HarvestSchedule).to receive(:destroy_all_for_parser).with(parser.id)
      parser.destroy
    end
  end

  describe '.class_name' do
    it 'returns the parser name as a class name' do
      parser = build(:parser, name: 'nZ Museums')
      expect(parser.class_name).to eq 'NZMuseums'
    end
  end

  describe ".find_by_partners" do
    let!(:partner) { create(:partner) }
    let!(:source) { create(:source, partner: partner) }
    let!(:parser) { create(:parser, source: source) }

    it "should find the Partner" do
      expect(Parser.find_by_partners([partner.id])).to eq [parser]
    end
  end

  context "file paths" do
    let(:parser) { build(:parser, name: "Europeana", strategy: "json") }

    describe "#file_name" do
      it "returns a correct file_name" do
        expect(parser.file_name).to eq "europeana.rb"
      end

      it "changes spaces for underscores" do
        parser.name = "Data Govt NZ"
        expect(parser.file_name).to eq "data_govt_nz.rb"
      end
    end

    describe "path" do
      it "returns the file path relative to the repository root dir" do
        expect(parser.path).to eq "json/europeana.rb"
      end
    end
  end

  describe "xml?" do
    let(:parser) { build(:parser, strategy: "xml", name: "Natlib") }

    it "returns true for Xml strategy" do
      parser.strategy = "xml"
      expect(parser.xml?).to be true
    end

    it "returns true for Oai strategy" do
      parser.strategy = "oai"
      expect(parser.xml?).to be true
    end

    it "returns true for Rss strategy" do
      parser.strategy = "rss"
      expect(parser.xml?).to be true
    end

    it "returns false for Json strategy" do
      parser.strategy = "json"
      expect(parser.xml?).to be false
    end
  end

  describe "json?" do
    let(:parser) { build(:parser, strategy: "json", name: "Natlib") }

    it "returns true for Json strategy" do
      parser.strategy = "json"
      expect(parser.json?).to be true
    end

    it "returns false for Rss strategy" do
      parser.strategy = "rss"
      expect(parser.json?).to be false
    end
  end

  describe "#enrichment_definitions" do
    let(:version) { build(:version) }
    let(:parser_class) { double(:parser_class, enrichment_definitions: {ndha_rights: "Hi"} )}
    let(:loader) { double(:loader, loaded?: true, parser_class: parser_class).as_null_object }

    context 'when version is not passed' do
      it "content is the last content which is set in the Parser itself" do
        parser.enrichment_definitions('staging')
        expect(parser.content).to eq 'class NZMuseums < SupplejackCommon::Xml::Base; end'
      end

      it "returns the parser enrichment definitions" do
        expect(loader.parser_class.enrichment_definitions("staging")).to eq({ndha_rights: "Hi"})
      end

      it "rescues from a excepction" do
        allow(loader).to receive(:parser_class).and_raise(StandardError.new("hi"))
        expect(parser.enrichment_definitions("staging")).to eq({})
      end

      it "should not fail when the parser fails to be loaded due to a syntax error" do
        allow(loader).to receive(:parser_class).and_raise(SyntaxError.new("broken syntax"))
        expect(parser.enrichment_definitions("staging")).to eq({})
      end

      it "returns an empty hash when the parser is unable to load" do
        allow(loader).to receive(:loaded?) { false }
        expect(parser.enrichment_definitions("staging")).to eq({})
      end
    end

    context 'when version is not passed but the parser has a tagged version' do
      before(:each) do
        parser.versions << build(:version, :staging)
      end

      it "parser is set as the content of the last tagged version" do
        parser.enrichment_definitions("staging")
        expect(parser.content).to eq "version for staging"
      end
    end

    context 'when version is passed' do
      it "content is updated" do
        expect(parser).to receive(:content)
        parser.enrichment_definitions("staging", version)
      end

      it "parser has right content from the version" do
        parser.enrichment_definitions("staging", version)
        expect(parser.content).to eq "class NZMuseums; end"
      end

      it "returns the parser enrichment definitions" do
        expect(loader.parser_class.enrichment_definitions("staging", version)).to eq({ndha_rights: "Hi"})
      end

      it "rescues from a excepction" do
        allow(loader).to receive(:parser_class).and_raise(StandardError.new("hi"))
        expect(parser.enrichment_definitions("staging", version)).to eq({})
      end

      it "should not fail when the parser fails to be loaded due to a syntax error" do
        allow(loader).to receive(:parser_class).and_raise(SyntaxError.new("broken syntax"))
        expect(parser.enrichment_definitions("staging", version)).to eq({})
      end

      it "returns an empty hash when the parser is unable to load" do
        allow(loader).to receive(:loaded?) { false }
        expect(parser.enrichment_definitions("staging", version)).to eq({})
      end
    end
  end

  describe "#modes" do
    it "returns normal if the parser is not oai" do
      allow(parser).to receive(:oai?) {false}
      allow(parser).to receive(:full_and_flush_allowed?) {false}
      expect(parser.modes).to eq [['normal', 'Normal']]
    end

    it "returns normal and incremental if the parser is oai" do
      allow(parser).to receive(:oai?) {true}
      allow(parser).to receive(:full_and_flush_allowed?) {false}
      expect(parser.modes).to eq [['normal','Normal'], ['incremental','Incremental']]
    end

    it "returns normal, full_and_flush and incremental if the parser is oai" do
      allow(parser).to receive(:oai?) {true}
      allow(parser).to receive(:full_and_flush_allowed?) {true}
      expect(parser.modes).to eq [['normal','Normal'], ['incremental','Incremental'], ['full_and_flush','Full And Flush']]
    end
  end

  describe "#full_and_flush_allowed?" do
    it "returns true if allowed" do
      allow(parser).to receive(:allow_full_and_flush) { true }
      expect(parser.full_and_flush_allowed?).to be true
    end

    it "returns false if not allowed" do
      allow(parser).to receive(:allow_full_and_flush) { false }
      expect(parser.full_and_flush_allowed?).to be false
    end
  end

  describe "#valid_parser?" do
    it "should return nil" do
      expect(parser.error).to be nil
    end

    it "returns false if not allowed" do
      allow(parser).to receive(:content) { 'nil + 1'}

      expect(parser.valid_parser?('staging')).to be false
      expect(parser.error).to eq({type: NoMethodError, message: "undefined method `+' for nil:NilClass"})
    end
  end

  describe '#updated_last_editor' do
    let(:user)    { create(:user) }
    let(:version) { build(:version, :staging, user: user) }
    let(:parser)  { create(:parser) }

    it 'sets the user as the last edited by before a parser is saved' do
      parser.versions.destroy_all
      parser.versions << version
      parser.save
      expect(parser.last_editor).to eq 'John Doe'
    end
  end

  describe '#datatable_query' do
    let(:user)    { create(:user) }
    let(:version) { build(:version, :staging, user: user) }
    let(:parser)  { create(:parser) }
    let(:options) { {
      search:    'term',
      start:     5,
      per_page:  20,
      order_by:  'updated_at',
      direction: 'desc'
    } }

    it 'returns a MongoID::Criteria' do
      expect(Parser.datatable_query(options)).to be_a(Mongoid::Criteria)
    end

    it 'returns a limited number of records' do
      query = Parser.datatable_query(options)
      expect(query.options[:limit]).to eq(20)
    end

    it 'returns parsers with the offset given' do
      query = Parser.datatable_query(options)
      expect(query.options[:skip]).to eq(5)
    end

    it 'returns only the needed fields' do
      query = Parser.datatable_query(options)
      expect(query.options[:fields]).to include(*%w[
        _id name strategy source_id data_type
        updated_at last_editor source_name partner_name
      ])
    end

    it 'orders by the given field' do
      query = Parser.datatable_query(options)
      expect(query.options[:sort]).to eq({'updated_at' => -1})
    end

    it 'searches through the different fields' do
      query = Parser.datatable_query(options)
      expect(query.selector['$or']).to be_a(Array)
      expect(query.selector['$or']).to eq([
              {"name"=>/term/i},
              {"strategy"=>/term/i},
              {"data_type"=>/term/i},
              {"last_editor"=>/term/i},
              {"partner_name"=>/term/i},
              {"source_name"=>/term/i}
            ])
    end
  end
end
