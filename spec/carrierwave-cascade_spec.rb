require 'spec_helper'

describe CarrierWave::Uploader::Base do
  it { is_expected.to respond_to :primary_storage }
  it { is_expected.to respond_to :secondary_storage }
  it { is_expected.to respond_to :allow_secondary_file_deletion }

  describe '#storage_engines' do
    subject { super().storage_engines }
    it { is_expected.to have_key :cascade }
  end
end
