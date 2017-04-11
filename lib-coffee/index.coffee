args = exports.args = process.argv.slice 2
{ inspect } = require "util"
exports.rawArgs = process.argv
exports.latestParsed = latestParsed = []
argreader = require "./arg-reader"
readArgs = []
options = require "./options"

replaceOptions = (message = 0, arg, type) ->
  switch message
    when 0 then usedmsg = options.notFoundStr or "Invalid argument {arg}!"
    when 1 then usedmsg = options.invalidType or "The argument {arg} requires the type {type}!"
    when 2 then usedmsg = options.repeatedArg or "The argument {arg} was already used!"
    when 3 then usedmsg = options.emptyArgErr or "The argument {arg} must not be empty!"
    else throw new RangeError "Invalid message type."
  usedmsg.replace(/{arg}/g, arg).replace /{type}/g, type

exports.setArgs = ->
  argz = Array.from(arguments)
  argz.forEach((arg) ->
    readarg = argreader arg
    index = null
    readArgs.forEach((ah, i) -> if ah.name and ah.name is arg.name then index = i)
    if index? then readArgs[index] = readarg else readArgs.push readarg
  )

exports.setOptions = ->
  argz = Array.from(arguments)
  latestIndex = 0
  indexPair = 0
  pairedArr = [[]]
  argz.forEach((arg, i) ->
    if indexPair is 1
      indexPair = 0
      pairedArr[latestIndex++].push arg
      if argz[i + 1] then pairedArr.push []
    else
      indexPair = 1
      pairedArr[latestIndex].push arg
  )
  if pairedArr[pairedArr.length - 1].length < 2 then throw new RangeError "Must give value for option!"
  pairedArr.forEach(([option, value]) ->
    if option in Object.keys options
      options[option] = value
    else
      throw new TypeError "Invalid option: #{option}!"
  )
  yes

exports.parseArgs = ->
  parsedArgs = {}
  ignore = no
  args.forEach((arg, i) ->
    if ignore then return ignore = no
    if arg.startsWith("--") or arg.startsWith "-"
      prefix = if arg.startsWith "--" then "name" else "shortcut"
      argval = arg.replace /^--?/, ""
      valid = no
      nextarg = argval.replace /^[^=]+=?/, ""
      if not nextarg and args[i + 1] and not args[i + 1].startsWith "-"
        nextarg = args[i + 1]
        ignore = yes
        actualval = argval
      else
        actualval = argval.match(/^([^=]+)=?/)[1]
      readArgs.forEach((readArg) ->
        caseSensitive = !!options.caseSensitive
        argname = readArg.name
        argshort = readArg.shortcut or null
        unless caseSensitive
          isFullName = (actualval.toLowerCase() is argname.toLowerCase())
          if argshort then isShortName = (actualval.toLowerCase() is argshort.toLowerCase())
          else isShortName = false
        else
          isFullName = (actualval is argname)
          if argshort then isShortName = (actualval is argshort)
          else isShortName = false
        setNull = -> parsedArgs[argname] = null
        if (prefix is "name" and isFullName) or (prefix is "shortcut" and isShortName)
          valid = yes
          if parsedArgs[argname] and not readArg.multiple
            if options.strict then throw new Error replaceOptions 2, argname else return setNull()
          if nextarg
            switch readArg.type
              when "string" then parsedArgs[argname] = nextarg
              when "number"
                if isNaN nextarg
                  if options.strict then throw new TypeError replaceOptions 1, argname, readArg.type
                  else return setNull()
                parsedArgs[argname] = +nextarg
              when "boolean"
                if /^(?:yes|true|1)$/.test nextarg then parsedArgs[argname] = yes
                else if /^(?:no|false|0)$/.test nextarg then parsedArgs[argname] = no
                else parsedArgs[argname] = yes
              when "path"
                unless /\/|\\/.test nextarg
                  if options.strict then throw new TypeError replaceOptions 1, argname, readArg.type
                  else return setNull()
                separatedPath = nextarg.split /\/|\\/
                parsedArgs[argname] = separatedPath.join options.pathSymbol or "/"
              when "array"
                parsedArgs[argname] = nextarg.split options.arraySymbol or ","
              else throw new RangeError "Invalid type #{readArg.type}!"
          else if readArg.allowEmpty
            switch readArg.type
              when "string", "path" then parsedArgs[argname] = ""
              when "number" then parsedArgs[argname] = NaN
              when "boolean" then parsedArgs[argname] = yes
              when "array" then parsedArgs[argname] = []
              else throw new RangeError "Invalid type #{readArg.type}!"
          else
            if options.strict then replaceOptions 3, argname else return setNull()
      )
      if (not valid) and options.strict then throw new TypeError replaceOptions 0, arg else return undefined
  )
  if latestParsed.length >= (if isNaN options.parseCache then 1 else options.parseCache)
    latestParsed.pop()
    latestParsed.unshift parsedArgs
  else
    latestParsed.push parsedArgs
  parsedArgs