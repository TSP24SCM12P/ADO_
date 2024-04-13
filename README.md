# Assignment I: Storage Manager

- Yousef Suleiman A20463895

## Building

To build the storage manager as well the first set of test cases in `test_assign1_1.c`, use

```sh
make
./test_assign1_1.o
```

To build the second set of test cases in `test_assign1_2.c`, use

```sh
make test_assign1_2
./test_assign1_2.o
```

To clean the solution use

```sh
make clean
```

## Explanation of Solution

### Manipulating Page Files

```c
RC createPageFile(char *fileName)
```

- create a new page file by passing a `fileName`
- write a single page of `PAGE_SIZE` written with `\0` bytes
- this page file does not *stay* open and will be closed in this function. `openPageFile` must be called subsequently to open the page file.

```c
RC openPageFile(char *fileName, SM_FileHandle *fHandle)
```

- open a page file by passing a `fileName` and a pointer to a file handle
- the file handle `fHandle` is populated with
  - `fileName` is set to the passed `fileName`
  - `totalNumPages` is populated by the helper function `_getFileSize` which
    - moves the file pointer to the end of the file
    - uses `ftell` to get the position of the pointer relative to the start of the file (i.e. the file `size`)
    - divide this `size` by `PAGE_SIZE` to get the `totalNumPages`
  - `curPagePos` is set to `0`
  - `mgmtInfo` is used to store the file pointer (the user should not use this as it is used internally by the storage manager)

```c
RC closePageFile (SM_FileHandle *fHandle)
```

- closes the page file using `mgmtInfo` which holds the file pointer
- `mgmtInfo` is then set to `NULL` (i.e. `(void *)0`)

```c
RC destroyPageFile (char *fileName)
```

- removes the page file
- it is safer to call `closePageFile` before calling `destroyPageFile`

### Reading Blocks from Disc

```c
RC readBlock (int pageNum, SM_FileHandle *fHandle, SM_PageHandle memPage)
```

- read the block indexed at `pageNum` 
  - if its in the range of `0` and `fHandle->totalNumPages`
- stores the page content in `memPage`
- this *does not* change the value of `fHandle->curPagePos`

```c
int getBlockPos (SM_FileHandle *fHandle)
```

- simply returns `fHandle->curPagePos`

```c
RC readFirstBlock (SM_FileHandle *fHandle, SM_PageHandle memPage)
```

- read the block indexed at `0`
- this *does not* update the value of `fHandle->curPagePos`

```c
RC readPreviousBlock (SM_FileHandle *fHandle, SM_PageHandle memPage)
```

- read the block indexed at `fHandle->curPagePos - 1`
- if it succeeds, `fHandle->curPagePos ` is updated to that value

```c
RC readCurrentBlock (SM_FileHandle *fHandle, SM_PageHandle memPage)
```

- read the block indexed at `fHandle->curPagePos`
- `fHandle->curPagePos ` is *not* updated as it is already set to itself

```c
RC readNextBlock (SM_FileHandle *fHandle, SM_PageHandle memPage)
```

- read the block indexed at `fHandle->curPagePos + 1`
- if it succeeds, `fHandle->curPagePos ` is updated to that value

```c
RC readLastBlock (SM_FileHandle *fHandle, SM_PageHandle memPage)
```

- read the block indexed at `fHandle->totalNumPages - 1`
- this *does not* update the value of `fHandle->curPagePos`

### Writing Blocks to a Page File

```c
RC writeBlock (int pageNum, SM_FileHandle *fHandle, SM_PageHandle memPage)
```

- write the content of `memPage` to the block indexed at `pageNum` 
  - if its in the range of `0` and `fHandle->totalNumPages`

```c
RC writeCurrentBlock (SM_FileHandle *fHandle, SM_PageHandle memPage)
```

- write `memPage` to the block indexed at `fHandle->curPagePos`

```c
RC appendEmptyBlock (SM_FileHandle *fHandle)
```

- move the file pointer to the end of the file and append single page of `PAGE_SIZE` written with `\0` bytes
- `fHandle->totalNumPages` is incremented by 1

```c
RC ensureCapacity (int numberOfPages, SM_FileHandle *fHandle)
```

- while `fHandle->totalNumPages` is less than the `numberOfPages` passed, keep calling `appendEmptyBlock`