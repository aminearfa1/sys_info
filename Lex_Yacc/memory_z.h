#ifndef MEMORY_Z_H_
#define MEMORY_Z_H_

#define MZ_MAX 600

typedef struct headMZ {
    int indexInt;
    int indexDouble;
    int addrInt[MZ_MAX];
    int addrDouble[MZ_MAX];
} headMZ;

headMZ * initMem(int indexInt, int indexDouble);
int getFreeAddress(headMZ * head, int type);
int getFreeAddressFromArray(int array[]);
void freeAddress(headMZ *head, int addr, int type);

#endif