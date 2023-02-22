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
── future.batchtools 0.11.0-9010: OK

  Build ID:   future.batchtools_0.11.0-9010.tar.gz-cec23839000e4562956e576cede5aff1
  Platform:   Debian Linux, R-devel, clang, ISO-8859-15 locale
  Submitted:  5h 5m 40.7s ago
  Build time: 1h 14m 49.9s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── future.batchtools 0.11.0-9010: OK

  Build ID:   future.batchtools_0.11.0-9010.tar.gz-6a75a93970d149c78a2383425f8f8f87
  Platform:   Fedora Linux, R-devel, GCC
  Submitted:  5h 5m 40.7s ago
  Build time: 53m 17s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── future.batchtools 0.11.0-9010: IN-PROGRESS

  Build ID:   future.batchtools_0.11.0-9010.tar.gz-ab2cc44e423c4f8686aa21f04941d9ce
  Platform:   Debian Linux, R-patched, GCC
  Submitted:  5h 5m 40.7s ago


── future.batchtools 0.11.0-9010: WARNING

  Build ID:   future.batchtools_0.11.0-9010.tar.gz-b3582ca9a54c48648c91418627b525fe
  Platform:   macOS 10.13.6 High Sierra, R-release, CRAN's setup
  Submitted:  5h 5m 40.7s ago
  Build time: 6m 3.9s

❯ checking whether package ‘future.batchtools’ can be installed ... WARNING
  See below...

0 errors ✔ | 1 warning ✖ | 0 notes ✔

── future.batchtools 0.11.0-9010: OK

  Build ID:   future.batchtools_0.11.0-9010.tar.gz-6dea9742aec6431c9eb0a5dd7a450a47
  Platform:   Windows Server 2022, R-release, 32/64 bit
  Submitted:  5h 5m 40.7s ago
  Build time: 10m 23.5s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```
