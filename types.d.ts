declare namespace nodeargs {
  export let args: string[];
  export let rawArgs: string[];
  export let latestParsed: parsedArg[];
  export function setArgs(...args: arg[]): void;
  export function setOptions(...options: string[]): boolean;
  export function parseArgs(): parsedArg[];

  interface parsedArg {
    [name: string]: any
  }
  interface arg {
    name: string,
    description?: string,
    type?: argType,
    optional?: boolean,
    shortcut?: string,
    example?: string,
    multiple?: boolean,
    allowEmpty?: boolean
  }
  type argType = "string" | "number" | "boolean" | "path" | "array"
}