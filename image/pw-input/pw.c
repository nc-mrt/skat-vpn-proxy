#include <termios.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

void get_password(char *password)
{
    static struct termios old_terminal;
    static struct termios new_terminal;

    tcgetattr(STDIN_FILENO, &old_terminal);

    new_terminal = old_terminal;
    new_terminal.c_lflag &= ~(ECHO | ICANON);

    tcsetattr(STDIN_FILENO, TCSANOW, &new_terminal);

    int i = 0;
    while (1) {
        int ch = getchar();
        if (ch == '\n' || ch == EOF) {
            fputs("\r\n", stderr);
            break;
        }
        password[i++] = (char)ch;
        fputc('*', stderr);
        fflush(stderr);
    }
    password[i] = '\0';
    tcsetattr(STDIN_FILENO, TCSANOW, &old_terminal);
}

int main(void)
{
    char password[BUFSIZ];

    fputs("Enter password (right click to insert): ", stderr);
    get_password(password);
    puts(password);
    return 0;
}