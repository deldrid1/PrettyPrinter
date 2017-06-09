/** Class for pretty-printing squirrel objects */
PrettyPrinter <- {

    _indentStr = "    ",
    _truncate = false,
    _encode = "JSONEncoder" in getroottable() ? JSONEncoder.encode.bindenv(JSONEncoder) : http.jsonencode.bindenv(http),

    /**
     * Prettifies a squirrel object
     *
     * Functions will NOT be included
     * @param {*} obj - A squirrel object
     * @returns {string} json - A pretty JSON string
     */
    format = function(obj, maxIndentation = 999) {
        return _prettify(_encode(obj), maxIndentation);
    },

    /**
     * Pretty-prints a squirrel object
     *
     * Functions will NOT be included
     * @param {*} obj - Object to print
     * @param {boolean} truncate - Whether to truncate long output (defaults to
     * the instance-level configuration set in the constructor)
     */
    print = function(obj, truncate=null) {
        truncate = (truncate == null) ? _truncate : truncate;
        local pretty = this.format(obj);
        (truncate)
            ? server.log(pretty)
            : _forceLog(pretty);
    },

    /**
     * Forceably logs a string to the server by logging one line at a time
     *
     * This circumvents then log's truncation, but messages may still be
     * throttled if string is too long
     * @param {string} string - String to log
     * @param {number max - Maximum number of lines to log
     */
    _forceLog = function(string, max=null) {
        foreach (i, line in split(string, "\r\n")) {
            if (max != null && i == max) {
                break;
            }
            server.log(line);
        }
    },
    /**
     * Repeats a string a given number of times
     *
     * @returns {string} repeated - a string made of the input string repeated
     * the given number of times
     */
    _repeat = function(string, times) {
        local r = "";
        for (local i = 0; i < times; i++) {
            r += string;
        }
        return r;
    },

    /**
     * Prettifies some JSON
     * @param {string} json - JSON encoded string
     */
    _prettify = function(json, maxIndentation = 999) {
        local i = 0; // Position in the input string
        local pos = 0; // Current level of indentation
        
        local char = null; // Current character
        local prev = null; // Previous character
        
        local inQuotes = false; // Are we inside a pair of quotes?
        
        local r = ""; // Result string
        
        local len = json.len();
        
        while (i < len) {
            char = json[i];
            
            if (char == '"' && prev != '\\') {
                // End of quoted string
                inQuotes = !inQuotes;
                
            } else if((char == '}' || char == ']') && !inQuotes) {
                // End of an object, dedent
                pos--;
                if(pos < maxIndentation) {
                    r += "\r\n" + _repeat(_indentStr, pos);
                }
                
            } else if (char == ' ' && !inQuotes) {
                // Skip any spaces added by the JSON encoder
                i++;
                continue;
                
            }
            
            // Push the current character
            r += char.tochar();
            
            if ((char == ',' || char == '{' || char == '[') && !inQuotes) {
                if (char == '{' || char == '[') {
                    // Start of an object, indent further
                    pos++;
                }
                if(pos <= maxIndentation){
                    // Move to the next line and add indentation
                    r += "\r\n" + _repeat(_indentStr, pos);
                }
                
            } else if (char == ':' && !inQuotes) {
                // Add a space between table keys and values
                r += " ";
            }
     
            prev = char;
            i++;
        }
        
        return r;
    }
}
