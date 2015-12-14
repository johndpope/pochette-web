PochetteWeb::Engine.routes.draw do
  get '/' => 'home#index'
  post '/trezor_transaction_builder' => 'home#trezor_transaction_builder'
  get '/make_multisig' => 'home#make_multisig'
end
