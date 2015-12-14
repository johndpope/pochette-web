require_dependency "pochette_web/application_controller"
require_dependency 'byebug'

module PochetteWeb
  class HomeController < ApplicationController
    rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
      error = {parameter_missing_exception.param => ['parameter is required']}
      render json: { errors: [error] }, status: 422
    end

    def index
    end

    def trezor_transaction_builder
      t = Pochette::TrezorTransactionBuilder.new(
        bip32_addresses: params.require(:bip32_addresses),
        outputs: params.require(:outputs),
        utxo_blacklist: params[:utxo_blacklist],
        change_address: params[:change_address].presence,
        fee_per_kb: params[:fee_per_kb].presence && params[:fee_per_kb].to_i,
        spend_all: params[:spend_all]
      ) 
      
      render json: ( t.valid? ? t.as_hash : t.errors )
    end
    
    def make_multisig
      public_keys = params[:xpubs].collect do |x|
        MoneyTree::Node.from_bip32(x).node_for_path(params[:path]).public_key.key
      end
      address, _ = Bitcoin.pubkeys_to_p2sh_multisig_address(params[:signers].to_i, *public_keys)
      render json: address
    end
  end
end
