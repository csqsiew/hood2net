## R CMD check results

❯ checking CRAN incoming feasibility ... [5s/16s] NOTE
  Maintainer: ‘Cynthia Siew <cynthia.siew@mailfence.com>’
  
  New submission
  
  Possibly misspelled words in DESCRIPTION:
    Pisoni (13:58)
    Vitevitch (14:48)
    psycholinguists (18:34)

❯ checking compilation flags used ... NOTE
  Compilation used the following non-portable flag(s):
    ‘-mno-omit-leaf-frame-pointer’

0 errors ✔ | 0 warnings ✔ | 2 notes ✖

## revdepcheck results

There are currently no downstream dependencies for this package

## Comments 

* I am not sure how to resolve the NOTE regarding the compilation flag. It may be an issue specific to the platform I am using.
* "psycholinguists" is not misspelled, these are researchers who study psycholinguistics: https://en.wikipedia.org/wiki/Psycholinguistics
* "Vitevitch"" and "Pisoni" are author names and not misspelled.

## Resubmission 

This is a resubmission. In this version: 

* The DESCRIPTION is updated with relevant references. 
* Examples for non-internal functions are unwrapped.
