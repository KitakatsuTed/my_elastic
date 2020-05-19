namespace :data do
  desc 'DB,ESのベースの作成'
  task setup: :environment do
    Rails.logger.info 'データセットアップ 終了'
    Artist.index_setup
    Rails.logger.info 'データセットアップ 終了'
  end
end
