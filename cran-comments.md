## Test environments
* local OS X install, R 3.5.1
* Ubuntu 14.04.5 (on travis-ci), R 3.5.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

---

Resubmission following requested changes from CRAN & fixing one 
bug that was caught in the interim. 
  
* "Please single quote software names such as 'python' in the 
Description field."
* "Please only use a file license with the GPL-3 if you want to add 
restrictions. The license itself can be omitted as it is shipped with R."

R CMD check was rerun, locally, on Travis CI, and win-builder.

There is a cran package called sylCount, and an archived package 
called syllable. These packages operate on different principles
(counting syllables from normal text), and serve different 
use cases (text complexity/readability.
