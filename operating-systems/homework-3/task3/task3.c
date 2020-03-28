#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>

//reverse content of file and be savved into the file path

typedef unsigned char byte;

int main (int argc, char *argv[], char *env[]) {

    struct stat skrrt;
    char *file_path = argv[1];

    int file_descriptor = open(file_path, O_RDWR);
    fstat(file_descriptor, &skrrt);
    off_t file_size = skrrt.st_size;

    // map file into mem
    byte *peon = mmap(0, file_size, PROT_WRITE|PROT_READ, MAP_SHARED, file_descriptor, 0);

    // skkkkr errror
    if( (long)peon == -1){
        printf("mmap error\n");
        exit(1);
    }

    int count = (int) file_size;
    int length = count / 2;

    for ( int i = 0; i < length; i++) {
        char c = *(peon + i);
        *(peon + i) = *(peon + count - 1);
        *(peon + count - 1) = c;
        count--;
    }

    msync(peon, file_size, MS_SYNC);
    close(file_descriptor);
    // unmap
    munmap(peon, file_size);

    return 0;
}