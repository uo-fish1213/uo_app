class ImageUploader < CarrierWave::Uploader::Base
  # 画像処理ライブラリを指定（MiniMagickを使う場合）
  include CarrierWave::MiniMagick

  # アップロード先のディレクトリを指定
  storage :file

  # アップロードファイルの保存先
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 画像のリサイズ（必要に応じて）
  # サムネイル用
  version :thumb do
    process resize_to_fill: [200, 200]
  end

  # 中サイズ
  version :medium do
    process resize_to_fill: [400, 400]
  end

  # 大サイズ
  version :large do
    process resize_to_limit: [800, 800]
  end

  # アップロード可能なファイル形式を制限
  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  # ファイル名を変更（オプション:日本語ファイル名対策）
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end