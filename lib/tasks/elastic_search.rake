namespace :elastic do
  desc '団体の締め切り処理'
  task create_idex: :environment do
    Rails.logger.info 'Artist index 終了'
    Artist.create_index
    Rails.logger.info 'Artist index作成 終了'
  end
end
