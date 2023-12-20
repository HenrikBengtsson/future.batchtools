# CRAN submission future.batchtools 0.12.1

on 2023-12-19

I've verified this submission has no negative impact on any of the 5 reverse package dependencies available on CRAN.

Thank you


## Notes not sent to CRAN

### R CMD check validation

The package has been verified using `R CMD check --as-cran` on:

| R version | GitHub | R-hub | mac/win-builder |
| --------- | ------ | ----- | --------------- |
| 3.6.x     | L      |       |                 |
| 4.1.x     | L      |       |                 |
| 4.2.x     | L M W  |       |                 |
| 4.3.x     | L M W  | .   W | M1 W            |
| devel     | L M W  | .     |    W            |

_Legend: OS: L = Linux, M = macOS, M1 = macOS M1, W = Windows_


R-hub checks:

```r
res <- rhub::check(platforms = c(
  "debian-clang-devel", 
  "fedora-gcc-devel",
  "debian-gcc-patched", 
  "windows-x86_64-release"
))
print(res)
```

gives

```
── future.batchtools 0.12.1: OK

  Build ID:   future.batchtools_0.12.1.tar.gz-0cf2af4123d14ff3ac742eb611644044
  Platform:   Debian Linux, R-devel, clang, ISO-8859-15 locale
  Submitted:  3h 40m 16.2s ago
  Build time: 1h 10m 30.4s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── future.batchtools 0.12.1: OK

  Build ID:   future.batchtools_0.12.1.tar.gz-f68417d7155c4af6a5ac7d6619aff851
  Platform:   Fedora Linux, R-devel, GCC
  Submitted:  3h 40m 16.2s ago
  Build time: 52m 37.8s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── future.batchtools 0.12.1: OK

  Build ID:   future.batchtools_0.12.1.tar.gz-26c0209f468c4dd5af5f3f4f908cb3c7
  Platform:   Debian Linux, R-patched, GCC
  Submitted:  3h 40m 16.2s ago
  Build time: 1h 5m 2.8s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── future.batchtools 0.12.1: OK

  Build ID:   future.batchtools_0.12.1.tar.gz-64ca57c8a5b543e68b5122ba5eb2a3d1
  Platform:   Windows Server 2022, R-release, 32/64 bit
  Submitted:  3h 40m 16.2s ago
  Build time: 6m 41s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```
