describe GeoRb::Location do
  describe ".lookup" do
    context "with valid location" do
      let(:plaza) { described_class.lookup("Plaza San Martin, Lima") }

      it "has the expected points" do
        expect(plaza.latitude).to eq(-12.05165965)
        expect(plaza.longitude).to eq(-77.03460482707533)
      end
    end
  end

  describe "#distance_to" do
    context "from valid location" do
      let(:plaza) { described_class.lookup("Plaza San Martin, Lima, Peru") }

      context "to valid destination" do
        subject { plaza.distance_to(palacio).km }
        let(:palacio) { described_class.lookup("Palacio de Justicia, Lima, Peru") }

        it { is_expected.to eq 0.6650 }
      end
    end
  end
end
