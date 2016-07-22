#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

//some fancy color codes and cursor position constants
#define KNRM  "\x1B[0m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"
#define RESET "\033[0m"
#define CLEAR "\033[2J"
#define POS "\033["

static char pad_name[256];
static char server_address[256];

int crypter(char[], char *); //encryption/decryption function
int cutter(int); //trims used mask from the pad
int msg_out(int, char *); //bytewise msg output

int main(void)
{
	char user_input[256];
	int sock_desc;
	printf(CLEAR); //clear screen
	printf(POS"1;1H" KGRN "Victoria v0.0.1\n\n" RESET);
	printf("User instructions and tips are available in README file.\n");
	printf("Run server or connect as client (s/c): ");
	user_input[0] = getchar();
	if (user_input[0] == 's') {
		printf("Creating server...\n");
		sock_desc = socket(AF_INET, SOCK_STREAM, 0);
		if (sock_desc < 0) {
			printf("Cannot create server. Exiting...\n");
			return 0;
		}
		
	}
	else if(user_input[0] == 'c') {
		
	}
	else
	{
	printf("Exiting...\n");
	return 0;
}
	fgets(server_address, 256, stdin);
	
return 0;
}

int msg_out(int length, char *text)
{
int i = 0;
for (i = 0; i < length; ++i)
{
printf("%X ", text[i]);
}
if (i != length) return 0; //it's bad if i != length
else return 1;
}

int crypter(char *input_msg, char *buffer) //crypter reads from the end of pad file since it's much more easier to truncate used mask bytes
{
int i = 0, length = (strlen(input_msg) - 1), pad_size = 0;
char mask[256];
FILE *pad;
pad = fopen(pad_name, "rb");
if (pad == NULL) return 0; // non-existent file?
fseek(pad, 0, SEEK_END);
pad_size = ftell(pad);
if (pad_size < length) { //it's impossible to use the pad, destroying the rest
fclose(pad);
remove(pad_name);
return -1; //return -1 if pad is too short to encrypt message and had been removed
}
fseek(pad, -length, SEEK_END); // set position to -length byte from EOF
if (fread(mask, sizeof(char), length, pad) == EOF) return 0; //read and check for end of file
fclose(pad); // closes until next encryption/decryption;
for (i=0; i < length; ++i) {
buffer[i] = (char)(input_msg[i] ^ mask[i]); // XOR input and mask to get encrypted/decrypted message
}
return 1; //if everything is ok return something non-zero
}

int cutter(int used_length) //to provide the best cryptographic resistance it's vital to destroy used bytes from pad file
{
FILE *pad;
int pad_size = 0, reduced_size = 0;
pad = fopen(pad_name, "rb");
if (pad == NULL) return 0; //not good for us
fseek(pad, 0, SEEK_END);
pad_size = ftell(pad); //obtain current pad size
fseek(pad, 0, SEEK_SET);
reduced_size = pad_size - used_length; //get new pad size to truncate()
if (truncate(pad_name, reduced_size) == 0) return 1;
else return 0;
fclose(pad);
}
