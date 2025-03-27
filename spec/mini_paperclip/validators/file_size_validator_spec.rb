RSpec.describe MiniPaperclip::Validators::FileSizeValidator do
  describe "less_than" do
    it "#validate_each with valid file size" do
      validator = MiniPaperclip::Validators::FileSizeValidator.new(
        attributes: :img,
        less_than: 1.megabytes,
      )
      mock = double('Record')
      attachment = double('Attachment')
      allow(mock).to receive(:read_attribute_for_validation).with('img_file_size').and_return(1.kilobytes)
      expect(mock).to_not receive(:errors)
      validator.validate_each(mock, :img, attachment)
    end

    it "#validate_each with invalid file size" do
      validator = MiniPaperclip::Validators::FileSizeValidator.new(
        attributes: :img,
        less_than: 1.megabytes,
      )
      mock = double('Record')
      attachment = double('Attachment')
      allow(mock).to receive(:read_attribute_for_validation).with('img_file_size').and_return(2.megabytes)
      errors_mock = double('Errors')
      allow(mock).to receive(:errors).and_return(errors_mock)
      expect(errors_mock).to receive(:add).with(:img, :less_than, { count: "1 MB" })
      expect(errors_mock).to receive(:add).with("img_file_size", :less_than, { count: "1 MB" })
      validator.validate_each(mock, :img, attachment)
    end
  end

  describe "greater_than" do
    it "#validate_each with valid file size" do
      validator = MiniPaperclip::Validators::FileSizeValidator.new(
        attributes: :img,
        greater_than: 1.megabytes,
      )
      mock = double('Record')
      attachment = double('Attachment')
      allow(mock).to receive(:read_attribute_for_validation).with('img_file_size').and_return(2.megabytes)
      expect(mock).to_not receive(:errors)
      validator.validate_each(mock, :img, attachment)
    end

    it "#validate_each with invalid file size" do
      validator = MiniPaperclip::Validators::FileSizeValidator.new(
        attributes: :img,
        greater_than: 1.megabytes,
      )
      mock = double('Record')
      attachment = double('Attachment')
      allow(mock).to receive(:read_attribute_for_validation).with('img_file_size').and_return(1.kilobytes)
      errors_mock = double('Errors')
      allow(mock).to receive(:errors).and_return(errors_mock)
      expect(errors_mock).to receive(:add).with(:img, :greater_than, { count: "1 MB" })
      expect(errors_mock).to receive(:add).with("img_file_size", :greater_than, { count: "1 MB" })
      validator.validate_each(mock, :img, attachment)
    end
  end

  describe "within (1.megabytes..2.megabytes)" do
    let(:validator) do
      validator = MiniPaperclip::Validators::FileSizeValidator.new(
        attributes: :img,
        within: 1.megabytes..2.megabytes,
      )
    end

    context "valid case" do
      [1.megabytes, 1.5.megabytes, 2.megabytes].each do |file_size|
        it "returns no error when file size is #{file_size}" do
          mock = double('Record')
          attachment = double('Attachment')
          allow(mock).to receive(:read_attribute_for_validation).with('img_file_size').and_return(file_size)
          expect(mock).to_not receive(:errors)
          validator.validate_each(mock, :img, attachment)
        end
      end
    end

    context "too large (2.megabytes + 1)" do
      it "returns error" do
        mock = double('Record')
        attachment = double('Attachment')
        allow(mock).to receive(:read_attribute_for_validation).with('img_file_size').and_return(2.megabytes + 1)
        errors_mock = double('Errors')
        allow(mock).to receive(:errors).and_return(errors_mock)
        expect(errors_mock).to receive(:add).with(:img, :within, { count: "1 MB..2 MB" })
        expect(errors_mock).to receive(:add).with("img_file_size", :within, { count: "1 MB..2 MB" })
        validator.validate_each(mock, :img, attachment)
      end
    end

    context "too small (1.megabytes - 1)" do
      it "returns error" do
        mock = double('Record')
        attachment = double('Attachment')
        allow(mock).to receive(:read_attribute_for_validation).with('img_file_size').and_return(1.megabytes - 1)
        errors_mock = double('Errors')
        allow(mock).to receive(:errors).and_return(errors_mock)
        expect(errors_mock).to receive(:add).with(:img, :within, { count: "1 MB..2 MB" })
        expect(errors_mock).to receive(:add).with("img_file_size", :within, { count: "1 MB..2 MB" })
        validator.validate_each(mock, :img, attachment)
      end
    end
  end

  describe "alias 'in' (1.megabytes...3.megabytes)" do
    let(:validator) do
      validator = MiniPaperclip::Validators::FileSizeValidator.new(
        attributes: :img,
        in: 1.megabytes...3.megabytes,
      )
    end
    [1.megabytes, 1.5.megabytes, 3.megabytes - 1 ].each do |file_size|
      it "returns no error when file size is #{file_size}" do
        mock = double('Record')
        attachment = double('Attachment')
        allow(mock).to receive(:read_attribute_for_validation).with('img_file_size').and_return(file_size)
        expect(mock).to_not receive(:errors)
        validator.validate_each(mock, :img, attachment)
      end
    end

    it "returns error when file size is 3.megebaytes" do
      mock = double('Record')
      attachment = double('Attachment')
      allow(mock).to receive(:read_attribute_for_validation).with('img_file_size').and_return(3.megabytes)
      errors_mock = double('Errors')
      allow(mock).to receive(:errors).and_return(errors_mock)
      expect(errors_mock).to receive(:add).with(:img, :within, { count: "1 MB...3 MB" })
      expect(errors_mock).to receive(:add).with("img_file_size", :within, { count: "1 MB...3 MB" })
      validator.validate_each(mock, :img, attachment)
    end
  end
end
