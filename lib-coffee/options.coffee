module.exports =
  # should it do strict parsing (error on invalid argument)?
  strict: no
  # should the arguments be case sensitive?
  caseSensitive: no
  # the error message given when strict is on and an argument is invalid.
  notFoundStr: "Invalid argument {arg}!" # replaces {arg} by argument name.
  # the error message given when strict is on and an argument is of invalid type.
  invalidType: "The argument {arg} requires the type {type}!" # {arg} = argument name and {type} = type
  # the error message given when strict is on and finds a repeat argument without "multiple"
  repeatedArg: "The argument {arg} was already used!" # {arg} = argument name
  # the error message given when strict is on and finds an empty argument without "allowEmpty"
  emptyArgErr: "The argument {arg} must not be empty!" # {arg} = argument name
  # the path string to convert path's to
  pathSymbol: "/"
  # the array separating string
  arraySymbol: ","
  # the parsing cache limit
  parseCache: 1