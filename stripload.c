#include <stdlib.h>
#include <stdio.h>

int main(int argc, char **argv){
    FILE *fileptr;
    char *buffer;
    long filelen;

    fileptr = fopen(argv[1], "rb");  
    fseek(fileptr, 0, SEEK_END);     
    filelen = ftell(fileptr);        
    rewind(fileptr);                 

    buffer = (char *)malloc((filelen+1)*sizeof(char));
    fread(buffer, filelen, 1, fileptr);
    fclose(fileptr);
    printf("%ld bytes read\n",filelen);
    fileptr = fopen( argv[2], "wb" );
    fwrite( buffer+2, 1, filelen-2, fileptr );
    fclose(fileptr);
    printf("%ld bytes written\n",filelen-2);

}
