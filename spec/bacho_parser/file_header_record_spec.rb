require "spec_helper"
require "bacho_parser/file_header_record"
require_relative "./record_spec"

RSpec.describe BachoParser::FileHeaderRecord do
  subject(:record) { described_class.new(line) }

  it_behaves_like "a record"

  describe "fields" do
    context "valid fields" do
      let(:line) { "A0030000030000000000022102008WESTPAC BANKING CORPORATION                                                                                                      Y " }

      it "extracts the fields correctly" do
        expect(subject.bank_or_supplier).to eq "30"
        expect(subject.branch_or_site).to eq "0000"
        expect(subject.destination_bank).to eq "30"
        expect(subject.destination_branch).to eq "0000"
        expect(subject.processing_date).to eq(Date.new(2008, 10, 22))
        expect(subject.bank_name).to eq "WESTPAC BANKING CORPORATION"
        expect(subject.batchproof_flag).to eq "Y"
      end
    end

    context "invalid processing date" do
      let(:line) { "A0030000030000000000022a02008WESTPAC BANKING CORPORATION                                                                                                      Y " }

      it "does not parse" do
        expect { subject.processing_date }.to raise_error(BachoParser::ParseError)
      end
    end

    context "invalid flag" do
      let(:line) { "A0030000030000000000022102008WESTPAC BANKING CORPORATION                                                                                                      X " }

      it "does not parse" do
        expect { subject.batchproof_flag }.to raise_error(BachoParser::ParseError)
      end
    end
  end
end
