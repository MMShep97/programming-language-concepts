#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/wait.h>

// argv[1] = input file
// argv[2] = # of children

int main(int argc, char *argv[], char* env[]) {

    char *p;
    char * file_path = argv[1];
    long num_children = strtol(argv[2], &p, 10);
    

    for(int i=0;i<num_children;i++) // loop will run n times 
    { 
        if(fork() == 0) 
        { 
            printf("[son] pid %d from [parent] pid %d\n",getpid(),getppid()); 
            exit(0); 
        } 
    } 
    for(int i=0;i<num_children;i++) {// loop will run n times 
        wait(NULL); 
    }

    return 0;
}