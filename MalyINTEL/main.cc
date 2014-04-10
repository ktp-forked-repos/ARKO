#include <stdio.h>

extern "C" char* strrstr(char *txt, char *pt);

int main(void)
{
  char txt[]="kolejne Arko";
  char pt[]="ko";
  char *wynik;
  
  printf("Ci±g znakowy: %s\n", txt);
  wynik=strrstr(txt, pt);
  printf("Ci±g wynikowy: %s\n", wynik);
  
  return 0;
}
