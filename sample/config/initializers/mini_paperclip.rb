MiniPaperclip.config.tap do |config|
  config.storage = :s3
  config.url_scheme = 'https'
  config.url_host = 's3-ap-northeast-1.amazonaws.com'
  config.url_path = ':class/:attachment/:hash.:extension'
  config.s3_bucket_name = ENV['AWS_S3_BUCKET']
  config.s3_acl = 'public-read'
  config.hash_secret = "foobar"
end
