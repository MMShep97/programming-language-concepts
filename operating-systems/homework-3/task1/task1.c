#include <string.h>
#include <stdlib.h>
#include <stdio.h>

// disable memory randomization with setarch 
// read the content of the file/proc/self/maps

int main (int argc, char *argv[], char *env[]) {
    unsigned long * required_address;
    char * pEnd;
    unsigned char * dos;

    // suggested: strtol
    required_address = (unsigned long *) strtol(argv[1], &pEnd, 16);
    dos = (unsigned char *) required_address;

    // Reading in files
    char * lo_bound;
    char * up_bound;
    char * temp = NULL;
    int bool_boyo = 0;
    FILE *f;

    f = fopen("/proc/self/maps", "r");

    size_t length = 0;
    int input;
    while ((input = getline(&temp, &length, f)) != -1) {
        
        lo_bound = strtok(temp, "-");
        up_bound = strtok(NULL, " ");

        unsigned long * low = (unsigned long *) strtol(lo_bound, &pEnd, 16);
        unsigned long * high = (unsigned long *) strtol(up_bound, &pEnd, 16);

        if (required_address >= low && required_address < high) {
            bool_boyo = 1;
        }

    }
    
    fclose(f);

    if (bool_boyo) {
        // two digit lowercase hex
        printf("%02x\n", *dos);
        exit(0);
    }
    else {
        exit(1);
    }
}