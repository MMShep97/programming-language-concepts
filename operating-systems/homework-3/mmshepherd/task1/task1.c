#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

// disable memory randomization with setarch 
// read the content of the file/proc/self/maps

int main (int argc, char *argv[], char *env[]) {
    unsigned long int * required_address;
    char * endptr;
    unsigned char * dos;

    // suggested: strtol (converts str to long int, which we bind below)
    required_address = (unsigned long int *) strtol(argv[1], &endptr, 16);
    dos = (unsigned char *) required_address;

    // Reading in files
    char * lo_bound;
    char * up_bound;
    char * temp = NULL;
    bool outcome = false;
    FILE *f;

    f = fopen("/proc/self/maps", "r");

    size_t length = 0;
    int input;

    //while everything is crisp and clean
    while ((input = getline(&temp, &length, f)) != -1) {
        
        //strtok --> breaks str into tokens w/ respective delimiter
        lo_bound = strtok(temp, "-");
        up_bound = strtok(NULL, " ");

        // strtol again -->  string to long int
        unsigned long int * low = (unsigned long int*) strtol(lo_bound, &endptr, 16);
        unsigned long int * high = (unsigned long int*) strtol(up_bound, &endptr, 16);

        if (required_address >= low && required_address < high) {
            outcome = true;
        }

    }
    
    fclose(f);

    if (outcome) {
        // two digit lowercase hex
        printf("%02x\n", *dos);
        //no problems
        exit(0);
    }
    else {
        //garbage
        exit(1);
    }
}