class TestRunner {
    char = null;
    encode = null;
    string = null;
    table = null;
    array = null;
    nested = null;
    deepNested = null;
    longString = null;
    PP = null;
    
    function constructor() {
        
        char = 'A';
        
        string = @"I am a big string,
With Multiple lines...
        
""A quote"" - someone
        
    some indentation too."
            
        table = {
            "key1": "value1",
            "key2": 2,
            "key3": "value3"
        };
        
        array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];
        
        longString = ""
        for (local i = 0; i < 1000; i++) {
            longString += ".";
        }
        
        nested = {
            "key": "value",
            "table": table,
            "string": string,
            "array": array,
            "objects": [table, table, table],
            // Note that functions are NOT included in printing because they are
            // not supported by the JSON encoder
            "function": @(x) x+1
        }      
        
        deepNested = nested
        local depth = 0;
        while(true) {
            deepNested = {
                "array": array,
                "next": deepNested
            }
            
            depth += 1;
            if (depth > 8) {
                break;
            }
        }
        
        PP = PrettyPrinter();
    }
    
    function run() {
        server.log("RUNNING TESTS");
        
        // PP.print(array);
        // PP.print(nested);
        // PP.print(deepNested)
        // PP.print(deepNested, false);
        
        server.log("FINISHED");
    }
}
