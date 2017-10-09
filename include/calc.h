#include <stack>
#include <set>
#include <iostream>
#include <functional>
#include <sstream>
#include <iomanip>
#include <string>


#define GET_ELEMENT_FROM(stack, elem)	\ 
    if(stack.empty()) return -1; 		 \
    elem = stack.top();           		  \
    stack.pop();

#define GET_ELEMENT_FROM_STACK_WITH_CHECK(stack_num, guidance_stack, elem, typeStack) \
	if(guidance_stack.top()!=typeStack || guidance_stack.empty()) return -1;	       \
	GET_ELEMENT_FROM(stack_num,elem)										            \
    guidance_stack.pop();

typedef std::multiset<double> MULTISET;

typedef enum {
    DOUBLE,
    MSET
} TypeOfStack;

std::stack<double> _stack_numbers;
std::stack<MULTISET> _stack_sets;
MULTISET _current_set;
std::stack<TypeOfStack> _guidance_for_interp;

double _double_value;
bool _inside_of_set = false;
bool _last_number_of_set = false;
int _end_file;

typedef enum {
    LexNumber=1001,
    LexPlus,
    LexMinus,
    LexDiv,
    LexMult,
    LexSet,
    LexIsSetInclude,
    LexEnd,
    LexUnknown,
    LexErrorSet
} LexType;

MULTISET& union_of_sets(MULTISET& a_set, MULTISET& b_set)
{
    MULTISET& res_set = *(new MULTISET);
    for(auto a:a_set){
        res_set.insert(a);
    }
    for(auto b:b_set){
        res_set.insert(b);
    }
    return res_set;
} 

MULTISET& intersection_of_sets(MULTISET& a_set, MULTISET& b_set)
{
    std::set<double> temp_set;

    for(auto a:a_set){
        if((*b_set.find(a))==a){
            temp_set.insert(a);
        }
    }
    MULTISET& res_set = *(new MULTISET);
    for(auto t:temp_set){
        res_set.insert(t);
    }
    return res_set;
} 

double checkBelongNumberToSet(MULTISET& b_set, double a_num)
{
    return (*b_set.find(a_num))==a_num ? 1.0 : 0.0;
}

std::string toStr(double d){
    std::ostringstream ost;
    // ost << std::fixed << std::setprecision(3) << d;
    ost << d;
    return ost.str();
}

void printSet(MULTISET& a_set)
{
    std::cerr << "set(";
    std::string elements;
    if(!a_set.empty())
    {
        for(auto a:a_set){
            elements += toStr(a) + ",";
        }
    }
    else
    {
        std::cerr << "empty";
    }
    elements.pop_back();
    std::cerr << elements << ")" << std::endl;
}
