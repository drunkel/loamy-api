puts "DYLAN: #{ENV["AWS_SECRET_ACCESS_KEY"]}"
puts "DYLAN: #{ENV["AWS_ACCESS_KEY_ID"]}"
puts "DYLAN: #{ENV["FOG_DIRECTORY"]}"
puts "DYLAN: #{ENV["FOG_REGION"]}"


AssetSync.configure do |config|
  config.fog_provider = "AWS"
  config.aws_access_key_id = ENV["AWS_ACCESS_KEY_ID"]
  config.aws_secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
  config.fog_directory = ENV["FOG_DIRECTORY"] # your S3 bucket name
  config.fog_region = ENV["FOG_REGION"] # e.g., 'us-east-1'
  config.aws_iam_roles = true

  # Don't delete files from the store
  config.existing_remote_files = "keep"

  # Automatically replace files with their equivalent gzip version
  config.gzip_compression = true
end
