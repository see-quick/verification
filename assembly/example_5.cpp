#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern "C"
{
    // asmMain is the assembly language code's "main program":

    void asmMain( void );

    // getTitle returns a pointer to a string of characters
    // from the assembly code that specifies the title of that
    // program (that makes this program generic and usable
    // with a large number of sample programs in "The Art of
    // 64-bit Assembly Language."

    char *getTitle( void );

    // C++ function that the assembly
    // language program can call:

    int readLine( char *dest, int maxLen );

};

int readLine( char *dest, int maxLen )
{
    // Note: fgets returns NULL if there was an error, else
    // it returns a pointer to the string data read (which
    // will be the value of the dest pointer).

    char *result = fgets( dest, maxLen, stdin );
    if( result != NULL )
    {
        // Wipe out the new line character at the
        // end of the string:

        int len = strlen( result );
        if( len > 0 )
        {
            dest[ len - 1 ] = 0;
        }
        return len;
    }
    return -1; // If there was an error.
}

int main(void)
{
    // Get the assembly language program's title:

    char *title = getTitle();

    printf( "Calling %s:\n", title );
    asmMain();
    printf( "%s terminated\n", title );
}
