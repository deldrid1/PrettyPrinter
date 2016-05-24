# Squirrel Pretty Printer

This library ‘pretty prints’ Squirrel objects.

On the device, this library is dependent on the [JSONEncoder library](https://github.com/electricimp/JSONEncoder). How you include the library depends on whether you are using it in agent or device code.

### Agent Code

**To add this library to your project, add** `#require "PrettyPrinter.class.nut:1.0.0"` **to the top of your agent code**.

### Device Code

**To add this library to your project, add** `#require "PrettyPrinter.class.nut:1.0.0"` **and** `#require "JSONEncoder.class.nut:1.0.0"` **to the top of your device code**.

## Class Usage

### Constructor: PrettyPrinter(*[indentString, truncate]*)

The PrettyPrinter constructor takes two optional parameters: a string *indentString* containing the level of indentation you require, and a boolean, *truncate*, which lets you select whether a long log output should be truncated. The default value for *indentString* is a string containing four spaces. The default value of *truncate* is `true`.

```squirrel
pp <- PrettyPrinter();
```

## Class Methods

### format(*squirrelObject*)

The *format()* method takes one required parameter: the Squirrel object to be formatted. It returns a string containing the prettifed JSON-encoded version of object.

**Note** When formatting classes or instances, functions will be omitted from the output as they are not currently supported by JSONEncoder.

```squirrel
array <- [1,2,3,4,5];
string <- @"A long,

multiline,

string

    with indentation";

myData <- {
    "key": "value",
    "array": array,
    "string": string
};

prettyJSON <- pp.format(myData);

/* returns this multiline string:
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

### print(*obj [, truncate]*)

The *print()* method formats a Squirrel object using the *format()* method and prints the formatted string. This method takes one required parameter: the Squirrel object to be formatted and printed, and one optional boolean parameter, *truncate*. If *truncate* is not passed in, it will fall back to the default set in the constructor. If *truncate* is set to `true`, **server.log()** will be called on the formatted string and the output may be truncated.  If *truncate* is set to `false`, **server.log()** is called on each line of the formatted string separately, avoiding truncation, although the string may still be subject to message throttling for very long output.

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
