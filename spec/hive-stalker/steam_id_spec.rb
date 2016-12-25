module HiveStalker
  RSpec.describe SteamID do
    STEAM_ID = 'STEAM_0:0:24110655'
    STEAM_ID_3 = 'U:1:48221310'
    STEAM_ID_64 = '76561198008487038'

    describe '::from_string' do
      it 'supports SteamID as input' do
        steam_id = SteamID.from_string(STEAM_ID)
        expect(steam_id).to eq 48221310
      end

      it 'supports SteamID 3 as input' do
        steam_id = SteamID.from_string(STEAM_ID_3)
        expect(steam_id).to eq 48221310

        steam_id = SteamID.from_string('U:1:4584616')
        expect(steam_id).to eq 4584616

      end

      it 'supports SteamID 64 as input' do
        steam_id = SteamID.from_string(STEAM_ID_64)
        expect(steam_id).to eq 48221310
      end

      it 'supports an account ID as input' do
        steam_id = SteamID.from_string(48221310)
        expect(steam_id).to eq 48221310
      end

      it 'raises an exception upon invalid input' do
        expect { SteamID.from_string('foobar') }.to raise_error(ArgumentError)
      end
    end
  end
end
