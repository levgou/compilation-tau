/***************************/
/* FILE NAME: LEX_FILE.lex */
/***************************/

/*************/
/* USER CODE */
/*************/
import java_cup.runtime.*;
import java.util.Map;
import java.util.HashMap;

/******************************/
/* DOLAR DOLAR - DON'T TOUCH! */
/******************************/

%%

/************************************/
/* OPTIONS AND DECLARATIONS SECTION */
/************************************/
   
/*****************************************************/ 
/* Lexer is the name of the class JFlex will create. */
/* The code will be written to the file Lexer.java.  */
/*****************************************************/ 
%class Lexer

/********************************************************************/
/* The current line number can be accessed with the variable yyline */
/* and the current column number with the variable yycolumn.        */
/********************************************************************/
%line
%column

/*******************************************************************************/
/* Note that this has to be the EXACT same name of the class the CUP generates */
/*******************************************************************************/
%cupsym TokenNames

/******************************************************************/
/* CUP compatibility mode interfaces with a CUP generated parser. */
/******************************************************************/
%cup

/****************/
/* DECLARATIONS */
/****************/
/*****************************************************************************/   
/* Code between %{ and %}, both of which must be at the beginning of a line, */
/* will be copied verbatim (letter to letter) into the Lexer class code.     */
/* Here you declare member variables and functions that are used inside the  */
/* scanner actions.                                                          */  
/*****************************************************************************/   
%{
	    /*********************************************************************************/
        /* Create a new java_cup.runtime.Symbol with information about the current token */
        /*********************************************************************************/
        public final boolean _DEBUG_PRINTS_ = false;

        private Symbol symbol(int type)               {return new Symbol(type, yyline, yycolumn);}
        private Symbol symbol(int type, Object value) {return new Symbol(type, yyline, yycolumn, value);}

        /*******************************************/
        /* Enable line number extraction from main */
        /*******************************************/
        public int getLine() { return yyline + 1; }

        /**********************************************/
        /* Enable token position extraction from main */
        /**********************************************/
        public int getTokenStartPosition() { return yycolumn + 1; }

        public Map<String, Integer> keywordMapping = new HashMap<String, Integer>() {{
            put("class", TokenNames.CLASS);
            put("nil", TokenNames.NIL);
            put("array", TokenNames.ARRAY);
            put("while", TokenNames.WHILE);
            put("int", TokenNames.TYPE_INT);
            put("extends", TokenNames.EXTENDS);
            put("return", TokenNames.RETURN);
            put("new", TokenNames.NEW);
            put("if", TokenNames.IF);
            put("string", TokenNames.TYPE_STRING);
        }};

        public int commentStartLine = -1;
        public int commentStartColumn = -1;
        public int multiLineCommentNestingLevel = 0 ;

        public int stringStartLine = -1;
        public int stringStartColumn = -1;
        public String strContent = "NOT_INITIALIZED";
%}

/***********************/
/* MACRO DECALARATIONS */
/***********************/
LineTerminator	= \r|\n|\r\n
WhiteSpace		= [ \t\f]
EMPTY_CHAR      = {WhiteSpace} | {LineTerminator}
KEYWORD         = class|nil|array|while|int|extends|return|new|if|string
INTEGER			= 0 | [1-9][0-9]*
CHAR_OR_NUM     = [a-zA-Z0-9]
CHAR			= [a-zA-Z]
ID              = {CHAR}{CHAR_OR_NUM}*

ONE_LINE_COMM_STR = ({CHAR_OR_NUM} | {AllowedInComm} | {WhiteSpace} | [/*])*
ONE_LINE_COMM   = "//"{ONE_LINE_COMM_STR}{LineTerminator}

COMMENT_CONTENT = ({CHAR_OR_NUM} | {AllowedInCommMulti} | {WhiteSpace} | {LineTerminator})+
MULTI_LINE_COMM = {START_MULT_COMMENT}({COMMENT_CONTENT})*?{END_MULT_COMMENT}

AllowedInComm   = "(" | ")" | "{" | "}" | "[" | "]" | "?" | "!" | "+" | "-" | \. | \; | "/"
AllowedInCommMulti = {AllowedInComm} | {STAR_NO_SLASH}

START_MULT_COMMENT = "/*"
END_MULT_COMMENT = "*/"
STAR_NO_SLASH = "*"[^/]

NON_CHAR        = [^a-zA-Z\"]
DOUBLE_QUOTE    = \"
STRING_PATTERN  = {DOUBLE_QUOTE}{CHAR}*{DOUBLE_QUOTE}
BAD_STRING      = {DOUBLE_QUOTE}({CHAR}|{NON_CHAR})*{NON_CHAR}({CHAR}|{NON_CHAR})*{DOUBLE_QUOTE}


/******************************/
/* DOLAR DOLAR - DON'T TOUCH! */
/******************************/
%%

/************************************************************/
/* LEXER matches regular expressions to actions (Java code) */
/************************************************************/

/**************************************************************/
/* YYINITIAL is the state at which the lexer begins scanning. */
/* So these regular expressions will only be matched if the   */
/* scanner is in the start state YYINITIAL.                   */
/**************************************************************/
<YYINITIAL> {

// operators

// transition to comment state in order to deal with nested comments
{ONE_LINE_COMM} {   
          if (_DEBUG_PRINTS_) {
            System.out.println("\n### ONE LINE COMMENT ###\n" + yytext() + "#####\n");
          }
      }

{START_MULT_COMMENT} {
	throw new Error("Not closed comment: " +
                           "<" + yytext() + "> "  +
                           "["  + getLine()  + ":" + getTokenStartPosition() + "]");
}


// string handling:
{STRING_PATTERN}    {
          String matchedStr = new String(yytext());
          // remove matched "
          String noParensStr = matchedStr.substring(1, matchedStr.length() -1);
          return symbol(TokenNames.STRING, noParensStr);
      }
{BAD_STRING}        {
          throw new Error("Bad string: " +
                           "<" + yytext() + "> "  +
                           "["  + getLine()  + ":" + getTokenStartPosition() + "]");
      }
{DOUBLE_QUOTE}      {
          throw new Error("Not closed double quote: " +
                           "<" + yytext() + "> "  +
                           "["  + getLine()  + ":" + getTokenStartPosition() + "]");
      }


"+"					{ return symbol(TokenNames.PLUS);}
"-"					{ return symbol(TokenNames.MINUS);}
"\*"				{ return symbol(TokenNames.TIMES);}
"/"					{ return symbol(TokenNames.DIVIDE);}
"("					{ return symbol(TokenNames.LPAREN);}
")"					{ return symbol(TokenNames.RPAREN);}
"["					{ return symbol(TokenNames.LBRACK);}
"]"					{ return symbol(TokenNames.RBRACK);}
"{"					{ return symbol(TokenNames.LBRACE);}
"}"					{ return symbol(TokenNames.RBRACE);}
","					{ return symbol(TokenNames.COMMA);}
"."					{ return symbol(TokenNames.DOT);}
";"					{ return symbol(TokenNames.SEMICOLON);}
":="				{ return symbol(TokenNames.ASSIGN);}
"="					{ return symbol(TokenNames.EQ);}
"<"					{ return symbol(TokenNames.LT);}
">"					{ return symbol(TokenNames.GT);}

{KEYWORD}           { return symbol(keywordMapping.get(new String(yytext()))); }
{INTEGER}			{ return symbol(TokenNames.INT, new Integer(yytext())); }
{ID}				{ return symbol(TokenNames.ID,     new String( yytext())); }
{EMPTY_CHAR}		{ /* just skip what was found, do nothing */ }
{MULTI_LINE_COMM}   { /* just skip what was found, do nothing */ } 
<<EOF>>				{ return symbol(TokenNames.EOF); }
}

