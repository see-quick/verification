#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void padBinaryString(char **bin, int targetLength) {
  int len = strlen(*bin);
  if (len >= targetLength)
    return;

  // Allocate new memory for the padded string
  char *padded = (char *)malloc(targetLength + 1);

  // Fill with leading zeros
  memset(padded, '0', targetLength - len);

  // Copy the original string after the padding
  strcpy(padded + (targetLength - len), *bin);

  padded[targetLength] = '\0'; // Null-terminate

  // Free old string if it was dynamically allocated
  free(*bin);

  *bin = padded;
}

char *addBinary(char *a, char *b) {
  int lenA = strlen(a);
  int lenB = strlen(b);
  int maxLen = (lenA > lenB) ? lenA : lenB;

  // Pad both strings to the same length
  padBinaryString(&a, maxLen);
  padBinaryString(&b, maxLen);

  bool carry = false;
  // Result needs maxLen + 1 (for possible carry) + 1 (null terminator)
  char *c = (char *)malloc(maxLen + 2);
  c[maxLen + 1] = '\0'; // Null-terminate the result

  // start rightmost bit :)
  for (int i = maxLen - 1; i >= 0; i--) {
    int bitA = a[i] - '0';
    int bitB = b[i] - '0';
    int sum = bitA + bitB + carry;

    c[i + 1] = (sum % 2) + '0'; // Store binary digit
    carry = sum / 2;            // Compute new carry
  }

  if (carry) {
    c[0] = '1';
    return c;
  } else {
    return c + 1;
  } // skip leading zero :)
}

int main() {
  char *a = strdup("1101"); // Must use strdup to allow modification
  char *b = strdup("1011");

  char *sum = addBinary(a, b);
  printf("Binary Sum: %s\n", sum);

  free(a);
  free(b);
  return 0;
}
