Pochette.backend = Pochette::Backends::Toshi.new(
  host: ENV['POCHETTE_TOSHI_HOST'],
  user: ENV['POCHETTE_TOSHI_USER'],
  database: ENV['POCHETTE_TOSHI_DB'],
  password: ENV['POCHETTE_TOSHI_PASS']
)
Pochette.testnet = true 
