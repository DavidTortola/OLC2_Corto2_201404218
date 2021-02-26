/* description: Parses and executes mathematical expressions. */

%{
    var contador = 0;
    function new_temp (){
        var temp = contador;
        contador = contador + 1;
        return "T" + String(temp);
    }
%}

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
[A-Za-z][A-Za-z0-9]*  return 'IDENTIFIER'
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"("                   return '('
")"                   return ')'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/'
%left UMINUS

%start expressions

%% /* language grammar */

expressions
    : S EOF
        { typeof console !== 'undefined' ? console.log($1.c3d) : print($1);
          return $1; }
    ;

S   
    : E
        { $$ = $1; }
    ;

E   
    : E '+' T
        {{
            $$ = { 
                    tmp : String(new_temp()),
                    c3d : ""
                  } 
            $$.c3d = $1.c3d + $3.c3d + "\n" + $$.tmp + "=" + $1.tmp + "+" + $3.tmp
        }}
    | E '-' T
        {{
            $$ = { 
                    tmp : String(new_temp()),
                    c3d : ""
                  } 
            $$.c3d = $1.c3d + $3.c3d + "\n" + $$.tmp + "=" + $1.tmp + "-" + $3.tmp
        }}
    | T
        { $$ = { tmp : $1.tmp, c3d : $1.c3d } }
    ;

T   
    : T '*' F
        {{
            $$ = { 
                    tmp : String(new_temp()),
                    c3d : ""
                  } 
            $$.c3d = $1.c3d + $3.c3d + "\n" + $$.tmp + "=" + $1.tmp + "*" + $3.tmp
        }}
    | T '/' F
        {{
            $$ = { 
                    tmp : String(new_temp()),
                    c3d : ""
                  } 
            $$.c3d = $1.c3d + $3.c3d + "\n" + $$.tmp + "=" + $1.tmp + "/" + $3.tmp
        }}
    | F
        { $$ = { tmp : $1.tmp, c3d : $1.c3d } }
    ;

F
    : '(' E ')'
        { $$ = { tmp : $2.tmp, c3d : $2.c3d } }
    | IDENTIFIER
        { $$ = { tmp : yytext, c3d : "" } }
    | NUMBER
        { $$ = { tmp : yytext, c3d : "" } }
    ;