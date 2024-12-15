#include <iostream>
#include <sys/wait.h>
#include "FuncClass.h"

int CreateHTTPserver();

void singChldHandler(int s) 
{
	printf("Caught signal SIGCHILD\n");

	pid_t pid;
	int status;

	while ((pid = waitpid(-1, &status,WNOHANG))>0)
	{
		if (WIFEXITED(status)) printf("\nChild process terminated");
	}
}

void singInthandler(int s) 
{
	printf("Caught signal %d. Starting graceful exit procedure\n",s);

	pid_t pid;
	int status;
	while ((pid = waitpid(-1,&status,0))>0)
	{
		if(WIFEXITED(status)) printf("\nChild process terminated");

	}

	if (pid==-1) printf("\nAll child processes terminated");

	exit(EXIT_SUCCESS);
}

int main(int argc, char* argv[]) {

    signal(SIGCHLD, singChldHandler);
    signal(SIGINT, singInthandler);

    FuncClass obj;
    std::cout << "FuncA result: " << obj.FuncA(5.0, 1.0) << std::endl;

    CreateHTTPserver();
    return 0;
}
