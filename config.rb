# frozen_string_literal: true

ProfileMerge.config do |config|
  config.artisan_path = '/Users/matthewborg/Dropbox/carrier/artisan/roasts/'
  config.boost_path = '/Users/matthewborg/Dropbox/carrier/artisan/boost data/raw/'
  config.target_path = '/Users/matthewborg/Dropbox/carrier/artisan/roasts/merged/'

  config.artisan_files = [
    # 'Guatemala Union Cantinil SO #7760 26-10-07 25.alog',
    # 'Guatemala Union Cantinil CC #7747 26-10-07 12.alog',
    # 'Guatemala Union Cantinil DARK #7755 26-10-07 20.alog',
    # 'Ethiopia Hambella CC #7741 26-10-07 6.alog',
    # 'Decaf Colombia Fortune #7735 26-10-07 1.alog',
    # 'Ethiopia Nensebo Bochesa #7765 26-10-08 2.alog',
    # 'Ethiopia Bookissa SO #7768 26-10-08 5.alog',
    # 'Kenya Gititu AA #7772 26-10-08 9.alog',
    # 'Burundi Ninga Hills #7774 26-10-08 11.alog',
    # 'Colombia Juan Jimenez Pena SO #7775 26-10-08 12.alog',
    # 'Guatemala Union Cantinil CC #7787 26-10-12 12.alog',
    # 'Ethiopia Kebena CC Crash #7789 26-10-12 14.alog',
    'Ethiopia Kebena CC Crash #7790 26-10-12 15.alog'
  ]

  config.boost_files = [
    # 'union 7760.json',
    # 'union cc 7747.json',
    # 'union dt 7755.json',
    # 'hambella cc 7741.json',
    # 'decaf fortune 7735.json',
    # 'nensebo 7765.json',
    # 'bookissa 7768.json',
    # 'gititu 7772.json',
    # 'ninga 7774.json',
    # 'jimenez 7775.json',
    # 'union cc 7787.json',
    # 'kebena cc 7789.json',
    'kebena cc 7790.json'
  ]
end