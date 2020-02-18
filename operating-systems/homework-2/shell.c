#define _GNU_SOURCE //this is needed to be able to use execvpe 
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <fcntl.h>


typedef struct {
  char* binary_path;
  char* stdin;
  char* stdout;
  char* stderr;
  char* arguments;
  char* extra_environment;
  short use_path;
  short copy_environment;
  short niceness;
  short wait;
  unsigned int timeout;
} command;

//function prototypes
void print_parsed_command(command);
short parse_command(command*, char*);


//global variables here


short getlinedup(FILE* fp, char** value){
  char* line = NULL;
  size_t n = 0;
  //get one line
  int ret = getline(&line, &n, fp);

  if(ret == -1){
    //the file ended
    return 0;
  }
  //remove \n at the end
  line[strcspn(line, "\n")] = '\0';
  //duplicate the string and set value
  *value = strdup(line);
  free(line);

  return 1;
}

//parse a command_file and set a corresponding command data structure
short parse_command(command* parsed_command, char* cmdfile){
  FILE* fp = fopen(cmdfile, "rb");
  if(!fp){
    //the file does not exist
    return 0;
  }

  char* value;
  short ret;
  int intvalue;

  ret = getlinedup(fp,&value);
  if(!ret){
    fclose(fp); return 0;
  }
  parsed_command->binary_path = value;

  ret = getlinedup(fp,&value);
  if(!ret){
    fclose(fp); return 0;
  }
  parsed_command->stdin = value;

  ret = getlinedup(fp,&value);
  if(!ret){
    fclose(fp); return 0;
  }
  parsed_command->stdout = value;

  ret = getlinedup(fp,&value);
  if(!ret){
    fclose(fp); return 0;
  }
  parsed_command->stderr = value;

  ret = getlinedup(fp,&value);
  if(!ret){
    fclose(fp); return 0;
  }
  parsed_command->arguments = value;

  ret = getlinedup(fp,&value);
  if(!ret){
    fclose(fp); return 0;
  }
  parsed_command->extra_environment = value;

  ret = getlinedup(fp,&value);
  if(!ret){
    fclose(fp); return 0;
  }
  intvalue = atoi(value);
  if(intvalue != 0 && intvalue != 1){
    fclose(fp); return 0;
  }
  parsed_command->use_path = (short)intvalue;

  ret = getlinedup(fp,&value);
  if(!ret){
    fclose(fp); return 0;
  }
  intvalue = atoi(value);
  if(intvalue != 0 && intvalue != 1){
    fclose(fp); return 0;
  }
  parsed_command->copy_environment = (short)intvalue;

  ret = getlinedup(fp,&value);
  if(!ret){
    fclose(fp); return 0;
  }
  intvalue = atoi(value);
  if(intvalue <-20 || intvalue >19){
    fclose(fp); return 0;
  }
  parsed_command->niceness = (short)intvalue;

  ret = getlinedup(fp,&value);
  if(!ret){
    fclose(fp); return 0;
  }
  intvalue = atoi(value);
  if(intvalue != 0 && intvalue != 1){
    fclose(fp); return 0;
  }
  parsed_command->wait = (short)intvalue;

  ret = getlinedup(fp,&value);
  if(!ret){
    fclose(fp); return 0;
  }
  intvalue = atoi(value);
  if(intvalue < 0){
    fclose(fp); return 0;
  }
  parsed_command->timeout = (unsigned int)intvalue;

  return 1;
}

//useful for debugging
void print_parsed_command(command parsed_command){
  printf("----------\n");
  printf("binary_path: %s\n", parsed_command.binary_path);
  printf("stdin: %s\n", parsed_command.stdin);
  printf("stdout: %s\n", parsed_command.stdout);
  printf("stderr: %s\n", parsed_command.stderr);
  printf("arguments: %s\n", parsed_command.arguments);
  printf("extra_environment: %s\n", parsed_command.extra_environment);
  printf("use_path: %d\n", parsed_command.use_path);
  printf("copy_environment: %d\n", parsed_command.copy_environment);
  printf("niceness: %d\n", parsed_command.niceness);
  printf("wait: %d\n", parsed_command.wait);
  printf("timeout: %d\n", parsed_command.timeout);
}

void free_command(command cmd){
  free(cmd.binary_path);
  free(cmd.stdin);
  free(cmd.stdout);
  free(cmd.stderr);
  free(cmd.arguments);
  free(cmd.extra_environment);
}


int main(int argc, char *argv[], char* env[]) {

  for(int ncommand=1; ncommand<argc; ncommand++){
    command parsed_command;
    int ret = parse_command(&parsed_command, argv[ncommand]);
    if (!ret){
      printf("command file %s is invalid\n", argv[ncommand]);
      continue;
    }

    //may be useful for debugging
    //print_parsed_command(parsed_command);

    //process_command(...);
    /*
    process_command will:
    - get a parsed_command variable
    - create a child process
    - set file redirection, niceness, arguments, envirionment variables, ...
    - call a proper variant of execv
    - print when a child process is created and when any child process is terminated
    - if necessary, wait for the termination of the program
    */

    free_command(parsed_command);
  }

  //remember to wait for the termination of all the child processes, regardless of the value of parsed_command.wait

}

