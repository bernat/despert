if APP_CONFIG['storage'] == :s3
  CarrierWave.configure do |config|
    config.s3_access_key_id = APP_CONFIG['access_key_id']
    config.s3_secret_access_key = APP_CONFIG['secret_access_key']
    config.s3_bucket = APP_CONFIG['bucket']
    config.s3_region = 'eu-west-1'
    config.s3_access_policy = :private

    config.cache_dir = "system/uploads/tmp"
  end
end

