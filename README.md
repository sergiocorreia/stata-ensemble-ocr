# `ensemble_ocr`: Stata package that improves the quality of variables generated through multiple OCR engines or scans


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
