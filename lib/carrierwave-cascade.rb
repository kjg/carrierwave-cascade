require 'carrierwave'
require 'carrierwave/cascade/version'
require 'carrierwave/storage/cascade'

class CarrierWave::Uploader::Base
  add_config :primary_storage
  add_config :secondary_storage

  configure do |config|
    config.storage_engines[:cascade] = 'CarrierWave::Storage::Cascade'
  end
end
