/* Lexer */
%lex
integer        [0-9]+
mantisa        ([.][0-9]+)
exponencial    ([eE][-+]?[0-9]+)
float          {integer}{mantisa}?{exponencial}?

%%   
\s+                   { /* skip whitespace */; }
\/\/.*                { /* skip one line comments*/}
{float}               { return 'NUMBER'        }
"**"                  { return 'OPOW';         }
[-+]                  { return 'OPAD';         }
[*/]                  { return 'OPMU';         }
"("                   { return '(';            }
")"                   { return ')';            }
<<EOF>>               { return 'EOF';          }
.                     { return 'INVALID';      }
/lex

/* Parser */
%start expressions
%token NUMBER
%%

expressions
    : expression EOF
        { return $expression; }
    ;

expression
    : expression OPAD term
        { $$ = operate($OPAD, $expression, $term); }
    | term
        { $$ = $term; }
    ;

term
    : term OPMU power
        { $$ =  operate($OPMU, $term, $power); }

    | power
        { $$ = $power; }
    ;

power
    : factor OPOW power
        { $$ = operate($OPOW, $factor, $power); }
    | factor
        { $$ = $factor}
    ;

factor
    : NUMBER
        { $$ = Number(yytext);}
    | '(' expression ')'
        { $$ = $expression}
    ;

%%

function operate(op, left, right) {
    switch (op) {
        case '+': return left + right;
        case '-': return left - right;
        case '*': return left * right;
        case '/': return left / right;
        case '**': return Math.pow(left, right);
    }
}
