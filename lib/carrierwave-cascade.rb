require 'carrierwave'
require 'carrierwave/cascade/version'
require 'carrierwave/storage/cascade'

if defined?(CarrierWave::Storage::Fog::File)
  file = CarrierWave::Storage::Fog::File.new(nil,nil,nil)
  unless file.respond_to?(:exists?)
    require 'carrierwave/storage/fog/file_patch'
  end
end

class CarrierWave::Uploader::Base
  add_config :primary_storage
  add_config :secondary_storage
  add_config :allow_secondary_file_deletion

  configure do |config|
    config.storage_engines[:cascade] = 'CarrierWave::Storage::Cascade'
  end
end
