module HiveStalker
  RSpec.describe Stalker do
    let(:stalker) { Stalker.new }

    before(:each) do
      response = double(Typhoeus::Response)
      allow(response).to receive(:success?) { true }
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
      it 'supports Steam IDs as input' do
        expect { stalker.get_player_data(STEAM_ID) }.to_not raise_error
      end

      it 'supports Steam ID 3 as input' do
        expect { stalker.get_player_data(STEAM_ID_3) }.to_not raise_error
      end

      it 'supports Steam ID 64 as input' do
        expect { stalker.get_player_data(STEAM_ID_64) }.to_not raise_error
      end

      it 'returns a PlayerData object' do
        data = stalker.get_player_data(STEAM_ID)
        expect(data).to be_a PlayerData
      end

      it 'raises an exception upon invalid input' do
        expect { stalker.get_player_data('foobar') }.to raise_error(ArgumentError)
      end
    end
  end
end
