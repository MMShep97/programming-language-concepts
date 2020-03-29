#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>

//reverse content of file and be savved into the file path
int main (int argc, char *argv[], char *env[]) {

    struct stat stat_buffer;
    char *file_path = argv[1];

    int file_descriptor = open(file_path, O_RDWR);
    // obtain info about the open file --> writes it to area pointed to by the buffer
    fstat(file_descriptor, &stat_buffer);
    off_t file_size = stat_buffer.st_size;

    // map file into mem
    unsigned char *peon = mmap(0, file_size, PROT_WRITE|PROT_READ, MAP_SHARED, file_descriptor, 0);

    // skkkkr errror
    if( (long)peon == -1){
        printf("mmap error\n");
        exit(1);
    }

    int count = (int) file_size;
    int length = count / 2;

    for ( int i = 0; i < length; i++) {
        char c = *(i + peon);
        *(i + peon) = *(count + peon - 1);
        *(count + peon - 1) = c;
        count--;
    }

    // flush changes made to copy of file mapped by mmap
    msync(peon, file_size, MS_SYNC); // MS_SYNC --> requests update and waits for completion
    // close file based on descriptor
    close(file_descriptor);
    // unmap
    munmap(peon, file_size);

    return 0;
}