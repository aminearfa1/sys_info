#include "util.h"


void save_all_lines(char *tab[], int size){
    FILE *fp = NULL;
    fp = fopen ("input.txt","w");
    for(int i=0; i<size;i++){
        fputs(tab[i], fp);
        fputc('\n', fp);
    }
    fclose(fp);
}

void setUpArrayInstr(char *arrayInstr[],  int maxSize, int offset){
    arrayInstr[offset] = malloc(sizeof(char) * maxSize);
}

void printArray(char *array[], int size){
	for(int i=0; i<size; i++){
		printf("0x%d : %s\n", i, array[i]);
	}
}

void storeJMF(char *array[], int *offset, int addrRes,int maxSize){
	if(array[*offset] == NULL){
		setUpArrayInstr(array, maxSize, *offset);
	}

	sprintf(array[*offset],"JMF %d ?", addrRes);
	(*offset)++;
}

void storeJMP(char *array[], int *offset, int maxSize){
	if(array[*offset] == NULL){
		setUpArrayInstr(array, maxSize, *offset);
	}
	strncpy(array[*offset],"JMP ?", 6);
	(*offset)++;
}

void patchLine(char *array[], int offset, int jump, char toReplace){
	char *c =  strchr(array[offset], toReplace);
	if(c != NULL){
		sprintf(c,"%d",jump);
	}
}
