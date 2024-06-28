%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #include "struct.c"



    extern FILE *yyin;
	extern FILE *yyout;
    extern int yylineno;
    extern char *yytext;
    extern int yylex();
    extern void yyerror(const char *s);
    int currentColumn = 1;
    extern int showLexicalErrorr =0;


    Row *table_symbols;

    int i =25;
    int ri=1;

    typedef struct quad{
        char op[10];
        char opr1[10];
        char opr2[10];
        char res[10];
    }quad;
    int sauv_fin_while=0;
    quad tab_quad[1000];
    int taille;

%}
 


%union {
    char string[255];
    int intVal;
    double realVal;
    char charVal;
}


%token PROGRAM
%token LOOPFOR LOOPWHILE
%token GET DISPLAY
%token IF ELSE ELSEIF
%token OPENPARENTHESIS CLOSEPARENTHESIS
%token OPENHOOK CLOSEHOOK
%token OPENBRACKET CLOSEBRACKET
%token STRUCTACCESS
%token EQUAL NONEQUAL
%token AND OR NOT XOR NOR
%token INFERIOR SUPERIOR INFERIOREQUAL SUPERIOREQUAL
%token ADD SUB MULT DIV MOD POWER
%token INCREMENT DECREMENT
%token ASSIGN ADDASSIGN SUBASSIGN
%token ACQUIRE CONST VAR DEF START DEFINE VARSTRUCT
%token IN OUT
%token BOOL CONST_LIT STRING_LIT
%token DIGIT LETTER WHITESPACE LINEBREAK


%token ARRAYDECLARE
%token  <charVal> COMMA
%token  <charVal> SEMICOLON
%token  <charVal> CHAR
%token  <intVal> INTEGER
%token  <realVal> FLOAT
%token  <string> STRING
%token  <string> ID

%token  <string> INTEGERDECLARE
%token  <string> STRINGDECLARE
%token  <string> BOOLEENDECLARE
%token  <string> REALDECLARE
%token  <string> CHARDECLARE
%token  <string> STRUCTDECLARE




%left OPENPARENTHESIS CLOSEPARENTHESIS OPENBRACKET CLOSEBRACKET
%right STRUCTACCESS
%left INCREMENT DECREMENT
%left NOT
%left POWER
%left MULT DIVR DIVE MOD
%left ADD SUB
%left INFERIOR SUPERIOR INFERIOREQUAL SUPERIOREQUAL
%left EQUAL NONEQUAL
%left AND OR XOR NOR
%right ASSIGN ADDASSIGN SUBASSIGN

%start programDeclaration

/* La grammaire */
%%

    programDeclaration:
        | PROGRAM ID SEMICOLON AcquireSection
        ;

    AcquireSection:
        StructSection
        | ACQUIRE ID SEMICOLON AcquireSectionLoop StructSection
        ;

    AcquireSectionLoop:
        | ACQUIRE ID SEMICOLON AcquireSectionLoop
        ;

    StructSection:
        ConstantsSection
        | DEFINE OPENHOOK StructureDeclaration SEMICOLON StructureDeclarationLoop CLOSEHOOK ConstantsSection
        ;

    StructureDeclaration:
        | VARSTRUCT ID OPENHOOK Declaration SEMICOLON DeclarationLoop CLOSEHOOK {
            if(get_id(table_symbols,$2)!=NULL){
                printf("File \"input.txt\", line %d, character %d:  Variable déjà déclarée: %s \n", yylineno, currentColumn, $2);
            YYERROR;
        }else{
            insertColumn(table_symbols,$<string>2,$2,"",1); 
        }
        }
        ;

    StructureDeclarationLoop:
        | StructureDeclaration SEMICOLON StructureDeclarationLoop
        ;

    ConstantsSection:
        VariableSection
        | CONST OPENHOOK SimpleType ID ASSIGN Value SEMICOLON ConstantsSectionLoop CLOSEHOOK VariableSection
        ;

    ConstantsSectionLoop :
        | SimpleType ID ASSIGN Value SEMICOLON ConstantsSectionLoop{
            if(get_id(table_symbols,$2)!=NULL){
                printf("File \"input.txt\", line %d, character %d: Variable déjà déclarée: %s \n", yylineno, currentColumn, $2);
        YYERROR;
    }else{
        insertColumn(table_symbols,$<string>2,$2,"",1); 
    }
        }
        ;

    DeclarationLoop:
        | Declaration SEMICOLON DeclarationLoop
        ;

    VariableSection:
        FunctionSection
        | VAR OPENHOOK SimpleDeclaration SEMICOLON VariableSectionLoop CLOSEHOOK FunctionSection
        ;

    VariableSectionLoop:
        | SimpleDeclaration SEMICOLON VariableSectionLoop
        ;

    FunctionSection:
        StartSection
        | DEF ID OPENPARENTHESIS FunctionParameters CLOSEPARENTHESIS OPENHOOK FunctionVariables Block CLOSEHOOK FunctionSectionLoop StartSection
        ;

    FunctionSectionLoop:
        | DEF ID OPENPARENTHESIS ParametersStart OUT Type ID CLOSEPARENTHESIS OPENHOOK FunctionVariables Block CLOSEHOOK FunctionSectionLoop
        ;

    FunctionParameters:
        | ParametersStart
        | ParameterEnd
        | ParametersStart COMMA ParameterEnd
        ;

    ParametersStart:
        | IN Type ID Parameter 
        ;

    ParameterEnd:
        | OUT Type ID
        ;

    Parameter:
        | COMMA Type ID Parameter
        ;

    Block:
        | Statement Block
        ;

    Statement:
          GetStatement SEMICOLON
        | DisplayStatement SEMICOLON
        | FunctionCall SEMICOLON
        | AssignementStatement SEMICOLON 
        | Loop SEMICOLON
        | Condition SEMICOLON
        ;

    FunctionCall:
         ID OPENPARENTHESIS FunctionCallArguments CLOSEPARENTHESIS
         ;

    FunctionCallArguments:
        | Arguments
        ;

    Arguments:
          Expression
        | Expression COMMA Arguments
        ;

    Expression:
          OPENPARENTHESIS Expression CLOSEPARENTHESIS {}
        | NOT Expression
        | Expression BinaryOperator Expression
        | Value
        | Variable
        ;

    DisplayStatement:
         DISPLAY OPENPARENTHESIS DisplayContent DisplayContentLoop CLOSEPARENTHESIS
         {
            strcpy( tab_quad[taille].op,"OUT");
            strcpy( tab_quad[taille].opr1,$<string>3);
            strcpy( tab_quad[taille].opr2,"");
            strcpy( tab_quad[taille].res,"");
            taille++;
        }
        ;

    DisplayContentLoop:
    | ADD DisplayContent DisplayContentLoop
    ;

    GetStatement:
        GET OPENPARENTHESIS Variable CLOSEPARENTHESIS
        {
            if(get_id(table_symbols,$<string>3)!=NULL){
            strcpy( tab_quad[taille].op,"IN");
            strcpy( tab_quad[taille].opr1,$<string>3);
            strcpy( tab_quad[taille].opr2,"");
            strcpy( tab_quad[taille].res,"");
            taille++;
            }else{
                printf("File \"input.txt\", line %d, character %d: Variable non déclarée: %s \n", yylineno, currentColumn, $<string>3);
                YYERROR;
            }
        }
        ;

    DisplayContent:
         Variable
        | STRING
        ;

    Condition:
         IF OPENPARENTHESIS Expression CLOSEPARENTHESIS OPENHOOK Block CLOSEHOOK ElseIfStatement ElseStatement
        ;

    ElseIfStatement:
        | ELSEIF OPENPARENTHESIS Expression CLOSEPARENTHESIS OPENHOOK Block CLOSEHOOK ElseIfStatement
        ;

    ElseStatement:
        | OPENHOOK Block CLOSEHOOK
        ;

    AssignementStatement:
          Variable SimpleAssignement
        | Variable ComplexAssignement
        | Incrementation
        | Variable ASSIGN Expression
        { 
            if(get_id(table_symbols,$<string>1)!=NULL){
            strcpy( tab_quad[taille].op,"=");
            strcpy(tab_quad[taille].opr1,$<string>3);
            strcpy( tab_quad[taille].opr2,"");
            strcpy( tab_quad[taille].res,$<string>1);
            taille++;
            }else{
                printf("File \"input.txt\", line %d, character %d: Variable non déclarée: %s \n", yylineno, currentColumn, $<string>1);
                YYERROR;
            }
        }
        ;


    SimpleAssignement:
         ASSIGN FunctionCall
        | Variable ComplexAssignement
        | Incrementation
        | Decrementation
        ;

    Incrementation:
        INCREMENT
        ;

    Decrementation:
        DECREMENT
        ;

    ComplexAssignement :
          ADDASSIGN Expression
        | SUBASSIGN Expression
        ;

    BinaryOperator :
          ADD
        | SUB
        | MULT
        | DIVR
        | DIVE
        | MOD
        | POWER
        | SUPERIOR
        | SUPERIOREQUAL
        | INFERIOR
        | INFERIOREQUAL
        | EQUAL
        | NONEQUAL
        | AND
        | OR
        | XOR
        | NOR
        ;

    Value:
        INTEGER { sprintf($<string>$,"%d",$<intVal>1); }
        | FLOAT { sprintf($<string>$,"%f",$<realVal>1); }
        | STRING 
        | BOOL 
        ;

    Variable:
        ID {    if(get_id(table_symbols,$<string>1)!=NULL){
    strcpy($<string>$, $<string>1); 
    }else{
                printf("File \"input.txt\", line %d, character %d: Variable non déclarée: %s \n", yylineno, currentColumn, $<string>1);
        YYERROR;
    }}
        | ID STRUCTACCESS Variable {    if(get_id(table_symbols,$<string>1)!=NULL){
    strcpy($<string>$, $<string>1); 
    }else{
                printf("File \"input.txt\", line %d, character %d: Variable non déclarée: %s \n", yylineno, currentColumn, $<string>1);
        YYERROR;
    }}
        | ID OPENBRACKET Expression CLOSEBRACKET {    if(get_id(table_symbols,$<string>1)!=NULL){
    strcpy($<string>$, $<string>1); 
    }else{
         printf("File \"input.txt\", line %d, character %d:  Variable non déclarée: %s \n", yylineno, currentColumn, $<string>1);
        YYERROR;
    }}
        ;

    Type:
        SimpleType
        | ID {    if(get_id(table_symbols,$<string>1)!=NULL){
    strcpy($<string>$, $<string>1); 
    }else{
                printf("File \"input.txt\", line %d, character %d: Variable non déclarée: %s \n", yylineno, currentColumn, $<string>1);
        YYERROR;
    }}
        ;

    SimpleType:
        INTEGERDECLARE
        | REALDECLARE
        | STRINGDECLARE
        | CHARDECLARE
        | BOOLEENDECLARE
        ;

    Declaration:
        SimpleDeclaration
        | StructureDeclaration
        ;

    SimpleDeclaration:
        SimpleType ID { 
        if(get_id(table_symbols,$2)!=NULL){
                printf("File \"input.txt\", line %d, character %d:  Variable déjà déclarée: %s \n", yylineno, currentColumn, $2);
            YYERROR;
        }else{
            insertColumn(table_symbols,$<string>2,$2,"",1); 
        }
    };
        | ID ID {
                if(get_id(table_symbols,$<string>1)!=NULL){
            strcpy($<string>$, $<string>1); 
            }else{
                printf("File \"input.txt\", line %d, character %d: Structure non déclarée: %s \n", yylineno, currentColumn, $<string>1);
                YYERROR;
            }
            if(get_id(table_symbols,$2)!=NULL){
                printf("File \"input.txt\", line %d, character %d: Variable déjà déclarée: %s \n", yylineno, currentColumn, $2);
                YYERROR;
            }else{
                insertColumn(table_symbols,$<string>2,$2,"",1); 
            }
        }
        ;

    Loop:
        ForLoop
        | WhileLoop
        ;

    ForLoop:
        LOOPFOR OPENPARENTHESIS ID EQUAL OPENBRACKET INTEGER COMMA INTEGER CLOSEBRACKET COMMA ForLoopOperations INTEGER OPENHOOK Block CLOSEHOOK
        ;

   
    ForLoopOperations:
        ADD
        | SUB
        ;
        WhileLoop:  A1 OPENHOOK Block CLOSEHOOK
        {
            strcpy( tab_quad[taille].op,"BR");
            sprintf( tab_quad[taille].opr1,"%d", sauv_fin_while+1);
            strcpy( tab_quad[taille].opr2,"");
            strcpy( tab_quad[taille].res,"");
            taille++;
            sprintf(tab_quad[sauv_fin_while].opr1,"%d",taille+1);
        };
        A1:LOOPWHILE OPENPARENTHESIS ExpressionLog CLOSEPARENTHESIS{
            sauv_fin_while=taille-1;  
        };

        ExpressionLog: 
            OPENPARENTHESIS ExpressionLog CLOSEPARENTHESIS {strcpy( $<string>$,$<string>2);} 
            | ExpressionLog AND ExpressionLog
            | ExpressionLog OR ExpressionLog
            | ExpressionLog XOR ExpressionLog
            | ExpressionLog NOR ExpressionLog
            | NOT ExpressionLog
            | ExpressionAr NONEQUAL ExpressionAr {
                strcpy( tab_quad[taille].op,"BE");
                strcpy( tab_quad[taille].opr1,"");
                strcpy( tab_quad[taille].opr2,$<string>1);
                strcpy( tab_quad[taille].res,$<string>3);
                taille++;
            }
            |ExpressionAr EQUAL ExpressionAr{
                strcpy( tab_quad[taille].op,"BNE");
                strcpy( tab_quad[taille].opr1,"");
                strcpy( tab_quad[taille].opr2,$<string>1);
                strcpy( tab_quad[taille].res,$<string>3);
                taille++;
            }
            | ExpressionAr INFERIOR ExpressionAr{
                strcpy( tab_quad[taille].op,"BGE");
                strcpy( tab_quad[taille].opr1,"");
                strcpy( tab_quad[taille].opr2,$<string>1);
                strcpy( tab_quad[taille].res,$<string>3);
                taille++;
            } | ExpressionAr INFERIOREQUAL ExpressionAr {
                strcpy( tab_quad[taille].op,"BG");
                strcpy( tab_quad[taille].opr1,"");
                strcpy( tab_quad[taille].opr2,$<string>1);
                strcpy( tab_quad[taille].res,$<string>3);
                taille++;
            } | ExpressionAr SUPERIOR ExpressionAr{
                strcpy( tab_quad[taille].op,"BLE");
                strcpy( tab_quad[taille].opr1,"");
                strcpy( tab_quad[taille].opr2,$<string>1);
                strcpy( tab_quad[taille].res,$<string>3);
                taille++;
            } | ExpressionAr SUPERIOREQUAL ExpressionAr {
                strcpy( tab_quad[taille].op,"BL");
                strcpy( tab_quad[taille].opr1,"");
                strcpy( tab_quad[taille].opr2,$<string>1);
                strcpy( tab_quad[taille].res,$<string>3);
                taille++;
            }
            | Value
            |Variable
            ;

        ExpressionAr: 
            OPENPARENTHESIS ExpressionAr CLOSEPARENTHESIS { 
                strcpy( $<string>$,$<string>2); 
            } 
            | ExpressionAr ADD ExpressionAr { 
                char res[10];
                strcpy( tab_quad[taille].op,"+");
                strcpy( tab_quad[taille].opr1,$<string>1);
                strcpy( tab_quad[taille].opr2,$<string>3);
                sprintf(res, "R%d", ri);
                strcpy( tab_quad[taille].res,res);
                taille++;
                ri++;
                strcpy( $<string>$,res);
            }
            | ExpressionAr SUB ExpressionAr {
                char res[10];
                strcpy( tab_quad[taille].op,"-");
                strcpy( tab_quad[taille].opr1,$<string>1);
                strcpy( tab_quad[taille].opr2,$<string>3);
                sprintf(res, "R%d", ri);
                strcpy( tab_quad[taille].res,res);
                taille++;
                ri++;
                strcpy( $<string>$,res);
            }
            | ExpressionAr MULT ExpressionAr {
                char res[10];
                strcpy( tab_quad[taille].op,"*");
                strcpy( tab_quad[taille].opr1,$<string>1);
                strcpy( tab_quad[taille].opr2,$<string>3);
                sprintf(res, "R%d", ri);
                strcpy( tab_quad[taille].res,res);
                taille++;
                ri++;
                strcpy( $<string>$,res);
            }
            | ExpressionAr DIVR ExpressionAr {
                char res[10];
                strcpy( tab_quad[taille].op,"DIVR");
                strcpy( tab_quad[taille].opr1,$<string>1);
                strcpy( tab_quad[taille].opr2,$<string>3);
                sprintf(res, "R%d", ri);
                strcpy( tab_quad[taille].res,res);
                taille++;
                ri++;
                strcpy( $<string>$,res);
            }
            | ExpressionAr DIVE ExpressionAr {
                char res[10];
                strcpy( tab_quad[taille].op,"DIV");
                strcpy( tab_quad[taille].opr1,$<string>1);
                strcpy( tab_quad[taille].opr2,$<string>3);
                sprintf(res, "R%d", ri);
                strcpy( tab_quad[taille].res,res);
                taille++;
                ri++;
                strcpy( $<string>$,res);
            }
            | ExpressionAr MOD ExpressionAr {
                char res[10];
                strcpy( tab_quad[taille].op,"\%");
                strcpy( tab_quad[taille].opr1,$<string>1);
                strcpy( tab_quad[taille].opr2,$<string>3);
                sprintf(res, "R%d", ri);
                strcpy( tab_quad[taille].res,res);
                taille++;
                ri++;
                strcpy( $<string>$,res);
            }
            | ExpressionAr POWER ExpressionAr {
                char res[10];
                strcpy( tab_quad[taille].op,"**");
                strcpy( tab_quad[taille].opr1,$<string>1);
                strcpy( tab_quad[taille].opr2,$<string>3);
                sprintf(res, "R%d", ri);
                strcpy( tab_quad[taille].res,res);
                taille++;
                ri++;
                strcpy( $<string>$,res);
                }
            | Value
            | Variable
            ;
    StartSection:
         START OPENHOOK Block CLOSEHOOK
        ;

    FunctionVariables :
        | VAR OPENHOOK SimpleDeclaration SEMICOLON FunctionVariablesLoop CLOSEHOOK
        ;

    FunctionVariablesLoop :
        | SimpleDeclaration SEMICOLON FunctionVariablesLoop
        ;

%%

int main(int argc, char **argv) {
    table_symbols = insertRow(&table_symbols ,1);
    yyin = fopen(argv[1], "r");
    yyout = fopen("output.txt", "w");
    taille=0;
    int value = yyparse();
    int i =0;

if (showLexicalErrorr == 1) {
        fclose(yyin);
        fclose(yyout);
        return EXIT_FAILURE;
    }

    
    for(i=0 ; i<taille ; i++){
        fprintf(yyout,"%d-(%s,%s,%s,%s)\n",i+1,tab_quad[i].op,tab_quad[i].opr1,tab_quad[i].opr2,tab_quad[i].res);
    }

    if(value==1){
        printf("File \"input.txt\", line %d, character %d: syntax error\n", yylineno, currentColumn);
    }else{
        printf("\nCompiled Successfully!\n");
    }
    fclose(yyin);
    fclose(yyout);
    return 0;
}
