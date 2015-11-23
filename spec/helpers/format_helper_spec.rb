require "spec_helper"

describe FormatHelper, type: :helper do
  describe "#truncate" do
    let(:word) { ("a".."z").to_a.sample(35).join }

    context "when string shorter than maximum length" do
      it "returns the string" do
        expect(truncate("abc")).to eql "abc"
      end
    end

    context "with defaults" do
      context "with more than 25 characters" do
        it "truncates to 25 characters" do
          truncated = truncate(word)
          expect(truncated.length).to eql 25
        end

        it "ends with ellipses" do
          expect(truncate(word)).to end_with "..."
        end
      end
    end

    it "truncates to a maximum length" do
      expect(truncate(word, max_length: 10).length).to eql 10
    end

    it "appends configurable postfix" do
      truncated = truncate(word, max_length: 5, postfix: "???")

      expect(truncated.length).to eql 5
      expect(truncated).to end_with "???"
    end

    context "when postfix is longer than maximum length" do
      it "returns the maximum length from the beginning of the postfix" do
        truncated = truncate(word, max_length: 2, postfix: "QQQ")

        expect(truncated).to eql "QQ"
      end
    end
  end
end
