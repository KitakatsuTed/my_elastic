namespace :elastic do
  desc 'Artistのインデックス作成'
  task create_index: :environment do
    Rails.logger.info 'Artist index 終了'
    Artist.create_index force: true
    Rails.logger.info 'Artist index作成 終了'
  end
end
