/**
 * Class for pretty-printing squirrel objects
 * @author Jaye Heffernan <jaye@mysticpants.com>
 * @version 0.0.0
 */
class PrettyPrinter {
    static version = [0, 0, 0];

    _indentStr = null;
    _truncate = null;
    _encode = null;
    
    /**
     * @param {string} indentStr - String prepended to each line to add one
     * level of indentation (defaults to four spaces)
     * @param {boolean} truncate - Whether or not to truncate long output (can
     * also be set when print is called)
     */
    function constructor(indentStr = null, truncate=true) {
        _indentStr = (indentStr == null) ? "    " : indentStr;
        _truncate = truncate;
                
        if ("JSONEncoder" in getroottable()) {
            // The JSONEncoder class is available, use it
            _encode = JSONEncoder.encode.bindenv(JSONEncoder);
            
        } else if (imp.environment() == ENVIRONMENT_AGENT) {
            // We are in the agent, fall back to built in encoder
            _encode = http.jsonencode.bindenv(http);
            
        } else  {
            throw "Unmet dependency: PrettyPrinter requires JSONEncoder when ran in the device";
        }
    }
    
    /**
     * Prettifies some JSON
     * @param {string} json - JSON encoded string
     */
    function _prettify(json) {
        local r = ""; // Result string
        local pos = 0; // Level of indentation
        local prev = null; // Previous character
        local inQuotes = false; // Are we inside a pair of quotes?
        
        // Adds the required indentation to the current (empty) line
        local indent = function() {
            for (local i = 0; i < pos; i++) {
                r += _indentStr;
            }
        }
        
        foreach (char in json) {
            if (char == '"' && prev != '\\') {
                // End of quoted string
                inQuotes = !inQuotes;
                
            } else if((char == '}' || char == ']') && !inQuotes) {
                // End of an object, dedent
                r += "\n";
                pos--;
                indent();
            }
            
            // Push the current character
            r += char.tochar();
            
            if ((char == ',' || char == '{' || char == '[') && !inQuotes) {
                r += "\n";
                
                if (char == '{' || char == '[') {
                    // Start of an object, indent further
                    pos++;
                }
                
                indent();
            }
     
            prev = char;
        }
        
        return r;
    }
    
    /**
     * Prettifies a squirrel object
     * 
     * Functions will NOT be included
     * @param {*} obj - A squirrel object
     * @returns {string} json - A pretty JSON string
     */
    function format(obj) {
        return _prettify(_encode(obj));
    }
    
    /**
     * Pretty-prints a squirrel object
     * 
     * Functions will NOT be included
     * @param {*} obj - Object to print
     * @param {boolean} truncate - Whether to truncate long output (defaults to
     * the instance-level configuration set in the constructor)
     */
    function print(obj, truncate=null) {
        truncate = (truncate == null) ? _truncate : truncate;
        local pretty = this.format(obj);
        (truncate)
            ? server.log(pretty)
            : _forceLog(pretty);
    }
    
    /**
     * Forceably logs a string to the server by logging one line at a time
     * 
     * This curcumvents then log's truncation, but messages may still be
     * throttled if string is too long
     * @param {string} string - String to log
     * @param {number max - Maximum number of lines to log
     */
    static function _forceLog(string, max=null) {
        foreach (i, line in split(string, "\n")) {
            if (max != null && i == max) {
                break;
            }
            server.log(line);
        }
    }
}
