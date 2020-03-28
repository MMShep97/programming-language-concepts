#include <string.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <stdio.h>

typedef unsigned char byte;

int main (int argc, char *argv[], char *env[]) {
    int accolation_size = 500000;
    
    
    char assembly_code[accolation_size];
    strcpy(assembly_code,argv[1]);
    unsigned char assembly_deconstructed[accolation_size];
    unsigned char lil_boyo;
    char temp[2];
    int count = 0;
    
    int length = (int) strlen(assembly_code);

    for (int i = 0; i < length; i = i + 2) {
        temp[0] = assembly_code[i];
        temp[1] = assembly_code[i + 1];
        // suggested (sscanf)
        sscanf(temp, "%02hhx", &lil_boyo);
        assembly_deconstructed[count] = lil_boyo;
        count++;
    }

    //Git that memory and copy over to the addrrrr
    
    byte* peon = (byte*) mmap( (void*)0x1000000, accolation_size, PROT_WRITE|PROT_READ|PROT_EXEC, MAP_ANONYMOUS|MAP_PRIVATE|MAP_FIXED, -1, 0);

    size_t size_t_size = sizeof(assembly_deconstructed);

    memcpy(peon, assembly_deconstructed, size_t_size);

    ( (void (*) (void)) 0x1000000)();

    munmap(peon, accolation_size);

    return 0;
}