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
    its(:primary_storage){ should be_a(CarrierWave::Storage::Fog)}
    its(:secondary_storage){ should be_a(CarrierWave::Storage::File)}
  end

  describe "#store!" do
    let(:file){ CarrierWave::SanitizedFile.new("hello") }

    before do
      cascade.primary_storage.stub(:store! => file)
      cascade.secondary_storage.stub(:store! => file)
    end

    it "stores to the primary_storage" do
      cascade.primary_storage.should_receive(:store!).with(file)
      cascade.store!(file)
    end

    it "does not store to the secondary_storage" do
      cascade.secondary_storage.should_not_receive(:store!)
      cascade.store!(file)
    end
  end

  describe "#retrieve!" do
    let(:primary_file){ CarrierWave::SanitizedFile.new("primary") }
    let(:secondary_file){ CarrierWave::SanitizedFile.new("secondary") }

    before do
      cascade.primary_storage.stub(:retrieve! => primary_file)
      cascade.secondary_storage.stub(:retrieve! => secondary_file)
    end

    context "when file exists in primary_storage" do
      before do
        primary_file.stub(:exists? => true)
      end

      context "when file exists in secondary_storage" do
        before do
          secondary_file.stub(:exists? => true)
        end

        it "returns the primary_file" do
          cascade.retrieve!('file').should == primary_file
        end
      end

      context "when file doesn't exist in secondary_storage" do
        before do
          secondary_file.stub(:exists? => false)
        end

        it "returns the primary_file" do
          cascade.retrieve!('file').should == primary_file
        end
      end

    end

    context "when file doesn't exist in primary_storage" do
      before do
        primary_file.stub(:exists? => false)
      end

      context "when file exists in secondary_storage" do
        before do
          secondary_file.stub(:exists? => true)
        end

        it "returns the secondary_file" do
          cascade.retrieve!('file').should == secondary_file
        end
      end

      context "when file doesn't exist in secondary_storage" do
        before do
          secondary_file.stub(:exists? => false)
        end

        it "returns the primary_file" do
          cascade.retrieve!('file').should == primary_file
        end
      end
    end
  end
end
