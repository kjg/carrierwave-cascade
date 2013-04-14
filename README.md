# Carrierwave::Cascade

[![Build Status](https://travis-ci.org/kjg/carrierwave-cascade.png?branch=master)](https://travis-ci.org/kjg/carrierwave-cascade)

A storage plugin for carrierwave that will retrieving files from a
secondary storage if the file is not present in the primary storage.
New files will always be stored in the primary storage. This is
perfect for use while migrating from one storage to another, or to
avoid polluting a production environment when running a staging
mirror.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'carrierwave-cascade'
```

## Usage

Configure carrierwave to use Cascade as its storage engine. Then set
primary and secondary storages to be used. Supply other
configuration as needed for the storages.

```ruby
CarrierWave.configure do |config|
  config.storage    = :cascade
  config.primary_storage   = :file
  config.secondary_storage = :fog

  config.fog_credentials = {
    :provider               => 'AWS'
  }
end
```

By default, cascade will prevent files from being deleted out of the
secondary storage. If you wish secondary storage file to be deleted,
specify this in the configs.

```ruby
CarrierWave.configure do |config|
  config.allow_secondary_file_deletion = true
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
