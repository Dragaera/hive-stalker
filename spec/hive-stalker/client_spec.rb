# Todo: DRY up specs.
module HiveStalker
  RSpec.describe Client do
    let(:client) { Client.new }

    describe '#initialize' do
      it 'should use the default endpoint if not specified otherwise' do
        expect(client.endpoint).to eq HiveStalker::Client::HIVE_ENDPOINT
      end
      it 'should allow to overwrite the endpoint' do
        client2 = Client.new(endpoint: 'http://foo.bar')
        expect(client2.endpoint).to eq 'http://foo.bar'
      end
    end

    describe '#get_player_data' do
      it 'should return a hash with various information' do
        response = double(Typhoeus::Response)
        allow(response).to receive(:success?) { true }
        allow(response).to receive(:body) { HIVE_SAMPLE_DATA }
        allow(Typhoeus).to receive(:get) { response }

        hsh = client.get_player_data(48221310)

        kv_pairs = {
          player_id: 455990,
          steam_id: 48221310,
          alias: '|LZ| Morrolan',
          score: 4371,
          level: 12,
          experience: 95938,
          badges_enabled: false,
          badges: [],
          skill: 693,
          time_total: 33790,
          time_marine: 24110,
          time_alien: 9680,
          time_commander: 239,
          reinforced_tier: nil,
          adagrad_sum: 0.00938774528901076
        }

        kv_pairs.each do |key, value|
          expect(hsh).to have_key key
          expect(hsh.fetch(key)).to eq(value)
        end
      end

      it 'should convert legacy skill values to an int value' do
        response = double(Typhoeus::Response)
        allow(response).to receive(:success?) { true }
        allow(response).to receive(:body) { HIVE_SAMPLE_LEGACY_DATA }
        allow(Typhoeus).to receive(:get) { response }

        hsh = client.get_player_data(33472508)
        expect(hsh[:skill]).to eq 995
      end

      it 'should raise upon non-succesful status codes' do
        response = double(Typhoeus::Response)
        allow(response).to receive(:success?) { false }
        allow(response).to receive(:code) { 500 }
        allow(Typhoeus).to receive(:get) { response }

        expect { client.get_player_data(48221310) }.to raise_error(APIError)
      end

      it 'should raise upon transport failure' do
        response = double(Typhoeus::Response)
        allow(response).to receive(:success?) { false }
        allow(response).to receive(:code) { 0 }
        allow(response).to receive(:return_message) { 'Could not connect to peer' }
        allow(Typhoeus).to receive(:get) { response }

        expect { client.get_player_data(48221310) }.to raise_error(APIError)
      end

      it 'should raise upon receiving invalid JSON' do
        response = double(Typhoeus::Response)
        allow(response).to receive(:success?) { true }
        allow(response).to receive(:body) { '{ "a": 1, '}
        allow(Typhoeus).to receive(:get) { response }


        expect { client.get_player_data(48221310) }.to raise_error(APIError)
      end

      it 'should raise upon receiving incomplete JSON' do
        response = double(Typhoeus::Response)
        allow(response).to receive(:success?) { true }
        allow(response).to receive(:body) { '{}'}
        allow(Typhoeus).to receive(:get) { response }


        expect { client.get_player_data(48221310) }.to raise_error(APIError)
      end
    end
  end
end
