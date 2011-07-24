AWS::S3::DEFAULT_HOST = "s3-ap-southeast-1.amazonaws.com"
AWS::S3::Base.establish_connection!(
    :access_key_id     => S3Settings.access_key,
    :secret_access_key => S3Settings.secret_access_key
  )

AWS::S3::S3Object.set_current_bucket_to S3Settings.bucket
