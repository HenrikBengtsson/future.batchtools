# CRAN submission future.batchtools 0.11.0

on 2022-12-14

I've verified this submission has no negative impact on any of the 9 reverse package dependencies available on CRAN.

Thank you


## Notes not sent to CRAN

### R CMD check validation

The package has been verified using `R CMD check --as-cran` on:

| R version | GitHub | R-hub  | mac/win-builder |
| --------- | ------ | ------ | --------------- |
| 3.4.x     | L      |        |                 |
| 3.6.x     | L      |        |                 |
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
── future.batchtools 0.11.0: OK

  Build ID:   future.batchtools_0.11.0.tar.gz-c3eaf0f55e4f487986e35fd27fa4a294
  Platform:   Debian Linux, R-devel, clang, ISO-8859-15 locale
  Submitted:  45m 33.8s ago
  Build time: 44m 34.8s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── future.batchtools 0.11.0: OK

  Build ID:   future.batchtools_0.11.0.tar.gz-75e42269653f48b690f7964ef4f39625
  Platform:   Fedora Linux, R-devel, GCC
  Submitted:  45m 33.9s ago
  Build time: 33m 10.4s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── future.batchtools 0.11.0: OK

  Build ID:   future.batchtools_0.11.0.tar.gz-635da341b302436c9264825b2359af4b
  Platform:   Debian Linux, R-patched, GCC
  Submitted:  45m 33.9s ago
  Build time: 41m 26.5s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── future.batchtools 0.11.0: WARNING

  Build ID:   future.batchtools_0.11.0.tar.gz-0e6a7dcddfe846f59755d9d253fe486c
  Platform:   macOS 10.13.6 High Sierra, R-release, CRAN's setup
  Submitted:  45m 33.9s ago
  Build time: 6m 14.8s

❯ checking whether package ‘future.batchtools’ can be installed ... WARNING
  > Found the following significant warnings:
  > Warning: package ‘parallelly’ was built under R version 4.1.2
  > Warning: package ‘future’ was built under R version 4.1.2

0 errors ✔ | 1 warning ✖ | 0 notes ✔

── future.batchtools 0.11.0: OK

  Build ID:   future.batchtools_0.11.0.tar.gz-133d66e156e24fc1bcadfb2f215e9d7d
  Platform:   Windows Server 2022, R-release, 32/64 bit
  Submitted:  45m 33.9s ago
  Build time: 5m 40.3s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```
