describe GeoRb::GeoCoders::Nominatim do
  subject { client.geocode(query, **optional_params).to_h }
  let(:raw_response) { client.geocode(query, **optional_params).raw }
  let(:optional_params) { {} }
  let(:client) { described_class.new }

  describe "#geocode" do
    describe "only query" do
      context "with no optional params" do
        let(:query) { "435 north michigan ave, chicago il 60611 usa" }
        let(:expected_result) { {latitude: 41.89037385, longitude: -87.62367299422614, altitude: 0} }

        it { is_expected.to include(expected_result) }
      end

      context "when query is CJK" do
        let(:query) { "故宫 北京" }
        let(:expected_result) { {latitude: 39.91727565, longitude: 116.39076940577283, altitude: 0} }

        it { is_expected.to include(expected_result) }
      end
    end

    describe "with viewbox" do
      let(:points) do
        [
          GeoRb::Point.new(56.588456, 84.719353),
          GeoRb::Point.new(56.437293, 85.296822)
        ]
      end
      let(:query) { "строитель томск" }

      context "when not bounded" do
        let(:optional_params) { {viewbox: points} }
        let(:expected_result) { {latitude: 56.4129459, longitude: 84.84783106981399} }

        it { is_expected.to include(expected_result) }
      end

      context "when bounded" do
        let(:optional_params) { {viewbox: points, bounded: true} }

        it { is_expected.to eq({}) }
      end
    end

    describe "with language" do
      let(:query) { "Mohrenstrasse Berlin" }
      let(:optional_params) { {language: "es", detailed: true} }
      let(:expected_result) { {"country" => "Alemania"} }

      it { expect(raw_response[:address]).to include(expected_result) }
    end
  end
end
