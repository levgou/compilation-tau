public class Token {
    public final String val;
    public final int type;
    public final String typeStr;
    public final int line;
    public final int startPosition;


    public Token(Object val, int type, int line, int startPosition) {
        // String representation of a string has Enclosing ", ex: "someStringHere"
        if (type == TokenNames.STRING) {
            this.val = "\"" + val.toString() + "\"";
        } else if (val != null) {
            this.val = val.toString();
        } else {
            this.val = "";
        }

        this.type = type;
        this.typeStr = Token.tokenName(type);
        this.line = line;
        this.startPosition = startPosition;
    }

    public static String tokenName(int type) {
        switch (type) {
            case TokenNames.ID:
                return "ID";
            case TokenNames.STRING:
                return "STRING";
            default:
                return "UNKNOWN";
        }
    }

    /**
     * Examples:
     * <p>
     * LPAREN[7,8]              -> left parenthesis is encountered in line 7, character position 8
     * INT(74)[3,8]             -> integer 74 is encountered in line 3, character position 8
     * STRING(“Dan”)[2,5]       -> string “Dan” is encountered in line 2, character position
     * ID(numPts)[1,6]          -> 5 identifier numPts is encountered in line 1, character position 6
     */
    @Override
    public String toString() {
        return typeStr +
                (val.isEmpty() ? "" : "(" + val + ")") +
                "[" +
                line +
                "," +
                startPosition +
                "]";
    }
}
