require 'spec_helper'

describe CarrierWave::Storage::Cascade do

  let(:uploader){ CarrierWave::Uploader::Base.new }

  before do
    CarrierWave::Uploader::Base.configure do |config|
      config.primary_storage = :fog
      config.secondary_storage = :file
    end
  end

  subject(:cascade){ CarrierWave::Storage::Cascade.new(uploader) }

  describe "#initialize" do
    describe '#primary_storage' do
      subject { super().primary_storage }
      it { is_expected.to be_a(CarrierWave::Storage::Fog)}
    end

    describe '#secondary_storage' do
      subject { super().secondary_storage }
      it { is_expected.to be_a(CarrierWave::Storage::File)}
    end
  end

  describe "#store!" do
    let(:file){ CarrierWave::SanitizedFile.new("hello") }

    before do
      allow(cascade.primary_storage).to receive_messages(:store! => file)
      allow(cascade.secondary_storage).to receive_messages(:store! => file)
    end

    it "stores to the primary_storage" do
      expect(cascade.primary_storage).to receive(:store!).with(file)
      cascade.store!(file)
    end

    it "does not store to the secondary_storage" do
      expect(cascade.secondary_storage).not_to receive(:store!)
      cascade.store!(file)
    end
  end

  describe "#retrieve!" do
    let(:primary_file){ CarrierWave::SanitizedFile.new("primary") }
    let(:secondary_file){ CarrierWave::SanitizedFile.new("secondary") }

    before do
      allow(cascade.primary_storage).to receive_messages(:retrieve! => primary_file)
      allow(cascade.secondary_storage).to receive_messages(:retrieve! => secondary_file)
    end

    context "when file exists in primary_storage" do
      before do
        allow(primary_file).to receive_messages(:exists? => true)
      end

      context "when file exists in secondary_storage" do
        before do
          allow(secondary_file).to receive_messages(:exists? => true)
        end

        it "returns the primary_file" do
          expect(cascade.retrieve!('file')).to eq(primary_file)
        end
      end

      context "when file doesn't exist in secondary_storage" do
        before do
          allow(secondary_file).to receive_messages(:exists? => false)
        end

        it "returns the primary_file" do
          expect(cascade.retrieve!('file')).to eq(primary_file)
        end
      end

    end

    context "when file doesn't exist in primary_storage" do
      before do
        allow(primary_file).to receive_messages(:exists? => false)
      end

      it "returns a secondary_file proxy" do
        expect(cascade.retrieve!('file')).to be_a(CarrierWave::Storage::Cascade::SecondaryFileProxy)
      end

      it "returns a proxy to the real secondary_file" do
        expect(cascade.retrieve!('file').real_file).to eq(secondary_file)
      end

    end
  end
end

describe CarrierWave::Storage::Cascade::SecondaryFileProxy do
  let(:uploader){ CarrierWave::Uploader::Base.new }
  let(:file){ CarrierWave::SanitizedFile.new("file") }

  subject(:cascade_file){ CarrierWave::Storage::Cascade::SecondaryFileProxy.new(uploader, file) }

  before do
    CarrierWave::Uploader::Base.configure do |config|
      config.primary_storage = :fog
      config.secondary_storage = :file
    end
  end

  it "delegates all methods to the real file" do
    expect(file).to receive(:foooooo)
    cascade_file.foooooo
  end

  context "when allow_secondary_file_deletion is not set" do
    it "doesn't delete the file" do
      expect(file).not_to receive(:delete)
      cascade_file.delete
    end
  end

  context "when allow_secondary_file_deletion is false" do
    before do
      CarrierWave::Uploader::Base.configure do |config|
        config.allow_secondary_file_deletion = false
      end
    end

    it "doesn't delete the file" do
      expect(file).not_to receive(:delete)
      cascade_file.delete
    end
  end

  context "when allow_secondary_file_deletion is true" do
    before do
      CarrierWave::Uploader::Base.configure do |config|
        config.allow_secondary_file_deletion = true
      end
    end

    it "does delete the file" do
      expect(file).to receive(:delete)
      cascade_file.delete
    end
  end
end
