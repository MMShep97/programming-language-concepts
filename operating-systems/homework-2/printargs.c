#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int main(int argc, char *argv[], char* env[]) {

    for (int i = 0; i < argc; i++) {
        printf("%s\n", argv[i]); 
        printf("I am in printargs\n");
    }
    return 0;
}