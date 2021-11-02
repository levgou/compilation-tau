import java.util.HashMap;
import java.util.Map;
import java.lang.Exception;
import java.lang.Math;


public class Token {
    public final String val;
    public final int type;
    public final String typeStr;
    public final int line;
    public final int startPosition;

    public static final int LIMIT = ((1 << 15)-1);


    public Token(Object val, int type, int line, int startPosition) {
        // String representation of a string has Enclosing ", ex: "someStringHere"
        if (type == TokenNames.STRING) {
            this.val = "\"" + val.toString() + "\"";
        } else if (type == TokenNames.INVALID) {
            throw new IllegalArgumentException();
        } else if (val != null) {
            if (type == TokenNames.INT) {
                // int number = Integer.parseInt(val);
                try {
                    int number = (int) val;
                    if (number > LIMIT || number < 0) {
                        throw new IllegalArgumentException();
                    }
                } catch (Exception e){
                    throw new IllegalArgumentException();
                }
                

            }
            this.val = val.toString();
        } else {
            this.val = "";
        }

        this.type = type;
        this.typeStr = Token.tokenName(type);
        this.line = line;
        this.startPosition = startPosition;
    }

    public static Map<Integer, String> tokenNames = new HashMap<Integer, String>() {{
        put(TokenNames.EOF, "EOF");
        put(TokenNames.PLUS, "PLUS");
        put(TokenNames.MINUS, "MINUS");
        put(TokenNames.TIMES, "TIMES");
        put(TokenNames.DIVIDE, "DIVIDE");
        put(TokenNames.LPAREN, "LPAREN");
        put(TokenNames.RPAREN, "RPAREN");
        put(TokenNames.INT, "INT");
        put(TokenNames.ID, "ID");
        put(TokenNames.STRING, "STRING");
        put(TokenNames.LBRACK, "LBRACK");
        put(TokenNames.RBRACK, "RBRACK");
        put(TokenNames.LBRACE, "LBRACE");
        put(TokenNames.RBRACE, "RBRACE");
        put(TokenNames.COMMA, "COMMA");
        put(TokenNames.DOT, "DOT");
        put(TokenNames.SEMICOLON, "SEMICOLON");
        put(TokenNames.ASSIGN, "ASSIGN");
        put(TokenNames.EQ, "EQ");
        put(TokenNames.LT, "LT");
        put(TokenNames.GT, "GT");
        put(TokenNames.ARRAY, "ARRAY");
        put(TokenNames.CLASS, "CLASS");
        put(TokenNames.EXTENDS, "EXTENDS");
        put(TokenNames.RETURN, "RETURN");
        put(TokenNames.WHILE, "WHILE");
        put(TokenNames.IF, "IF");
        put(TokenNames.TYPE_INT, "TYPE_INT");
        put(TokenNames.TYPE_STRING, "TYPE_STRING");
        put(TokenNames.NIL, "NIL");
        put(TokenNames.NEW, "NEW");
    }};

    public static String tokenName(int type) {
        return tokenNames.getOrDefault(type, "UNKNOWN");
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
