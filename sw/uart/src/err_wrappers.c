/*
 * Author: Kais Kudrolli
 *
 * Description: This file implements several error wrappers for functions
 * used by the simulator.
 *
 */

#include "err_wrappers.h"

/*********************
 * Library Functions *
 *********************/

/*
 * error_print: Prints an error to stderr.
 *
 * Parameter:
 *  - err_msg: a string error message
 */
void error_print(char *err_msg)
{
    fprintf(stderr, "%s: %s\n", err_msg, strerror(errno));
    exit(0);
}

/*
 * Fopen: Error wrapper function for fopen.
 *
 * Parameters:
 *  - filename: a string containing the name of file to open
 *  - mode: whether to read, write, etc. the file
 */
FILE *Fopen(const char *filename, const char *mode)
{
    FILE *fp;

    if ((fp = fopen(filename, mode)) == NULL) {
        error_print("Fopen error");
    }

    return fp;
}
/*
 * Fread: Error wrapper for fread.
 *
 * Parameters:
 *  - ptr: pointer to location where read data is stored
 *  - size: size of each of objects being read
 *  - nmemb: number of items being read
 *  - stream: a file stream
 *
 * Return value:
 *  - number of objects eread/written
 */
size_t Fread(void *ptr, size_t size, size_t nmemb, FILE *stream) 
{
    size_t n;

    if (((n = fread(ptr, size, nmemb, stream)) < nmemb) && ferror(stream)) {
        error_print("Fread error");
    }

    return n;
}

/*
 * Fclose: Error wrapper for fclose.
 *
 * Parameter:
 *  - fp: File pointer
 */
void Fclose(FILE *fp) 
{
    if (fclose(fp) != 0) {
        error_print("Fclose error");
    }
}

/*
 * Malloc: Error wrapper for malloc.
 *
 * Parameter: 
 *  - size: size of memory space to allocate
 *
 * Return value:
 *  - pointer to allocated memory
 */
void *Malloc(size_t size) 
{
    void *p;

    if ((p  = malloc(size)) == NULL)
        error_print("Malloc error");
    return p;
}

/*
 * Realloc: Error wrapper for realloc.
 *
 * Parameters: 
 *  - ptr: pointer to allocated memory
 *  - size: size of memory space to allocate
 *
 * Return value:
 *  - pointer to reallocated memory
 */
void *Realloc(void *ptr, size_t size) 
{
    void *p;

    if ((p  = realloc(ptr, size)) == NULL)
        error_print("Realloc error");
    return p;
}

/*
 * Calloc: Error wrapper for calloc.
 *
 * Parameters: 
 *  - nmemb: number of members of size to allocate
 *  - size: size of memory space to allocate
 *
 * Return value:
 *  - pointer to allocated memory
 */
void *Calloc(size_t nmemb, size_t size) 
{
    void *p;

    if ((p = calloc(nmemb, size)) == NULL)
        error_print("Calloc error");
    return p;
}

/*
 * Free: Error wrapper for free.
 *
 * Parameter:
 *  - ptr: pointer to memory to be freed
 */
void Free(void *ptr) 
{
    free(ptr);
}

/*
 * Opendir: Error wrapper for opendir.
 *
 * Parameter:
 *  - filename: string name of directory...oddly enough
 *
 * Return value:
 *  - Pointer to opened directory
 */
DIR *Opendir(const char *filename)
{
    DIR *dirp;

    if ((dirp = opendir(filename)) == NULL) {
        error_print("Opendir error");
    }

    return dirp;
}

/*
 * Readdir: Error wrapper for readdir.
 *
 * Parameter: 
 *  - dirp: pointer to directory
 *
 * Return value:
 *  - pointer to struct of directory entry
 */
struct dirent *Readdir(DIR *dirp)
{
    struct dirent *ep;

    if ((ep = readdir(dirp)) == NULL) {
        error_print("Readdir error");
    }

    return ep;
}

/*
 * Closedir: Error wrapper for closedir.
 *
 * Parameter:
 *  - dirp: pointer to directory
 *
 * Return value:
 *  - 0 on success
 *  - -1 on failure, and errno is set
 */
int Closedir(DIR *dirp)
{
    int n;

    if ((n = closedir(dirp)) == -1) {
        error_print("Closedir error");
    }

    return n;
}


