class window.Trezor
  constructor: (@coinName, @pinHandler, @passphraseHandler) ->
    @coinName = @coinName || 'Bitcoin'
    @initializeTransport()

  initializeTransport: ->
    trezor
      .loadTransport()
      .then((@transport) =>)
      .then(-> trezor.http('/trezor_config_signed.bin'))
      .then((config) => @transport.configure(config))
      .catch((error) =>
        if error.message == 'No connected devices.'
          setTimeout(@initializeTrezor.bind(@), 1500)
        else
          console.log("Error:", arguments)
      )

  withSession: (doThis) ->
    return setTimeout((=> @withSession(doThis)), 1000) unless @transport

    withTransport = =>
      @transport
        .enumerate()
        .then((devices) =>
          if _.any(devices)
            @transport.acquire(devices[0])
          else
            console.log('No devices, waiting...')
            setTimeout(withTransport, 1000)
        ).then((result) =>
          @session = new trezor.Session(@transport, result.session)
          @session
            .initialize()
            .then((response) =>
              features = response.message
              @session.on('pin', @pinHandler)
              @session.on('passphrase', @passphraseHandler)
              doThis(@session, features)
            )
        )
    
    if @session
      @session.release().then(=> withTransport())
    else
      withTransport()

