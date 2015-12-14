class Rack::Attack
  throttle('req/ip', :limit => 5, :period => 1.minutes) do |req|
    req.path == '/trezor_transaction_builder'
  end
end
