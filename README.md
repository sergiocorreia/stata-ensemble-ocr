# `ensemble_ocr` 

This is a Stata package that improves the quality of variables generated through multiple OCR scans or engines.

The input is a set of variables that reflects specific words or numbers in an OCRed text. This text must have been OCRed with multiple engines, from different paper copies, or through multiple scans, so the versions are different.

As long as the different methods are unbiased, picking the most common digit will give the correct result. For instance, in this hypothetical example we obtain a number from three engines:

| "Ground Truth" | Abbyy | Tesseract v3 | Tesseract v4 |
|----------------|-------|--------------|--------------|
| 123456         | 23456 | 128450       | 123186       |

This package works by first aligning the input:

```
 23456
128450
123186
```

Then, the most common digit is picked, and ground truth is recovered:


```
 23456
128450
123186
------
123456
```

Note: this approach is similar in spirit to several papers by [WB Lundt](https://scholar.google.com/citations?user=h5GKGxQAAAAJ).


## Installation

```stata
net install ensemble_ocr, from(https://github.com/sergiocorreia/ensemble_ocr/raw/master/)
```


## Syntax

```stata
ensemble_ocr varlist , generate(newvar)
```

## Warnings

- This is aimed at dealing with relatively small numbers (<15 digits); will fail in unexpected ways otherwise (because it exceeds the capacity of -double-)
- Could be extended to deal with non-digit strings but currently only handles digits and nothing else
- Cases where strings have different length (and thus need to be aligned) are not fully implemented
