module HiveStalker
  RSpec.describe SteamID do
    describe '::from_string' do
      it 'supports SteamID as input' do
        steam_id = SteamID.from_string(STEAM_ID)
        expect(steam_id).to eq 48221310

        steam_id = SteamID.from_string(STEAM_ID_SHORT)
        expect(steam_id).to eq 5382724
      end

      it 'supports SteamID 3 as input' do
        steam_id = SteamID.from_string(STEAM_ID_3)
        expect(steam_id).to eq 48221310

        steam_id = SteamID.from_string(STEAM_ID_3_SHORT)
        expect(steam_id).to eq 4584616

        # Special case, starts with 765, like an ID 64
        steam_id = SteamID.from_string('7658014')
        expect(steam_id).to eq 7658014
      end

      it 'is not case-sensitive' do
        steam_id = SteamID.from_string(STEAM_ID_MIXED)
        expect(steam_id).to eq 48221310

        steam_id = SteamID.from_string(STEAM_ID_3_LOWER)
        expect(steam_id).to eq 48221310
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
