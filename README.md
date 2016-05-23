# Squirrel Pretty Printer

This library pretty-prints Squirrel objects.

**To add this library to your project, add** `#require "PrettyPrinter.class.nut:1.0.0"` **to the top of your code.  On the device, this library is dependant on the[JSONEncoder](https://github.com/electricimp/JSONEncoder) library.  If used on the device please also add** `#require "JSONEncoder.class.nut:1.0.0"` **to the top of your device code.**

## Class Usage

### Constructor: PrettyPrinter(*[indentStr, truncate=true]*)

The PrettyPrinter constructor takes two optional parameters: a string,  *indentStr*, containing level of indentation and a boolean, *truncate*, the default setting for whether a long log output should be truncated.  The default value for *indentStr* is a string containing four spaces.  The default value of *truncate* is true.

```squirrel
pp <- PrettyPrinter();
```

## Class Methods

### format(obj)

The *format* method takes one required parameter, the Squirrel object to be formatted, and returns a string containing the prettifed, JSON-encoded version of object.  PLEASE NOTE when formatting classes or instances functions will be omitted from the output, as they are not currently supported by JSONEncoder.

```squirrel
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

prettyJSON <- pp.format(myData);

/* returns this string
{
     "array": [
         1,
         2,
         3,
         4,
         5
    ],
     "string": "A long,\n\nmultiline,\n\nstring\n\n    with indentation",
     "key": "value"
}
*/
```

### print(obj [, truncate])

The *print* method formats a Squirrel object using the PrettyPrint format method and prints the formatted string.  This method takes one required parameter, the Squirrel object to be formatted and printed, and one optional boolean parameter *truncate*.  If *truncate* is not passed in it will fall back to the default set in the constructor.   If `truncate` is set to true, `server.log` will be called on the formatted string and the output may be truncated.  If `truncate` is set to false, `server.log` is called on each line of the formatted string seperately avoiding truncation, although the string may still be subject to message throttling for very long output.

```squirrel
// Print myData and do not truncate
pp.print(myData, false)
```

## Testing

To try it out yourself, add the code in test/TestRunner.class.nut to the bottom
of your code and comment/uncomment the lines in the `run` function that you
would like to try.  Then run it with:

```squirrel
TestRunner().run();
```

## Licence

The PrettyPrint library is licensed under [MIT License](./LICENSE.txt).
