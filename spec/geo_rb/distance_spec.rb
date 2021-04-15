describe GeoRb::Distance do
  subject { described_class.new(*locations).km }
  let(:north_pole) { GeoRb::Point.new(90, 0) }
  let(:south_pole) { GeoRb::Point.new(-90, 0) }
  let(:earth_radius) { described_class::EARTH_RADIUS }
  let(:earth_circumference) { 2 * Math::PI * earth_radius }

  describe "#measure" do
    context "when points are the same" do
      let(:locations) { %w[0,0 0,0] }

      it { is_expected.to eq 0 }
    end

    context "when distinct points" do
      let(:locations) { %w[0,0 0,1] }

      it { is_expected.to_not eq 0 }
    end

    context "when across antimeridian" do
      let(:nines) { 1 - 1e-30 } # 0.(9)
      let(:locations) { [[0, -179 - nines], [0, 179 + nines]] }

      it { is_expected.to eq 0 }
    end

    context "when trip between poles" do
      let(:locations) { [north_pole, south_pole] }

      it { should be_within(12).of(earth_circumference / 2) }
    end
  end
end
