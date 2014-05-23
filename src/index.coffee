Compiler = require('es6-module-transpiler').Compiler

module.exports = class ES6ModuleTranspiler
  brunchPlugin: yes
  type: 'javascript'
  extension: 'js'

  constructor: (config) ->
    @debug = config?.es6ModuleTranspiler?.debug? or no
    @match = new RegExp(config?.es6ModuleTranspiler?.match or /^app/)
    @wrapper = config?.modules?.wrapper? 'to'+config.modules.wrapper.toUpperCase() or no

    console.log '---> es6-matching:', @match if @debug

  compile: (params, callback) ->
    if @match.test(params.path)
      console.log('---> es6-compiling:', params.path) if @debug
      compiler = new Compiler params.data, params.string
      return callback null, {data: ( if @wrapper then compiler[@wrapper]() else compiler.toCJS() ) }

    else
      console.log('---> es6-ignoring:', params.path) if @debug
      return callback(null, {data: params.data})

