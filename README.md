# Squirrel Pretty Printer

This library pretty-prints Squirrel objects.

To add this library to your project, copy and paste the code in
PrettyPrinter.class.nut into the top of your code.  On the device, the
[JSONEncoder](https://github.com/electricimp/JSONEncoder) library is also
required.  Add `#require "JSONEncoder.class.nut:1.0.0"` to the top of your code
(before this library).

## Usage

You must first initialize your printer with the constructor.

### PrettyPrinter([indentStr, [truncate=true]])

Returns a printer.  Prepends `indentStr` to add a level of indentation.
`indentStr` can be left null, and will default to four spaces in that case.
`truncate` controls whether long log output should be truncated.  This option is
set on the printer, but can be overriden by `print`.

```
PP <- PrettyPrinter();
```

### format(obj)

Returns a string containing the prettifed, JSON-encoded version of obj.  PLEASE
NOTE that functions will be omitted from the output, as they are not currently
supported by the JSON encoder.

```
array <- [1,2,3,4,5];
string <- @"A long,

multiline,

string

    with indentation"

myData <- {
    "key": "value",
    "array": array,
    "string": string
}

prettyJSON <- PP.format(myData);
```

### print(obj [, truncate=null])

Pretty print a Squirrel object.  Formats using `format`, logs using
`server.log`.  If `truncate` is set to true, calls `server.log` on the string
directly and the output may be truncated.  If `truncate` false, calls
`server.log` on each line of the string seperately, avoiding truncation.  May
still be subject to message throttling for very long output.  If `truncate` left
null, will default to that set in the constructor.

```
// Print myData and do not truncate
PP.print(myData, false)
```

## Testing

To try it out yourself, add the code in test/TestRunner.class.nut to the bottom
of your code and comment/uncomment the lines in the `run` function that you
would like to try.  Then run it with:

```
TestRunner().run();
```

## Licence

The code in this repository is licensed under MIT License.
