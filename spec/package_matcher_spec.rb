RSpec.describe PackageMatcher do
  it "has a version number" do
    expect(PackageMatcher::VERSION).not_to be nil
  end

  describe '#call' do
    subject { described_class.call(input) }

    shared_examples_for 'matching boxes correctly' do |input, expected_output|
      let(:input) { input }
      let(:expected) { expected_output }

      it { is_expected.to eql(expected) }
    end

    it_behaves_like "matching boxes correctly", [], []
    it_behaves_like "matching boxes correctly", ["Cam"], [[:M, ["Cam"]]]
    it_behaves_like "matching boxes correctly", ["Game", "Blue"], [[:L, ["Game"]], [:L, ["Blue"]]]
    it_behaves_like "matching boxes correctly", ["Game", "Game", "Blue"], [[:L, ["Game", "Game"]], [:L, ["Blue"]]]
    it_behaves_like "matching boxes correctly", ["Cam", "Cam", "Game", "Game"], [[:L, ["Cam", "Cam"]], [:L, ["Game", "Game"]]]
    it_behaves_like "matching boxes correctly",
      ["Cam", "Cam", "Cam", "Game", "Game", "Game", "Cam", "Blue"],
      [[:L, ["Cam", "Cam"]], [:L, ["Cam", "Cam"]], [:L, ["Game", "Game"]], [:L, ["Game"]], [:L, ["Blue"]]]
    it_behaves_like "matching boxes correctly",
      ["Cam", "Cam", "Cam", "Game", "Game", "Cam", "Cam", "Blue", "Blue"],
      [[:L, ["Cam", "Cam"]], [:L, ["Cam", "Cam"]], [:M, ["Cam"]], [:L, ["Game", "Game"]], [:L, ["Blue"]], [:L, ["Blue"]]]

    # context "when items is empty" do
    #   let(:input) { [] }
    #   let(:expected) { [] }

    #   it { is_expected.to eql(expected) }
    # end

    context "when ['Cam'] input is provided" do
      let(:input) { ["Cam"] }
      let(:expected) { [[:M, ["Cam"]]] }

      it { is_expected.to eql(expected) }
    end

    context "when ['Cam', 'Game'] input is provided" do
      let(:input) { ["Cam", "Game"] }
      let(:expected) { [[:M, ["Cam"]], [:L, ["Game"]]] }

      it { is_expected.to eql(expected) }
    end
  end
end
