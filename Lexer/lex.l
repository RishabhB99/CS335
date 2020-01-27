%{ 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct node{
	char lexeme[64000];
	char token[100];
	int count;
	struct node* next;
};

struct node* head;
int line = 1;
int FLAG = 0;
void insert(char* arr,char* arr1);
void enter(char* arr);
%} 

com [^*]|"*"[^/]
Digits [0-9]|[0-9][0-9_]*[0-9]
Hex [0-9a-fA-F]|[0-9a-fA-F][0-9a-fA-F_]*[0-9a-fA-F]

%%
abstract|continue|for|new|switch {insert(yytext,"Keyword");}
assert|default|if|package|synchronized {insert(yytext,"Keyword");}
boolean|do|goto|private|this {insert(yytext,"Keyword");}
break|double|implements|protected|throw {insert(yytext,"Keyword");}
byte|else|import|public|throws {insert(yytext,"Keyword");}
case|enum|instanceof|return|transient {insert(yytext,"Keyword");}
catch|extends|int|short|try {insert(yytext,"Keyword");}           
char|final|interface|static|void {insert(yytext,"Keyword");} 
class|finally|long|strictfp|volatile {insert(yytext,"Keyword");}
const|float|native|super|while	{insert(yytext,"Keyword");}
 
"["|"]"|"{"|"}"|"("|")"|";"|","|"."|"..."|"@"|"::" {insert(yytext,"Seperator");}

"="|">"|"<"|"!"|"~"|"?"|":"|"->"|">>>" {insert(yytext,"Operator");}
"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--" {insert(yytext,"Operator");}
"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>=" {insert(yytext,"Operator");}
"+="|"-="|"*="|"/="|"&="|"|="|"^="|"%="|"<<="|">>=" {insert(yytext,"Operator");}

0[0-9_]*[8-9][0-9_]*       {printf("Error:Line No.:%d: %s is an invalid number\n",line,yytext);FLAG=1;}  					
{Digits}|true|false|null|0(b|B)[0-1]|0(b|B)[0-1][0-1_]*[0-1]  {insert(yytext,"Literal");}
0(x|X){Hex} {insert(yytext,"Literal");}

[0-9]*"."{Digits}|{Digits}"."[0-9]*|[0-9]*"."{Digits}[eE][-+]?{Digits} {insert(yytext,"Literal");}
{Digits}"."[0-9]*[eE][-+]?{Digits}|[0-9]*"."{Digits}[eE][-+]?{Digits}[fdFD]  {insert(yytext,"Literal");}
{Digits}"."[0-9]*[eE][-+]?{Digits}[fdFD]|{Digits}[eE][-+]?{Digits}[fdFD]  {insert(yytext,"Literal");}
{Digits}[eE][-+]?{Digits}|{Digits}[fdFD]                                       {insert(yytext,"Literal");}
0(x|X){Hex}"."{Hex}[pP][-+]?{Digits}|0(x|X){Hex}"."{Hex}[pP][-+]?{Digits}[fdFD] {insert(yytext,"Literal");}

[a-zA-Z][a-zA-Z0-9_]* {insert(yytext,"Identifier");}

"\""([^\\\"\']|\\\"|\\\'|\\\\|\\b|\\t|\\n|\\r|\\f|\\[0-7]|\\[0-7]|\\[0-7][0-7]|\\[0-3][0-7][0-7])*"\""  {insert(yytext,"Literal");}

"\'"([^\\\"\']|\\\"|\\\'|\\\\|\\b|\\t|\\n|\\r|\\f|\\[0-7]|\\[0-7]|\\[0-7][0-7]|\\[0-3][0-7][0-7])"\'"  {insert(yytext,"Literal");}


"/""*"+{com}*+"*""/"    {enter(yytext);}



"/""/"[^\n]*    ;

[ \t] ;
\n line++;
. {printf("Error:Line No.:%d: %s is an illegal character\n",line,yytext);FLAG = 1;}
%% 

void enter(char* arr){
	while(*arr!=0){
		if(*arr=='\n')
			line++;
		arr+=1;
	}
}
void insert(char* arr,char* arr1){
	if(head==NULL)
	{
		head = (struct node*)malloc(sizeof(struct node));
		strcpy(head->lexeme,arr);
		strcpy(head->token,arr1);
		head->count = 1;
		return;
	}
	struct node* p = head;
	struct node* q = head;
	
	while(p!=NULL)
	{
		if(strcmp(p->lexeme,arr)==0){
			p->count++;
			return;
		}
		p = p->next;
	}

	while(q->next!=NULL)
		q = q->next;
	q->next = (struct node*)malloc(sizeof(struct node));
	strcpy(q->next->lexeme,arr);
	strcpy(q->next->token,arr1);
	q->next->count = 1;
} 
int yywrap(){
	return 1;
} 
int main(int argc, char *argv[]){ 
  
	yyin = fopen(argv[1], "r");
	yylex();
 	if(FLAG)
	return 0;
	printf("%s,%s,%s\n","Lexeme","Token","Count");
	while(head!=NULL)
	{
		printf("%s,%s,%d\n",head->lexeme,head->token,head->count);
		head = head->next;
	}
	fclose(yyin);
	return 0; 
} 
