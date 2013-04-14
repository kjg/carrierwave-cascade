require 'spec_helper'

describe CarrierWave::Uploader::Base do
  it { should respond_to :primary_storage }
  it { should respond_to :secondary_storage }

  its(:storage_engines){ should have_key :cascade }
end
