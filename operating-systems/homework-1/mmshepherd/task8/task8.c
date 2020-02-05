#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
	for(int i = 0; i < argc; i++) {
		char *sstring = argv[i];
		int len = strlen(sstring);
		char buffer[10000] = "";
		char *ptr = buffer;
		
		for(int j = 0; j < len; j++){
			sprintf(ptr, "%x", sstring[j]);
			ptr = ptr + 2;
		}
		printf("%s\n", buffer);	
	}
	return 0;
}
