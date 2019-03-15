require "spec_helper"
require "bacho_parser/record"
require "bacho_parser"

RSpec.shared_examples "a record" do
  describe "line length validation" do
    context "when line is too big" do
      let(:line) { "*" * (BachoParser::Record::MAX_LENGTH + 1) }

      it "does not parse" do
        expect { subject }.to raise_error(BachoParser::ParseError)
      end
    end

    context "when line is too short" do
      let(:line) { "*" }

      it "does not parse" do
        expect { subject }.to raise_error(BachoParser::ParseError)
      end
    end
  end
end
