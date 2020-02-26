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
void process_command(command*, char* parent_env[]);
void decode_args(char* str, char* path, char arg[50][1000], int boolean);


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
    // print_parsed_command(parsed_command);

    process_command(&parsed_command, env);
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

  //tidy up, finish last process
  while (1) {
    int status;
    pid_t pid = waitpid(-1, &status, 0);
    if ( pid < 0 ) { 
      break; 
    }
    printf("Child process %d terminated with exit code %d\n", pid, WEXITSTATUS(status));
  }
}

void process_command(command* cmd, char* parent_env[]) {
  int status;
  pid_t pid = fork();

  //error
  if (pid < 0) {
    perror("fork() error, could not create child process\n");
    exit(1);
  }

  //child process
  else if ( pid == 0 ) {
    printf("New child process started %d\n", (int) getpid());

  //setting niceness (after fork, before exec)
    setpriority(PRIO_PROCESS, getpid(), cmd->niceness);

    //set stdout, stdin, stderr
    int f_stdout = open(cmd->stdout, O_WRONLY|O_CREAT|O_TRUNC, 0664);
    dup2(f_stdout, STDOUT_FILENO); 
    close(f_stdout);
    int f_stderr = open(cmd->stderr, O_WRONLY|O_CREAT|O_TRUNC, 0664);
    dup2(f_stderr, STDERR_FILENO); 
    close(f_stderr);
    int f_stdin = open(cmd->stdin, O_RDONLY, 0664); 
    dup2(f_stdin, STDIN_FILENO); 
    close(f_stdin);

    // arguments
	char temp_args[50][1000];
	char* args[50];

	decode_args(cmd->arguments, cmd->binary_path, temp_args, 1);

  int arg_count = 0;
	for (arg_count; temp_args[arg_count][0] != '\0'; arg_count++) {
		args[arg_count] = temp_args[arg_count];
	}

	args[arg_count] = NULL;

  // env
  char env_temp[50][1000];
  char* child_env[50];
  
  decode_args(cmd->extra_environment, cmd->binary_path ,env_temp, 0);

  int env_count = 0;
  for (env_count; env_temp[env_count][0] != '\0'; env_count++) {
		child_env[env_count] = env_temp[env_count];
	}

	child_env[env_count] = NULL;

//child env w/ parent
int parent_tally = 0;
int child_tally = 0;
char* envs[500];

for (int i = 0; parent_env[i] != NULL; i++) {
  parent_tally++;
}
for (int i = 0; child_env[i] != NULL; i++) {
  child_tally++;
}
int count;
for (count = 0; count < (parent_tally + child_tally); count++) {
  if ( count < parent_tally ) {
    envs[count] = parent_env[count];
  }

  else {
    envs[count] = child_env[count - parent_tally];
  }
}

envs[count] = NULL;

char* exec_args[1000];
char temp_arr[100];

sprintf(temp_arr, "%d",cmd->timeout);

if(cmd->timeout != 0) {

  exec_args[0] = "/usr/bin/timeout";
  exec_args[1] = "--preserve-status";
  exec_args[2] = "-k";
  exec_args[3] = "1";
  exec_args[4] = temp_arr;
  exec_args[5] = cmd->binary_path;

  int i = 0;
  for (i; args[i] != NULL; i++) {
    if( i !=  0 ) {
      exec_args[i + 5] = args[i];
    }
  }

  exec_args[i + 5] = NULL;
}

else {
  int i = 0;
  for (i; args[i] != NULL; i++) {
    exec_args[i] = args[i];
  }
  exec_args[i] = NULL; 
}

//config done...
//exec time!!
if (cmd->use_path == 0) {
  if (cmd->copy_environment == 0) {
    //http://man7.org/linux/man-pages/man2/execve.2.html
    execve(exec_args[0],exec_args, child_env);
  }
  else if (cmd->copy_environment == 1) {
    execve(exec_args[0],exec_args, envs);
  }
}

// @1 -->
// your shell should searchfor〈binarypath〉
// in all the directories specified by thePATHenvironmentvariable.
else if (cmd->use_path == 1) {
  //then
  if ( cmd->copy_environment == 0 ) {
    //https://linux.die.net/man/3/execvpe
    execvpe(exec_args[0], exec_args, child_env);
  }
  else if ( cmd->copy_environment == 1 ) {
    execvpe(exec_args[0], exec_args, envs);
  }
}
    //nothing else can be run after execvp because it starts a new child process (i.e.) the 
    //current child process it is in, this conditional, is terminated now
    // exit(0); -- can use for debugging purposes (if execvp not being used)
  } 

  else if ( cmd->wait == 1 ) {
    waitpid(pid, &status, 0);
  
    if ( WIFEXITED(status) ) {
      int exit_status = WEXITSTATUS(status);
      printf("Child process %d terminated with exit code %d\n", pid, WEXITSTATUS(status));
      }
    }
  }

//had a massive talk w/ a person on how to go about creating this method as I've never decoded something, especially using C!!!
void decode_args(char* str, char* path, char arg[50][1000], int boolean) {
  // Adding the binary to the path
  int index;	
  int arg_count = 0;

  if ( boolean == 1 ) {

    for(index = 0; index < strlen(path); index++) {
  	arg[0][index] = path[index];
    }

    arg[0][index] = '\0';
    arg_count = 1;
  }

  //Adding args
  if ( str[0] == '\0' ) {
    arg[0][0] == '\0';
    return;
  }

  int count = 0;
  char str_byte[3];

  for(int i = 0; str[i] != '\0'; i = i + 2) {

    if ( str[i + 1] == '0' && str[i] == '0' ) {
      arg[arg_count][count] = '\0';
      count = 0;
      arg_count++;
    }

    else {
      str_byte[0] = str[i];
      str_byte[1] = str[i+1];
      //http://www.cplusplus.com/reference/cstdlib/strtoul/
      arg[arg_count][count] = (char) strtoul(str_byte, NULL, 16);    
      count++;
      }
  }
  arg[arg_count][count] = (char) '\0';
  arg[arg_count+1][0] = (char) '\0';
}

