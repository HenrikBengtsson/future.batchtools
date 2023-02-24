# CRAN submission future.batchtools 0.12.0

on 2023-02-24

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
── future.batchtools 0.12.0: OK

  Build ID:   future.batchtools_0.12.0.tar.gz-641472edd3b5461d9aecf43df6440b2b
  Platform:   Debian Linux, R-devel, clang, ISO-8859-15 locale
  Submitted:  1h 47m 26.1s ago
  Build time: 1h 10m 17.8s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── future.batchtools 0.12.0: IN-PROGRESS

  Build ID:   future.batchtools_0.12.0.tar.gz-7a87266bfdb64039bcec5c69000be01c
  Platform:   Fedora Linux, R-devel, GCC
  Submitted:  1h 47m 26.1s ago


── future.batchtools 0.12.0: IN-PROGRESS

  Build ID:   future.batchtools_0.12.0.tar.gz-ee81fb66f73c41d8908a2dff029f1479
  Platform:   Debian Linux, R-patched, GCC
  Submitted:  1h 47m 26.1s ago


── future.batchtools 0.12.0: WARNING

  Build ID:   future.batchtools_0.12.0.tar.gz-77b23546d6c94278b9afa8b7d1807eff
  Platform:   macOS 10.13.6 High Sierra, R-release, CRAN's setup
  Submitted:  1h 47m 26.1s ago
  Build time: 6m 1.1s

❯ checking whether package ‘future.batchtools’ can be installed ... WARNING
  See below...

0 errors ✔ | 1 warning ✖ | 0 notes ✔

── future.batchtools 0.12.0: OK

  Build ID:   future.batchtools_0.12.0.tar.gz-680748ca9a384491932b2502119bab87
  Platform:   Windows Server 2022, R-release, 32/64 bit
  Submitted:  1h 47m 26.1s ago
  Build time: 5m 43.7s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```
