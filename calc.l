%{
/*
This file is part of Reverse Notation Calc.

    Reverse Notation Calc is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Foobar is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

*/

#include <vector>
int int_value;

typedef enum {
    LexNumber=1001,
    LexPlus,
    LexMinus,
    LexDiv,
    LexMult,
    LexEnd,
    LexUnknown,
} LexType;

std::vector<int> _stack;

int _end_file;

%}

%s SKIPERROR

digit     [0-9]
number    {digit}+

%%

{number}	{
		  int_value=atoi(yytext);
		  fprintf(stderr, "found %d\n", int_value);
		  return LexNumber; }
\+		{
		  fprintf(stderr, "plus\n");
		  return LexPlus; }
\-		{
		  fprintf(stderr, "minus\n");
		  return LexMinus; }
\/		{
		  fprintf(stderr, "div\n");
		  return LexDiv; }
\*		{
		  fprintf(stderr, "mult\n");
		  return LexMult; }
^[ \t]*\n	{
		  fprintf(stderr, "empty line\n");
		}
\n		{
		  fprintf(stderr, "CR\n");
		  return LexEnd; }
[ \t]		{ }
.		{ return LexUnknown; }

<SKIPERROR>[^\n]* {}
%%

int get_back(){
    int result = _stack.back();
    _stack.pop_back();
    return result;
}

int process_command(int token)
{
    fprintf(stderr, "token: %d\n", token);

    switch (token) {
    case LexNumber:
        _stack.push_back(int_value);
        break;
    case LexPlus: {
        if (_stack.empty()) {
            return -1;
        }
        int a=get_back();

        if (_stack.empty()) {
            return -1;
        }
        int b=get_back();

        _stack.push_back(b+a);
        break;}
    case LexMinus: {
        if (_stack.empty()) {
            return -1;
        }
        int a=get_back();

        if (_stack.empty()) {
            return -1;
        }
        int b=get_back();

        _stack.push_back(b-a);
        break;}
    case LexDiv: {
        if (_stack.empty()) {
            return -1;
        }
        int a=get_back();

        if (_stack.empty()) {
            return -1;
        }
        int b=get_back();

        _stack.push_back(b/a);
        break;}
    case LexMult: {
        if (_stack.empty()) {
            return -1;
        }
        int a=get_back();

        if (_stack.empty()) {
            return -1;
        }
        int b=get_back();

        _stack.push_back(b*a);

        break;}
    case LexEnd:
    case 0:
        return 0;
    case LexUnknown:
        return -1;

    }
    return 1;
}

int calc_line()
{
    int token = yylex();
    if (token == 0)
    {
        return 1;
    }

    while (1)
    {
        int cmd_res = process_command(token);
        if (cmd_res == 0)
        {
            break;
        }
        else if (cmd_res == -1)
        {
            fprintf(stderr, "Syntax error\n");
            return 0;
        }
        token = yylex();
    }

    if (_stack.empty())
    {
        fprintf(stderr, "Stack is empty but required value\n");
        return 0;
    }

    int result = get_back();
    fprintf(yyout, "%d ", result);

    if (!_stack.empty())
    {
        fprintf(stderr, "Stack not empty after calculation\n");
        return 0;
    }

    return 1;
}

void calc()
{
    while (!_end_file)
    {
        fprintf(stderr, "parse line\n");
        if (calc_line() == 0)
        {
            printf("FAIL\n");
            BEGIN(SKIPERROR);
            yylex();
            BEGIN(INITIAL);
        }
        else
        {
            printf("OK\n");
        }
        fprintf(stderr, "line parsed\n");
    }
}

int main(void)
{
    _end_file = 0;

    calc();

    _stack.clear();
    return 0;
}

int yywrap(void)
{
    _end_file = 1;
    return 1;
}
