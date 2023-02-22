# CRAN submission future.batchtools 0.12.0

on 2023-02-22

I've verified this submission has no negative impact on any of the 5 reverse package dependencies available on CRAN.

Thank you


## Notes not sent to CRAN

### R CMD check validation

The package has been verified using `R CMD check --as-cran` on:

| R version | GitHub | R-hub  | mac/win-builder |
| --------- | ------ | ------ | --------------- |
| 3.4.x     | L      |        |                 |
| 4.0.x     | L      |        |                 |
| 4.1.x     | L M W  |   M    |                 |
| 4.2.x     | L M W  | L   W  | M1 W            |
| devel     | L M W  | L      | M1 W            |

_Legend: OS: L = Linux, M = macOS, M1 = macOS M1, W = Windows_


R-hub checks:

```r
res <- rhub::check(platforms = c(
  "debian-clang-devel", 
  "fedora-gcc-devel",
  "debian-gcc-patched", 
  "macos-highsierra-release-cran",
  "windows-x86_64-release"
))
print(res)
```

gives

```
```
