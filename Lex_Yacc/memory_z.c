#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "memory_z.h"

headMZ * initMem(int indexInt, int indexDouble){
     headMZ * head = malloc(sizeof(headMZ));
     head->indexInt = indexInt;
     head->indexDouble = indexDouble;
    //  head->addrInt = new int[MZ_MAX];
    //  head->addrDouble = new int[MZ_MAX];

    for(int i=0; i<MZ_MAX;i++){
        head->addrInt[i] = 1;
        head->addrDouble[i] = 1;
    }

     return head;
 }

int getFreeAddress(headMZ *head, int type){
    int general_pointer = 0;
    if(type == 1){
        int freeAddr = getFreeAddressFromArray(head->addrInt);
        head->addrInt[freeAddr] = 0;
        return freeAddr + head->indexInt;
    }else if (type == 2){
         int freeAddr = getFreeAddressFromArray(head->addrDouble);
         head->addrDouble[freeAddr] = 0;
         return freeAddr + head->indexDouble;
    }
    else {
        printf("[error] No type found\n");
        exit(1);
    }
}

int getFreeAddressFromArray(int array[]){
    for(int i=0; i<MZ_MAX;i++){
        if(array[i]){
            return i;
        }
    }
    return -1;
}

void freeAddress(headMZ *head, int addr, int type){
    if(type == 1){
        head->addrInt[addr] = 1;
    }else if(type == 2){
        head->addrDouble[addr] = 1;
    }else{
        printf("[error] No type found\n");
        exit(1);
    }
}