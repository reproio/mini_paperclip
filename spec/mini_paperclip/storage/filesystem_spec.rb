RSpec.describe MiniPaperclip::Storage::Filesystem do
  let(:record) { Record.new }

  it "#write" do
    record.image_file_name = 'image.png'
    attachment = MiniPaperclip::Attachment.new(record, :image)
    filesystem = MiniPaperclip::Storage::Filesystem.new(attachment, MiniPaperclip.config)
    file = double('File')
    allow(file).to receive(:path).and_return('file.png')
    expect(FileUtils).to receive(:cp).with('file.png', %r{spec/temp/records/images/.*.png})
    filesystem.write(:original, file)
  end

  it "#open" do
    attachment = MiniPaperclip::Attachment.new(record, :image)
    filesystem = MiniPaperclip::Storage::Filesystem.new(attachment, MiniPaperclip.config)
    file = Rack::Test::UploadedFile.new("spec/paperclip.jpg", 'image/jpeg')
    filesystem.write(:original, file)
    expect(filesystem.open(:original).size).to eq(file.size)
  end
end
