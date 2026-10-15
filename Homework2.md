# EE282 Homework2

## Problem 1

**Selected prompt:** Ask a problem that requires a student to understand navigation and manipulation of directories in a filesystem. Your question should require an answer using at least the following commands/concepts: `cd`, `../`, `mkdir`, and `rmdir`.

### Question

You are organizing directories for a research project. Your current working directory is `/home/student/ee282/data/raw`. The existing directory structure is:

```text
/home/student/ee282/
    data/
        raw/
        processed/
    output/
        figures/
```

The `raw` and `processed` directories are empty. Write shell commands that performs the steps in the order below:

1. Move from `raw` to its parent directory, `data`, using `../`.
2. Create a directory named `temporary` inside `data`.
3. Enter `temporary`, then return to `data` using `../`.
4. Remove the empty `temporary` directory.
5. Move from `data` to `output/figures` using a relative path that includes `../`.
6. Create a directory named `qc` inside `figures`, then enter it.

What is the final working directory? Explain what `../` means and why `rmdir` can remove `temporary` in this example.

### Answer Key

```bash
cd ../
mkdir temporary
cd temporary
cd ../
rmdir temporary
cd ../output/figures
mkdir qc
cd qc
```

The final working directory is:

```text
/home/student/ee282/output/figures/qc
```

- `cd` changes the current working directory.
- `../` refers to the parent of the current directory. From `data`, `../output/figures` first goes up to `ee282`, then enters `output`, and finally enters `figures`.
- `mkdir` creates a new empty directory.
- `rmdir` removes an empty directory. Here, nothing was created inside `temporary`. If it contains a file or subdirectory, `rmdir temporary` would not work.

## Problem 2: Accessing Columns by Name in R

**Selected prompt:** Ask a problem that requires a student to understand the difference between accessing a column in a matrix with text indices versus accessing a column in a data frame with text indices. 

### Question

The following R codes create a numeric matrix and a data frame containing measurements from three samples:

```r
mymatrix <- matrix(
  c(10, 20, 30, 2, 4, 6),
  nrow = 3,
  ncol = 2,
  dimnames = list(NULL, c("col1", "col2"))
)

mydf <- data.frame(
  col1 = c(10, 20, 30),
  col2 = c(2, 4, 6)
)
```

For each expression below, what are the returned values and is the result a numeric vector or a data frame? For vectors, give their length; for data frames, give their number of rows and columns.

```r
mymatrix[, "col1"]
mydf[, "col1"]
mydf["col1"]
mydf$col1
mydf[["col1"]]
```

Also answer these questions:

1. Which expressions return the same type of object with the same values?
2. Explain the difference in these expressions. 
3. How to select `col1` with preserving a two-dimensional structure for both the matrix and the data frame?

### Answer Key

| Expression | Returned values | Object type | Size |
| --- | --- | --- | --- |
| `mymatrix[, "col1"]` | `10, 20, 30` | Numeric vector | Length 3 |
| `mydf[, "col1"]` | `10, 20, 30` | Numeric vector | Length 3 |
| `mydf["col1"]` | A column named `col1` containing `10, 20, 30` | Data frame | 3 rows, 1 column |
| `mydf$col1` | `10, 20, 30` | Numeric vector | Length 3 |
| `mydf[["col1"]]` | `10, 20, 30` | Numeric vector | Length 3 |

`mymatrix[, "col1"]`, `mydf[, "col1"]`, `mydf$col1`, `mydf[["col1"]]`:

```r
[1] 10 20 30
```

`mydf["col1"]`:

```r
  col1
1   10
2   20
3   30
```

**1. ** `mymatrix[, "col1"]`, `mydf[, "col1"]`, `mydf$col1`, and `mydf[["col1"]]` return the same numeric vector.

**2. ** A matrix uses two-dimensional indexing: `[rows, columns]`. A blank row index selects all rows. Selecting one column will drop the matrix dimensions, producing a vector.

A data frame supports both two-dimensional and list-style indexing:

- `mydf[, "col1"]` selects all rows of the and simplifies the result to a vector.
- `mydf["col1"]` uses a single index to select a subset of columns and preserves the data-frame structure.
- `mydf$col1` and `mydf[["col1"]]` just extract the column. Here, the column is a numeric vector.

**3. ** To preserve 2-dim structure, we can use `drop = FALSE` with 2-dim indexing:

```r
mymatrix[, "col1", drop = FALSE]  # A 3x1 matrix
mydf[, "col1", drop = FALSE]      # A 3-row 1-column data frame (same as `mydf["col1"]`)
```

## Problem 3: Sharing a File Using Symbolic Unix Permissions

**Selected prompt:** Ask a question that requires a student to understand how to share access to a directory and a file in that directory on a Unix/Linux filesystem from their home directory with a colleague without exposing the user's entire directory. 

### Question

You want a colleague in your lab group to read `/home/student/shared/results.txt` without allowing them to list the contents of your home directory or access your private research directory. The permissions shown below are the initial permissions.

| Path | Initial permissions |
| --- | --- |
| `/home/student` | `drwx------` |
| `/home/student/shared` | `drwx------` |
| `/home/student/shared/results.txt` | `-rw-------` |
| `/home/student/private` | `drwx------` |

Write commands using `chmod {u,g,o}{+,-}{r,w,x}` to make these changes:

1. Your colleague can traverse your home directory but cannot list its contents or modify it.
2. Your colleague can list and traverse `shared`, but cannot create, delete, or rename files there.
3. Your colleague can read `results.txt`, but cannot write to or execute it.
4. Your colleague cannot access your `private` directory.

Explain what each command does. 

### Answer Key

```bash
chmod g+x /home/student
chmod g+rx /home/student/shared
chmod g+r /home/student/shared/results.txt
```

No need to change anything for `/home/student/private` since its existing permissions already deny group and other access.

The resulting permissions are:

| Path | Final permissions |
| --- | --- |
| `/home/student` | `drwx--x---` |
| `/home/student/shared` | `drwxr-x---` |
| `/home/student/shared/results.txt` | `-rw-r-----` |
| `/home/student/private` | `drwx------` |

In `chmod` notations,`g` means the file or directory's group, and `+` adds the specified permissions. 
For a directory:

- **Read (`r`)** allows listing the names of its entries.
- **Execute (`x`)** allows traversing the directory and accessing entries by name (subject to the entries' own permissions).
- **Write (`w`)**, together with execute permission, allows creating, deleting, or renaming entries.

The three commands above does the following:

1. Traverse the home directory to reach a known path such as `shared`. It does not grant permission to list the home directory’s contents.
2. List filenames inside `shared` `(r)` and access entries by name `(x)`, subject to each entry’s own permissions. With no directory write permission, they cannot create, delete, or rename files there.
3. Read the contents of `results.txt`, cannot create, delete, or rename.
