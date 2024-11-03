if defined?(AssetSync)
  AssetSync.configure do |config|
    config.aws_access_key_id = ENV["AWS_ACCESS_KEY_ID"]
    config.aws_secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
    config.aws_iam_roles = true

    # Don't delete files from the store
    config.existing_remote_files = "keep"

    # Automatically replace files with their equivalent gzip version
    config.gzip_compression = true
  end
end
