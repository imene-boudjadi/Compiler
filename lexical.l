%{


    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "syntax.tab.h"


    extern int currentColumn;
    int showsuccess = 1;
    extern int i;
    extern int showLexicalErrorr;



    void yysuccess(const char *s, const char *lexeme, int length);
    void yyerror(const char *s);
    void showLexicalError();

%}


/*Used to get the current line INTEGER*/
%option yylineno
%option noyywrap
%option outfile = "lexical.c"

/*Used for multiline comments*/
%x c_comment




/*Reserved Keywords*/
PROGRAM "Program"
LOOPFOR "for"
LOOPWHILE "while"
GET "get"
DISPLAY "display"
IF "if"
ELSE "else"
ELSEIF "elseIf"
ACQUIRE "Acquire"
DEF "Def"
START "Start"
DEFINE "Define"
IN "IN"
OUT "OUT"


/* Definitions */
DIGIT       [0-9]
CHAR    ["].["]
STRING (\"{ANYTHING}\")
INTEGER -?{DIGIT}+
FLOAT {INTEGER}"\."{DIGIT}+
WHITESPACE  [ \t]+
BOOL  TRUE|FALSE



/*Comments*/
INLINECOMMENT    "//"{ANYTHING}
MULTILINECOMMENT [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]
COMMENT //.*

/*Identifier*/
ID [a-zA-Z][_|a-zA-Z0-9]*


/* Special Char */
ANYTHING .*
LINEBREAK "\n"|"\r"
SEMICOLON ;
COMMA \,

OPENPARENTHESIS \(
CLOSEPARENTHESIS \)
OPENHOOK \{
CLOSEHOOK \}
OPENBRACKET \[
CLOSEBRACKET \]
STRUCTACCESS -\>


/*Logical and arithmetic operators*/
EQUAL ==
NONEQUAL NOT=
AND and
OR or
NOT NOT
XOR xor
NOR nor
INFERIOR \<
SUPERIOR \>
INFERIOREQUAL \<\=
SUPERIOREQUAL \>\=
ADD \+
ADDASSIGN \+\=
SUB -
INCREMENT \+\+
DECREMENT --
SUBASSIGN \-\=
MULT \*
DIVE DIV
DIVR DIVR
MOD \%
POWER \*\*
ASSIGN =


/*Declarations*/
INTEGERDECLARE int
STRINGDECLARE string
BOOLEENDECLARE bool
REALDECLARE float
CHARDECLARE char
ARRAYDECLARE array
VARSTRUCT VarStruct
CONST Const
VAR Var

%%


{PROGRAM} {
    yysuccess("Program", yytext, yyleng);
    currentColumn += yyleng;
    return PROGRAM;
}

{LOOPFOR} {
    yysuccess("for", yytext, yyleng);
    currentColumn += yyleng;
    return LOOPFOR;
}

{LOOPWHILE} {
    yysuccess("while", yytext, yyleng);
    currentColumn += yyleng;
    return LOOPWHILE;
}

{GET} {
    yysuccess("get", yytext, yyleng);
    currentColumn += yyleng;
    return GET;
}

{IN} {
    yysuccess("IN", yytext, yyleng);
    currentColumn += yyleng;
    return IN;
}

{OUT} {
    yysuccess("OUT", yytext, yyleng);
    currentColumn += yyleng;
    return OUT;
}

{DISPLAY} {
    yysuccess("display", yytext, yyleng);
    currentColumn += yyleng;
    return DISPLAY;
}

{IF} {
    yysuccess("if", yytext, yyleng);
    currentColumn += yyleng;
    return IF;
}

{ELSE} {
    yysuccess("else", yytext, yyleng);
    currentColumn += yyleng;
    return ELSE;
}

{ELSEIF} {
    yysuccess("elseIf", yytext, yyleng);
    currentColumn += yyleng;
    return ELSEIF;
}

{ACQUIRE} {
    yysuccess("Acquire", yytext, yyleng);
    currentColumn += yyleng;
    return ACQUIRE;
}

{VAR} {
    yysuccess("Var", yytext, yyleng);
    currentColumn += yyleng;
    return VAR;
}

{DEF} {
    yysuccess("Def", yytext, yyleng);
    currentColumn += yyleng;
    return DEF;
}

{START} {
    yysuccess("Start", yytext, yyleng);
    currentColumn += yyleng;
    return START;
}

{DEFINE} {
    yysuccess("Define", yytext, yyleng);
    currentColumn += yyleng;
    return DEFINE;
}

{CHAR} {
    yysuccess("char", yytext, yyleng);
    currentColumn += yyleng;
    yylval.charVal=yytext[0];
    return CHAR;
}

{INTEGER} {
    yysuccess("integer", yytext, yyleng);
    currentColumn += yyleng;
    yylval.intVal=atoi(yytext);
    return INTEGER;
}

{FLOAT} {
    yysuccess("float", yytext, yyleng);
    currentColumn += yyleng;
    yylval.realVal=atof(yytext);
    return FLOAT;
}

{BOOL} {
    yysuccess("bool", yytext, yyleng);
    currentColumn += yyleng;
    return BOOL;
}















{SEMICOLON} {
    yysuccess("semicolon", yytext, yyleng);
    currentColumn += yyleng;

    return SEMICOLON;
}

{COMMA} {
    yysuccess("comma", yytext, yyleng);
    currentColumn += yyleng;
    yylval.charVal = ',';
    return COMMA;
}

{OPENPARENTHESIS} {
    yysuccess("openparent", yytext, yyleng);
    currentColumn += yyleng;
    return OPENPARENTHESIS;
}

{CLOSEPARENTHESIS} {
    yysuccess("closeparent", yytext, yyleng);
    currentColumn += yyleng;
    return CLOSEPARENTHESIS;
}

{OPENHOOK} {
    yysuccess("openhook", yytext, yyleng);
    currentColumn += yyleng;
    return OPENHOOK;
}

{CLOSEHOOK} {
    yysuccess("closehook", yytext, yyleng);
    currentColumn += yyleng;
    return CLOSEHOOK;
}

{OPENBRACKET} {
    yysuccess("openbracket", yytext, yyleng);
    currentColumn += yyleng;
    return OPENBRACKET;
}

{CLOSEBRACKET} {
    yysuccess("closebracket", yytext, yyleng);
    currentColumn += yyleng;
    return CLOSEBRACKET;
}

{STRUCTACCESS} {
    yysuccess("structaccess", yytext, yyleng);
    currentColumn += yyleng;
    return STRUCTACCESS;
}

{EQUAL} {
    yysuccess("equal", yytext, yyleng);
    currentColumn += yyleng;
    return EQUAL;
}

{NONEQUAL} {
    yysuccess("nonequal", yytext, yyleng);
    currentColumn += yyleng;
    return NONEQUAL;
}

{AND} {
    yysuccess("and", yytext, yyleng);
    currentColumn += yyleng;
    return AND;
}

{OR} {
    yysuccess("or", yytext, yyleng);
    currentColumn += yyleng;
    return OR;
}

{NOT} {
    yysuccess("not", yytext, yyleng);
    currentColumn += yyleng;
    return NOT;
}

{XOR} {
    yysuccess("xor", yytext, yyleng);
    currentColumn += yyleng;
    return XOR;
}

{NOR} {
    yysuccess("nor", yytext, yyleng);
    currentColumn += yyleng;
    return NOR;
}

{INFERIOR} {
    yysuccess("inferior", yytext, yyleng);
    currentColumn += yyleng;
    return INFERIOR;
}

{SUPERIOR} {
    yysuccess("superior", yytext, yyleng);
    currentColumn += yyleng;
    return SUPERIOR;
}

{INFERIOREQUAL} {
    yysuccess("inferiorequal", yytext, yyleng);
    currentColumn += yyleng;
    return INFERIOREQUAL;
}

{SUPERIOREQUAL} {
    yysuccess("superiorequal", yytext, yyleng);
    currentColumn += yyleng;
    return SUPERIOREQUAL;
}

{ADD} {
    yysuccess("add", yytext, yyleng);
    currentColumn += yyleng;
    return ADD;
}

{ADDASSIGN} {
    yysuccess("addassign", yytext, yyleng);
    currentColumn += yyleng;
    return ADDASSIGN;
}

{SUB} {
    yysuccess("sub", yytext, yyleng);
    currentColumn += yyleng;
    return SUB;
}

{INCREMENT} {
    yysuccess("increment", yytext, yyleng);
    currentColumn += yyleng;
    return INCREMENT;
}

{DECREMENT} {
    yysuccess("decrement", yytext, yyleng);
    currentColumn += yyleng;
    return DECREMENT;
}

{SUBASSIGN} {
    yysuccess("subassign", yytext, yyleng);
    currentColumn += yyleng;
    return SUBASSIGN;
}

{MULT} {
    yysuccess("mult", yytext, yyleng);
    currentColumn += yyleng;
    return MULT;
}

{DIVE} {
    yysuccess("divE", yytext, yyleng);
    currentColumn += yyleng;
    return DIVE;
}

{DIVR} {
    yysuccess("divR", yytext, yyleng);
    currentColumn += yyleng;
    return DIVR;
}

{MOD} {
    yysuccess("mod", yytext, yyleng);
    currentColumn += yyleng;
    return MOD;
}

{POWER} {
    yysuccess("power", yytext, yyleng);
    currentColumn += yyleng;
    return POWER;
}

{ASSIGN} {
    yysuccess("assign", yytext, yyleng);
    currentColumn += yyleng;
    return ASSIGN;
}

{INTEGERDECLARE} {
    yysuccess("integerdeclare", yytext, yyleng);
    currentColumn += yyleng;
    strcpy( yylval.string ,"int");
    return INTEGERDECLARE;
}

{STRINGDECLARE} {
    yysuccess("stringdeclare", yytext, yyleng);
    currentColumn += yyleng;
    strcpy( yylval.string , "string");
    return STRINGDECLARE;
}

{BOOLEENDECLARE} {
    yysuccess("booldeclare", yytext, yyleng);
    currentColumn += yyleng;
    strcpy(yylval.string , "bool");
    return BOOLEENDECLARE;
}

{REALDECLARE} {
    yysuccess("realdeclare", yytext, yyleng);
    currentColumn += yyleng;
    strcpy(  yylval.string ,"float");
    return REALDECLARE;
}

{CHARDECLARE} {
    yysuccess("chardeclare", yytext, yyleng);
    currentColumn += yyleng;
    strcpy( yylval.string , "char");
    return CHARDECLARE;
}

{ARRAYDECLARE} {
    yysuccess("arraydeclare", yytext, yyleng);
    currentColumn += yyleng;
    return ARRAYDECLARE;
}

{VARSTRUCT} {
    yysuccess("VarStruct", yytext, yyleng);
    currentColumn += yyleng;
    return VARSTRUCT;
}

{CONST} {
    yysuccess("Const", yytext, yyleng);
    currentColumn += yyleng;
    return CONST;
}

{ID} {
    yysuccess("ID", yytext, yyleng);
    currentColumn += yyleng;
    strcpy( yylval.string,yytext);
    return ID;

}

{STRING} {
    yysuccess("string", yytext, yyleng);
    currentColumn += yyleng;
    return STRING;
}




{INLINECOMMENT} {
    yysuccess("inlinecomment", yytext, yyleng);
    currentColumn +=yyleng;
}


{MULTILINECOMMENT} {
    yysuccess("multicomment", yytext, yyleng);
    currentColumn +=yyleng;
}

{WHITESPACE} {
    currentColumn+=yyleng;
}


{LINEBREAK} {
    currentColumn = 1;
}


<<EOF>> yyterminate();

. {
    yyerror("Unrecognized character");
    showLexicalError();
    yyterminate();
}


%%


void yysuccess(const char *s, const char *lexeme, int length) {
    if(showsuccess) {
        printf("Found %s : ", s);
        printf("\033[0;32m");
        printf("'%s'", lexeme);
        printf("\033[0m");
        printf(" at Ln %d Col %d \n", yylineno, currentColumn);
    }
}

void yyerror(const char *s) {
    printf("\033[0;31m");
    printf("\033[0m");
}

void showLexicalError() {
    printf("File \"input.txt\", line %d, character %d: Lexical error : Unrecognized character: %s \n", yylineno, currentColumn, yytext);
    showLexicalErrorr = 1;
}
