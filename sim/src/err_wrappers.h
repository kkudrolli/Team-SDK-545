/*
 * Author: Kais Kudrolli
 *
 * Description: The header file for err_wrappers.c.
 *
 */

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

#ifndef _ERR_WRAPPERS_H
#define _ERR_WRAPPERS_H

/* Function defintions */
FILE *Fopen(const char *filename, const char *mode);
size_t Fread(void *ptr, size_t size, size_t nmemb, FILE *stream); 
void Fclose(FILE *fp); 
void *Malloc(size_t size); 
void *Realloc(void *ptr, size_t size);
void *Calloc(size_t nmemb, size_t size); 
void Free(void *ptr);

#endif
