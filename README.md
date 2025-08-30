# Color Convert

High‑quality color space conversion utilities for the [MoonBit](https://www.moonbitlang.com/) language.
This library provides a focused, dependency‑free set of functions to convert between many common (and some modern) color spaces used in graphics, imaging, CSS, and perceptual color work.

## Highlights

- sRGB inter‑conversion with: HSV, HSL, HCG, HWB, CMYK, Gray, XYZ (D65), CIE Lab, CIE LCH, OKLab, OKLCH, Apple 16‑bit RGB
- Hex string parsing & formatting (#RGB, #RRGGBB, plain forms)
- Named CSS colors → RGB (case‑insensitive) and reverse keyword lookup
- Modern perceptual color support (OKLab / OKLCH) with XYZ bridge
- Pure functions, no global mutation, no external deps
- Comprehensive tests for numerical correctness

## Installation

Add the module to your MoonBit project (assuming standard MoonBit tooling):

```bash
moon add CAIMEOX/color
```

write simple code like:

```moonbit
let (h, s, v) = rgb2hsv(255.0F, 0.0F, 0.0F)
let (r, g, b) = hsl2rgb(240.0F, 100.0F, 50.0F)
let hex = rgb2hex(r, g, b) // "0000FF"
```

## Usage Examples

```moonbit
// Name lookup
let rgb = name2rgb("rebeccapurple")

// Round‑trip through OKLab
let (l, a, b) = rgb2oklab(92.0F, 191.0F, 84.0F)
let (rr, gg, bb) = oklab2rgb(L, A, B)

// Hex to RGB
let (r2, g2, b2) = hex2rgb("#ABCDEF") // (171,205,239)

// XYZ ↔ Lab ↔ LCH
let (x, y, z) = rgb2xyz(255.0F, 255.0F, 255.0F)
let (l, a, b3) = xyz2lab(x, y, z)
let (_, c, h) = lab2lch(l, a, b3)
```

## API Overview

All numeric channel inputs & outputs follow common conventions:

- sRGB channels: Float 0–255 (matches test expectations)  
- Percentage style outputs: Many functions return saturation / value / lightness / chroma / gray as 0–100 floats (mirroring common JS libs like color‑convert)  
- Hex: uppercase string without leading # (add it yourself if needed)  
- XYZ: D65 white, scaled 0–100

| From | To | Function |
|------|----|----------|
| RGB | HSV | `rgb2hsv` |
| RGB | HSL | `rgb2hsl` |
| RGB | CMYK | `rgb2cmyk` |
| RGB | Hex | `rgb2hex` |
| RGB | HWB | `rgb2hwb` |
| RGB | HCG | `rgb2hcg` |
| RGB | XYZ | `rgb2xyz` |
| RGB | Lab | `rgb2lab` |
| RGB | Gray% | `rgb2gray` |
| RGB | OKLab | `rgb2oklab` |
| RGB | Apple 16‑bit | `rgb2apple` |
| HSV | RGB | `hsv2rgb` |
| HSV | HSL | `hsv2hsl` |
| HSL | RGB | `hsl2rgb` |
| HSL | HSV | `hsl2hsv` |
| HWB | RGB | `hwb2rgb` |
| HCG | RGB | `hcg2rgb` |
| CMYK | RGB | `cmyk2rgb` |
| XYZ | RGB | `xyz2rgb` |
| XYZ | Lab | `xyz2lab` |
| Lab | XYZ | `lab2xyz` |
| Lab | LCH | `lab2lch` |
| LCH | Lab | `lch2lab` |
| OKLab | XYZ | `oklab2xyz` |
| OKLab | RGB | `oklab2rgb` |
| OKLab | OKLCH | `oklab2oklch` |
| OKLCH | OKLab | `oklch2oklab` |
| Gray% | RGB | `gray2rgb` |
| Hex | RGB | `hex2rgb` |
| Name | RGB | `name2rgb` (raises `NameNotFound`) |
| RGB | Name | `rgb2keyword` (optional) |
| Apple 16‑bit | RGB | `apple2rgb` |


## Error Handling

- `name2rgb` raises `NameNotFound` if the color keyword does not exist.
- `hex2rgb` raise error for malformed inputs (guard pattern); you can pre‑validate if stricter behavior is desired.

## Precision Notes

Floating point operations introduce minor rounding differences. Tests assert *stringified* tuple outputs produced on the reference platform. When writing new tests allow for small epsilon (≈1e‑3–1e‑2) if comparing numerically.

## Running Tests

```bash
moon test
```

Update expected outputs after intentional algorithm changes with:

```bash
moon test -u
```

## License

Apache 2.0 — see `LICENSE` file.

## Acknowledgments

Thanks to [color-convert](https://bestofjs.org/projects/color-convert) and [color-name](https://bestofjs.org/projects/color-name) for reference data and inspiration
