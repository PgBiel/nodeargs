argreader = module.exports = (arg) ->
  throw new TypeError "Must provide arg." unless arg?
  throw new TypeError "Arg must be an object." unless typeof arg is "object"
  { name, description, type = "string", optional = yes, shortcut, example, multiple = no, allowEmpty = no } = arg
  throw new TypeError "Arg must have a name." unless name?
  switch type
    when "string", "number", "boolean", "path", "array" then null
    else throw new TypeError "Invalid type!"
  name = name.toString()                                      # Those are all additional
  multiple = !!multiple                                       # type checks in case they
  optional = !!optional                                       # aren't what they are
  example = if example? then example.toString() else example  # supposed to be.
  shortcut = if shortcut then shortcut.toString() else shortcut
  description = if description then description.toString() else description
  allowEmpty = !!allowEmpty
  { name, description, type, optional, shortcut, example, multiple, allowEmpty }