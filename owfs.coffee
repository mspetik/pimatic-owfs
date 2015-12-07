module.exports = (env) ->

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # OWFS driver
  OwfsClient = require("owfs").Client

  HOST = "localhost"

  class OwfsPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("OwfsSensor", {
        configDef: deviceConfigDef.OwfsSensor,
        createCallback: (config) => return new OwfsSensor(config, framework)
      })

  class OwfsSensor extends env.devices.Sensor

    constructor: (@config, framework) ->
      @id = config.id
      @name = config.name
      @host = config.host
      @port = config.port
      # TODO should it be a global object?
      @owfsConnection = new OwfsClient(@host,@port)
      Promise.promisifyAll(@owfsConnection)

      @attributes = {}
      # initialise all attributes
      for attr, i in @config.attributes
        do (attr) =>
          name = attr.name
          sensorPath = attr.sensorPath
          unit = attr.unit
          acronym = attr.acronym
          label = attr.label

          @attributes[name] = {
            description: "One-wire sensor for #{name}"
            type: "number"
            unit: unit
          }
          @attributes[name].acronym = attr.acronym or null
          @attributes[name].label = attr.label or null

          # Create a getter for this attribute
          getter = (=>
            # TODO do we need to catch exceptions here?
            return @owfsConnection.readAsync( sensorPath ).then( (res) =>
              return Number(res)
            )
          )

          # Call base class function to generate a getter with the adequate name
          @_createGetter(name, getter)

          setInterval( (=>
            getter().then( (value) =>
              @emit name, value
            ).catch( (error) =>
              env.logger.error "error updating value of OWFS sensor #{name}:", error.message
              env.logger.debug error.stack
            )
          ), attr.interval or 10000)
      super()

  # ###Finally
  # Create a instance of my plugin
  owfsPlugin = new OwfsPlugin
  # and return it to the framework.
  return owfsPlugin
