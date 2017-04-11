# nodeargs
Yet another process argument parser for node.

## Installation

`npm install PgBiel/nodeargs`

## Usage
The export will always have a property named `args` and `rawArgs` which are, respectively, the raw arguments but without the node part and the raw arguments with the node part. And with node part I mean this part:

```sh
node yourScript.js```

### Parsing arguments

To make it load arguments, use the `setArgs` function. Let's create an example file:

```js
const nodeargs = require("nodeargs");```
(Note: Even though I'm using ES6 syntax here, this module also works in ES5 and some older versions)

The `setArgs` takes an unlimited amount of objects that will "define" the arguments. Here are the possibilities:

```js
  {
    name: "fullName", // full name of the argument, required (All others are optional). This sets the
    // -- call of the argument. E.g., if this is "hey", then you can use this with "--hey"
    description: "Does stuff", // description of the argument, used in help message (coming soon™)
    type: "string", // the type that the argument will parse to. Can be either string, number, boolean,
    // array, or path. Array and path are separated by a string set with options, explained a little later.
    optional: true, // if optional or not to have this argument (throws error even outside strict!), gonna
    // implement soon. Default value is true
    shortcut: "shortName", // short name of the argument (not required). This sets the - call of the
    // argument. E.g., if this is "h", then you can use this with "-h"
    example: "--fullName=JohnSmith", // an example of usage of the argument to be used in help message (soon™)
    multiple: false, // whether or not to allow multiple usages of this argument (if enabled, the last one is used)
    allowEmpty: false // whether or not to allow this argument to get an empty value, if this is enabled and it gets
    // one, then this argument will receive a default value depending on the type
  }
```
so we can use...
```js
const nodeargs = require("nodeargs");
nodeargs.setArgs({ name: "name", type: "string", shortcut: "n" });```

Next up, we have our options. To set one, use `setOptions` with a key value pair (`setOptions(key, value)`. Any amount of those are accepted, but if you miss the value then it's an error!). Here are the valid options:

* **strict** -> Whether or not should the parser be strict (Default: false). When it is strict, it throws errors on invalid argument, repeated argument (if its `multiple` option is set to false), invalid type for argument and empty argument (if its `allowEmpty` option is set to false).

* **caseSensitive** -> Whether or not should the argument names be case sensitive. (Default: false)

* **notFoundStr** -> Error message given on argument not found and strict mode on. Tip: `{arg}` gets replaced with the argument call.

* **invalidType** -> Error message given on invalid argument type and strict mode on. Tip: `{arg}` gets replaced with the argument name and `{type}` with the _correct_ type.

* **repeatedArg** -> Error message given on repeated argument, strict mode on and its `multiple` option disabled. Tip: `{arg}` gets replaced with the argument name.

* **emptyArgErr** -> Error message given on empty argument value, strict mode on and its `allowEmpty` option disabled. Tip: `{arg}` gets replaced with the argument name.

* **pathSymbol** -> String used to join the split path type into a string (Default: "/"). Please note that this only affects the output; the value given will always be split by `/` and `\` (the `\` one is for Windows compatibility).

* **arraySymbol** -> String used to split an array type (Default: ","). This affects the input value.

* **parseCache** -> Limit of the parsing cache (Default: 1).

Use `parseArgs()` to activate the argument parsing. Doing so will push to the `lastParsed` property of the module, or remove the first element of the array and push in case the cache limit defined at options is exceeded. It also returns the parsed arguments.

## How 2 Contribute

1. Edit the **CoffeeScript** part.
2. Compile it using Cake and the Cakefile.
3. Done. PR it.
