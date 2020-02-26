#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int main(int argc, char *argv[], char* env[]) {

    for (int i = 0; i < argc; i++) {
        printf("%s\n", argv[i]);  
    }

   for (int i = 0; env[i] != NULL; i++)
    {    
        printf("%s\n", env[i]);
    }


    return 0;
}