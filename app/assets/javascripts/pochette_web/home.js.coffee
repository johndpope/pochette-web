coins =
  bitcoin:
    coin_name: 'Bitcoin'
    coin_shortcut: 'BTC'
    maxfee_kb: 10000
    address_type: 0
    min_output_amount: 5340
    script_types: { 5: 'PAYTOSCRIPTHASH' }
    send_tx_url: 'https://insight.bitpay.com/api/tx/send'
    fee_per_kb: 10000
    address_type_p2sh: 5
  testnet:
    coin_name: 'Testnet'
    coin_shortcut: 'TEST'
    maxfee_kb: 10000000
    address_type: 111
    min_output_amount: 5340
    script_types: { 196: 'PAYTOSCRIPTHASH' }
    send_tx_url: 'https://test-insight.bitpay.com/api/tx/send'
    fee_per_kb: 10000

readTextArea = (field) ->
  try
    JSON.parse(field.val())
  catch
    null

writeTextArea = (field, value) ->
  field.val(JSON.stringify(value, 1, 4))

modifyTextArea = (selector, emptyValue, func) ->
  field = $(selector)
  value = readTextArea(field) || emptyValue
  func(value)
  writeTextArea(field, value)

# Handles Trezor's PIN request by showing a dialog
# mimicing a numeric keyboard and passes the selection
# back to the device using the received callback.
pinHandler = (type, callback) ->
  element = $('.pin_dialog')
  pin = element.find('.preview input')
  pin.val('')

  element.find('.grid .btn').click (e) =>
    e.preventDefault()
    pin.val(pin.val() + $(e.currentTarget).data('value'))

  element.find('.btn.pin-del').click (e) =>
    e.preventDefault()
    pin.val(pin.val().slice(0, -1))

  element.find('.btn.done').click (e) =>
    callback(null, pin.val())
    element.find('.grid .btn').unbind()
    element.find('.btn.pin-del').unbind()
    element.find('.btn.done').unbind()
    element.modal('hide')

  element.modal('show')

passHandler = (callback) ->
  callback(null, prompt('Type your trezor passphrase'))


updatePendingMultisigSignaturesNotice = ->
  inputs = readTextArea($("#as_hash")).trezor_inputs
  hasPending = _.any inputs, (i) ->
    i.multisig && _.select(i.multisig.signatures, (s) -> s.length > 0) < i.multisig.m
  if hasPending
    $("#pending_multisig_signatures").removeClass('hidden')
  else
    $("#pending_multisig_signatures").addClass('hidden')

updatePreparedTransactionSignatures = (signature, session) ->
  prepared = readTextArea($("#as_hash"))
  inputs = prepared.trezor_inputs
  return unless _.any(inputs, (i) -> i.multisig)

  session.getPublicKey([]).then (result) ->
    public_key = result.message.node.public_key
    _.each inputs, (i) ->
      index = _.findIndex i.multisig.pubkeys, (p) -> p.node.public_key == public_key
      i.multisig.signatures[index] = signature
    writeTextArea($("#as_hash"), prepared)

$ ->
  coin = coins.testnet
  trezor = new Trezor(coin.name, pinHandler, passHandler)

  $('#add_address').click ->
    modifyTextArea '#bip32_addresses', [], (value) ->
      value.push(['your_address_here', [0,0]])

  $('#add_multisig_address').click ->
    modifyTextArea '#bip32_addresses', [], (value) ->
      value.push([['xpub1', 'xpub2', 'xpub3'], [0,0], 2])

  $('#add_output').click ->
    modifyTextArea '#outputs', [], (value) ->
      value.push(['recipient_address_here', 100000000])

  $('#add_utxo_blacklist').click ->
    modifyTextArea '#utxo_blacklist', [], (value) ->
      value.push(['transaction hash', 0])

  $('#read_xpub').click ->
    trezor.withSession (session) ->
      session.getPublicKey([]).then (r) ->
        modifyTextArea '#xpubs', [], (value) ->
          value.push(r.message.xpub)

  $("#prepare_transaction").click ->
    $.ajax
      contentType: 'application/json',
      method: 'post'
      url: '/trezor_transaction_builder'
      dataType: 'json'
      data: JSON.stringify
        bip32_addresses: readTextArea($('#bip32_addresses'))
        outputs: readTextArea($('#outputs'))
        utxo_blacklist: readTextArea($("#utxo_blacklist"))
        change_address: $('#change_address').val()
        fee_per_kb: $("#fee_per_kb").val()
        spend_all: $("#spend_all")[0].checked

      success: (r) ->
        writeTextArea($('#as_hash'), r)

      error: (r) ->
        writeTextArea($('#as_hash'), r.responseJSON)

  $("#sign_transaction").click ->
    t = readTextArea($("#as_hash"))
    trezor.withSession (session) ->
      session.signTx(t.trezor_inputs, t.trezor_outputs, t.transactions, coin)
        .then (res) =>
          writeTextArea($("#signed_transaction"), res)
          updatePendingMultisigSignaturesNotice()
          updatePreparedTransactionSignatures(res.message.serialized.signatures[0], session)

  $('#make_multisig_address').click ->
    $.ajax
      url: '/make_multisig'
      dataType: 'text'
      data:
        xpubs: readTextArea($('#xpubs'))
        path: $('#path').val()
        signers: $('#signers').val()
      success: (r) ->
        $("#view_multisig_address").val(r)


