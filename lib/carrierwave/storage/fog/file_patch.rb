 class CarrierWave::Storage::Fog::File
  ##
  # Check if the file exists on the remote service
  #
  # === Returns
  #
  # [Boolean] true if file exists or false
  def exists?
    !!directory.files.head(path)
  end
end
