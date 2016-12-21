module HiveStalker
  RSpec.describe Stalker do
    let(:stalker) { Stalker.new }

    before(:each) do
      response = double(Typhoeus::Response)
      allow(response).to receive(:body) { HIVE_SAMPLE_DATA }
      allow(Typhoeus).to receive(:get) { response }
    end

    describe '#initalize' do
      it 'passes unused options through to HiveStalker::Client' do
        stalker = Stalker.new(endpoint: 'http://foo.bar')
        expect(stalker.client.endpoint).to eq 'http://foo.bar'
      end
    end

    describe '#get_player_data' do
      it 'returns a PlayerData object' do
        data = stalker.get_player_data(455990)
        expect(data).to be_a PlayerData
      end
    end
  end
end
