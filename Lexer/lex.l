%{ 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct node{
	char lexeme[1000];
	char token[100];
	int count;
	struct node* next;
};

struct node* head;

void insert(char* arr,char* arr1);

%} 
  
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

[1-9][0-9]*|true|false|0|null  {insert(yytext,"Literal");}

[a-zA-Z]* {insert(yytext,"Identifier");}


[ \t\n] ;
. ;
%% 


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
	printf("-------------------------------------\n");
	printf("%s\t\t%s\t\t%s\n","Lexeme","Token","Count");
	printf("-------------------------------------\n");
	while(head!=NULL)
	{
		if(!strcmp(head->token,"Keyword")||!strcmp(head->token,"Literal"))
			printf("%s\t\t%s\t\t%d\n",head->lexeme,head->token,head->count);
		else	
			printf("%s\t\t%s\t%d\n",head->lexeme,head->token,head->count);
		head = head->next;
	}
	fclose(yyin);
	return 0; 
} 
