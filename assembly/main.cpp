#include <stdio.h>

extern "C"
{
	void assembly(void);
}

int main(void) 
{

	printf("ASM:\n");
	assembly();
	printf("Return\n");

	return 0;
}
