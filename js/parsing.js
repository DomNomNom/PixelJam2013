
// hackery to allow the following syntax to be cross-compatible:
// Float.parseFloat("123.45") == 123.45;
var Float = {
    parseFloat : function(str) {
        return parseFloat(str);
    }
}