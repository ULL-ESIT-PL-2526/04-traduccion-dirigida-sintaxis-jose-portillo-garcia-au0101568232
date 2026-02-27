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
"**"                  { return 'OP';           }
[-+*/]                { return 'OP';           }
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
    : expression OP term
        { $$ = operate($OP, $expression, $term); }
    | term
        { $$ = $term; }
    ;

term
    : NUMBER
        { $$ = Number(yytext); }
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
