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

#include "../include/calc.h"

%}

%s SKIPERROR

digit     [0-9]+
dot       \.
number    ({digit}|{digit}{dot}{digit})

%%

{number}	                                            {
        _double_value=atof(yytext);
        if(_inside_of_set)
        {
            _current_set.insert(_double_value);
            std::cout << "Add elem into set:" << _double_value << " size:" << _current_set.size() << std::endl;
            _last_number_of_set = true;
        }
        else
        {
            fprintf(stderr, "found %f\n", _double_value);
            return LexNumber; 
        }                              
                                                        }
\+		                                                {
		fprintf(stderr, "plus\n");
        return LexPlus;                                 
                                                        }
\-		                                                {
		fprintf(stderr, "minus\n");
        return LexMinus;                                
                                                        }
\/		                                                {
		fprintf(stderr, "div\n");
        return LexDiv;                                  
                                                        }
\*		                                                {
		fprintf(stderr, "mult\n");
        return LexMult;                                 }

\?		                                                {
        fprintf(stderr, "isSetInclude\n");
        return LexIsSetInclude;                         }

\[                                                      {
        if (_inside_of_set) 
        {
            return LexErrorSet;
        } 
        else 
        {
            std::cout << "FOUND SET" << std::endl;
            _inside_of_set = true;
            _last_number_of_set = false;
        }                                 
                                                        }
,                                                       {
        if (!_inside_of_set || !_last_number_of_set) 
        {
            return LexErrorSet;
        } 
        else 
        {
            _last_number_of_set = false;
        }
                                                        }
,\]                                                     {
        return LexErrorSet;
                                                        }
\]                                                      {
        if (!_inside_of_set || !_last_number_of_set) 
        {
            return LexErrorSet;
        } 
        else {
            std::cout << "END SET" << std::endl;

            _last_number_of_set = false;
            _inside_of_set = false;
            _stack_sets.push(_current_set);
            _current_set.clear();
            return LexSet;
        }      
                                                        }
^[ \t]*\n	                                            {
		fprintf(stderr, "empty line\n");
		                                                }
\n		                                                {
		fprintf(stderr, "CR\n");
        return LexEnd;                                  
                                                        }
[ \t]		                                            {
        //do nothing
                                                        }
.		                                                {
        return LexUnknown; 
                                                        }

<SKIPERROR>[^\n]* {}
%%


int process_command(int token)
{
    fprintf(stderr, "token: %d\n", token);

    switch (token) {
    case LexNumber:
        _stack.push(_double_value);
        _guidance_for_interp.push(DOUBLE);
        break;
    case LexSet:{
        if(_stack_sets.size()>0){
            _guidance_for_interp.push(MSET);
        }
        break;}
    case LexPlus: {
        if (_guidance_for_interp.empty()) return -1;
        auto right_operand = _guidance_for_interp.top();
        _guidance_for_interp.pop();

        if (_guidance_for_interp.empty()) return -1;
        auto left_operand = _guidance_for_interp.top();
        _guidance_for_interp.pop();

        auto tuple_of_operands = right_operand * left_operand;
        switch(tuple_of_operands) {
            case (DOUBLE * DOUBLE):{
                if(_stack.empty()) return -1;
                auto a = _stack.top();
                _stack.pop();

                if(_stack.empty()) return -1;
                auto b = _stack.top();
                _stack.pop();

                _stack.push(a+b);
                _guidance_for_interp.push(DOUBLE);
                break;
            };
            case (MSET * MSET):{
                if(_stack_sets.empty()) return -1;
                auto a_set = _stack_sets.top();
                _stack_sets.pop();

                printSet(a_set);

                if(_stack_sets.empty()) return -1;
                auto b_set = _stack_sets.top();
                _stack_sets.pop();

                printSet(b_set);

                auto union_ab = union_of_sets(a_set, b_set);
                printSet(union_ab);
                _stack_sets.push(union_ab);
                _guidance_for_interp.push(MSET);
                break;
            }
        }
        break;}
    case LexMinus: {
        if(_guidance_for_interp.top()!=DOUBLE || _guidance_for_interp.empty()) return -1;
        if(_stack.empty()) return -1;
        double a=_stack.top();
        _stack.pop();
        _guidance_for_interp.pop();

        if(_guidance_for_interp.top()!=DOUBLE || _guidance_for_interp.empty()) return -1;
        if(_stack.empty()) return -1;
        double b=_stack.top();
        _stack.pop();
        _guidance_for_interp.pop();

        _stack.push(b-a);
        _guidance_for_interp.push(DOUBLE);
        break;}
    case LexDiv: {
        if(_guidance_for_interp.top()!=DOUBLE || _guidance_for_interp.empty()) return -1;
        if(_stack.empty()) return -1;
        double a=_stack.top();
        _stack.pop();
        _guidance_for_interp.pop();

        if(_guidance_for_interp.top()!=DOUBLE || _guidance_for_interp.empty()) return -1;
        if(_stack.empty()) return -1;
        double b=_stack.top();
        _stack.pop();
        _guidance_for_interp.pop();

        _stack.push(b/a);
        _guidance_for_interp.push(DOUBLE);
        break;}
    case LexMult: {
        if (_guidance_for_interp.empty()) return -1;
        auto right_operand = _guidance_for_interp.top();
        _guidance_for_interp.pop();

        if (_guidance_for_interp.empty()) return -1;
        auto left_operand = _guidance_for_interp.top();
        _guidance_for_interp.pop();

        auto tuple_of_operands = right_operand * left_operand;
        switch(tuple_of_operands) {
            case (DOUBLE * DOUBLE):{
                if(_stack.empty()) return -1;
                auto a = _stack.top();
                _stack.pop();

                if(_stack.empty()) return -1;
                auto b = _stack.top();
                _stack.pop();

                _stack.push(a*b);
                _guidance_for_interp.push(DOUBLE);
                break;
            };
            case (MSET * MSET):{
                if(_stack_sets.empty()) return -1;
                auto a_set = _stack_sets.top();
                _stack_sets.pop();

                if(_stack_sets.empty()) return -1;
                auto b_set = _stack_sets.top();
                _stack_sets.pop();

                auto is_ab = intersection_of_sets(a_set, b_set);
                _stack_sets.push(is_ab);
                _guidance_for_interp.push(MSET);
                break;
            }
        }
        break;}
    case LexIsSetInclude:{
        if(_guidance_for_interp.top()!=DOUBLE || _guidance_for_interp.empty()) return -1;
        if(_stack.empty()) return -1;
        double a_num=_stack.top();
        _stack.pop();
        _guidance_for_interp.pop();

        if(_guidance_for_interp.top()!=MSET || _guidance_for_interp.empty()) return -1;
        if(_stack_sets.empty()) return -1;
        auto b_set=_stack_sets.top();
        _stack_sets.pop();
        _guidance_for_interp.pop();

        auto isBelongNumber = checkBelongNumberToSet(b_set, a_num);
        _stack.push(isBelongNumber);
        _guidance_for_interp.push(DOUBLE);
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

    if(_guidance_for_interp.empty()){
        std::cout << "Nothing interp" << std:: endl;
        return 0;
    }

    if (_stack.empty() && _stack_sets.empty()) {
        std::cout << "Both stacks are empty but a value is required!" << std::endl;
        return 0;
    }

    auto what_doing = _guidance_for_interp.top();
    _guidance_for_interp.pop();

    switch (what_doing) {
        case DOUBLE:{
            if (!_stack.empty()) {
                double result1 = _stack.top();
                _stack.pop();
                std::cout << "RES:" << result1 << std::endl;
            } 
            break;
        }
        case MSET:{
            if (!_stack_sets.empty()) 
            {
                auto result = _stack_sets.top();
                _stack_sets.pop();
                std::cout << "RES:";
                printSet(result);
            }
            break;
        }
    }

    if (!_stack.empty() || !_stack_sets.empty())
    {
        fprintf(stderr, "Stacks are not empty after calculation!\n");
        return 0;
    }

    return 1;
}

void run_conveyor()
{
    while (!_end_file)
    {
        fprintf(stderr, "\033[32m%s\033[0m\n", "{");
        if (calc_line() == 0)
        {
            printf("\033[31m%s\033[0m\n", "FAIL");
            BEGIN(SKIPERROR);
            yylex();
            BEGIN(INITIAL);
        }
        else
        {
            printf("\033[32m%s\033[0m\n", "OK");
        }
        fprintf(stderr, "\033[32m%s\033[0m\n", "}");
    }
}

int main(void)
{
    _end_file = 0;

    run_conveyor();

    return 0;
}

int yywrap(void)
{
    _end_file = 1;
    return 1;
}
