///|
/// Convert RGB to HSV color space
pub fn rgb2hsv(r : Float, g : Float, b : Float) -> (Float, Float, Float) {
  let r = r / 255.0
  let g = g / 255.0
  let b = b / 255.0
  let v = @cmp.maximum(r, @cmp.maximum(g, b))
  let diff = v - @cmp.minimum(r, @cmp.minimum(g, b))
  let diffc = fn(c) { (v - c) / 6 / diff + 1 / 2 }
  guard diff != 0 else { (0, 0, v * 100) }
  let s = diff / v
  let rdif = diffc(r)
  let gdif = diffc(g)
  let bdif = diffc(b)
  let h = match v {
    v if v == r => bdif - gdif
    v if v == g => 1 / 3 + rdif - bdif
    v if v == b => 2 / 3 + gdif - rdif
    _ => 0
  }
  let h = if h < 0 { h + 1 } else if h > 1 { h - 1 } else { h }
  (h * 360, s * 100, v * 100)
}

///|
/// Convert RGB to HSL color space
pub fn rgb2hsl(r : Float, g : Float, b : Float) -> (Float, Float, Float) {
  let r = r / 255.0
  let g = g / 255.0
  let b = b / 255.0
  let min = @cmp.minimum(r, @cmp.minimum(g, b))
  let max = @cmp.maximum(r, @cmp.maximum(g, b))
  let delta = max - min
  let l = (min + max) / 2.0
  guard delta != 0.0 else { (0.0, 0.0, l * 100.0) }
  let h = match max {
    max if max == r => (g - b) / delta
    max if max == g => 2.0 + (b - r) / delta
    max if max == b => 4.0 + (r - g) / delta
    _ => 0.0
  }
  let h = @cmp.minimum(h * 60.0, 360.0)
  let h = if h < 0.0 { h + 360.0 } else { h }
  let s = if l <= 0.5 { delta / (max + min) } else { delta / (2.0 - max - min) }
  (h, s * 100.0, l * 100.0)
}

///|
/// Convert RGB to CMYK color space
pub fn rgb2cmyk(
  r : Float,
  g : Float,
  b : Float,
) -> (Float, Float, Float, Float) {
  let r = r / 255.0
  let g = g / 255.0
  let b = b / 255.0
  let k : Float = @cmp.minimum(1.0 - r, @cmp.minimum(1.0 - g, 1.0 - b))
  let one_minus_k : Float = 1.0 - k
  guard one_minus_k != 0.0 else { (0.0, 0.0, 0.0, k * 100.0) }
  let c : Float = (1.0 - r - k) / one_minus_k
  let m : Float = (1.0 - g - k) / one_minus_k
  let y : Float = (1.0 - b - k) / one_minus_k
  (c * 100.0, m * 100.0, y * 100.0, k * 100.0)
}

///|
/// Convert a rgb value to color keyword
pub fn rgb2keyword(r : Float, g : Float, b : Float) -> String? {
  for k, v in color_map.iter2() {
    if v == (r.to_int(), g.to_int(), b.to_int()) {
      return Some(k)
    }
  } else {
    None
  }
}

///|
/// Convert RGB to HEX string
pub fn rgb2hex(r : Float, g : Float, b : Float) -> String {
  let r_int = r.round().to_int() & 0xff
  let g_int = g.round().to_int() & 0xff
  let b_int = b.round().to_int() & 0xff
  let integer = (r_int << 16) + (g_int << 8) + b_int
  let hex_string = int2hex(integer).to_upper()
  let pad = 6 - hex_string.length()
  (if pad > 0 { "0".repeat(pad) } else { "" }) + hex_string
}

///|
/// Convert RGB (sRGB 0-255) to OKLab (L,a,b scaled by 100 like color-convert)
pub fn rgb2oklab(r : Float, g : Float, b : Float) -> (Float, Float, Float) {
  let r_lin = srgb_nonlinear_transform_inv(r / 255)
  let g_lin = srgb_nonlinear_transform_inv(g / 255)
  let b_lin = srgb_nonlinear_transform_inv(b / 255)

  // LMS
  let l = 0.4122214708F * r_lin + 0.5363325363F * g_lin + 0.0514459929F * b_lin
  let m = 0.2119034982F * r_lin + 0.6806995451F * g_lin + 0.1073969566F * b_lin
  let s = 0.0883024619F * r_lin + 0.2817188376F * g_lin + 0.6299787005F * b_lin
  let lp = l.pow(1.0F / 3.0F)
  let mp = m.pow(1.0F / 3.0F)
  let sp = s.pow(1.0F / 3.0F)
  let l = 0.2104542553F * lp + 0.7936177850F * mp - 0.0040720468F * sp
  let a = 1.9779984951F * lp - 2.4285922050F * mp + 0.4505937099F * sp
  let b = 0.0259040371F * lp + 0.7827717662F * mp - 0.8086757660F * sp
  (l * 100.0F, a * 100.0F, b * 100.0F)
}

///|
/// Convert HSL to RGB color space
pub fn hsl2rgb(h : Float, s : Float, l : Float) -> (Float, Float, Float) {
  let h = h / 360.0
  let s = s / 100.0
  let l = l / 100.0
  guard s != 0 else {
    let value = l * 255.0
    (value, value, value)
  }
  let t2 = if l < 0.5 { l * (1.0 + s) } else { l + s - l * s }
  let t1 : Float = 2.0 * l - t2
  let hue_to_rgb = fn(t1 : Float, t2 : Float, h : Float) -> Float {
    let h : Float = if h < 0 { h + 1.0 } else if h > 1 { h - 1.0 } else { h }
    if 6.0F * h < 1.0 {
      t1 + (t2 - t1) * 6.0 * h
    } else if 2.0F * h < 1.0 {
      t2
    } else if 3.0F * h < 2.0 {
      t1 + (t2 - t1) * (2.0 / 3.0 - h) * 6.0
    } else {
      t1
    }
  }
  let r = hue_to_rgb(t1, t2, h + 1.0 / 3.0) * 255.0
  let g = hue_to_rgb(t1, t2, h) * 255.0
  let b = hue_to_rgb(t1, t2, h - 1.0 / 3.0) * 255.0
  (r, g, b)
}

///|
/// Convert HSV to RGB color space  
pub fn hsv2rgb(h : Float, s : Float, v : Float) -> (Float, Float, Float) {
  let h = h / 60.0
  let s = s / 100.0
  let v = v / 100.0
  let hi = h.to_int() % 6
  let f = h - h.floor()
  let p : Float = 255.0 * v * (1.0 - s)
  let q : Float = 255.0 * v * (1.0 - s * f)
  let t : Float = 255.0 * v * (1.0 - s * (1.0 - f))
  let v = v * 255.0
  match hi {
    0 => (v, t, p)
    1 => (q, v, p)
    2 => (p, v, t)
    3 => (p, q, v)
    4 => (t, p, v)
    5 => (v, p, q)
    _ => (v, t, p) // default case
  }
}

///|
/// Convert HSV to HSL color space
pub fn hsv2hsl(h : Float, s : Float, v : Float) -> (Float, Float, Float) {
  let s = s / 100.0
  let v = v / 100.0
  let vmin = @cmp.maximum(v, 0.01)
  let l : Float = (2.0 - s) * v
  let lmin : Float = (2.0 - s) * vmin
  let sl = s * vmin
  let sl = sl / (if lmin <= 1.0 { lmin } else { 2.0 - lmin })
  let sl : Float = if sl.is_nan() { 0.0 } else { sl }
  let l = l / 2.0
  (h, sl * 100.0, l * 100.0)
}

///|
/// Convert HSL to HSV color space
pub fn hsl2hsv(h : Float, s : Float, l : Float) -> (Float, Float, Float) {
  let s = s / 100.0
  let l = l / 100.0
  let smin = s
  let lmin = @cmp.maximum(l, 0.01)
  let l = l * 2.0
  let s = s * (if l <= 1.0 { l } else { 2.0 - l })
  let smin = smin * (if lmin <= 1.0 { lmin } else { 2.0 - lmin })
  let v = (l + s) / 2.0
  let sv = if l == 0 { 2.0F * smin / (lmin + smin) } else { 2.0 * s / (l + s) }
  (h, sv * 100.0, v * 100.0)
}

///|
/// Convert CMYK to RGB color space
pub fn cmyk2rgb(
  c : Float,
  m : Float,
  y : Float,
  k : Float,
) -> (Float, Float, Float) {
  let c = c / 100.0
  let m = m / 100.0
  let y = y / 100.0
  let k = k / 100.0
  let r = 1.0F - @cmp.minimum(1.0, c * (1.0 - k) + k)
  let g = 1.0F - @cmp.minimum(1.0, m * (1.0 - k) + k)
  let b = 1.0F - @cmp.minimum(1.0, y * (1.0 - k) + k)
  (r * 255.0, g * 255.0, b * 255.0)
}

///|
/// Convert RGB to HWB color space
pub fn rgb2hwb(r : Float, g : Float, b : Float) -> (Float, Float, Float) {
  let (h, _, _) = rgb2hsl(r, g, b)
  let w = @cmp.minimum(r, @cmp.minimum(g, b)) / 255.0F
  let bl = 1.0F - @cmp.maximum(r, @cmp.maximum(g, b)) / 255.0F
  (h, w * 100.0F, bl * 100.0F)
}

///|
/// Convert HWB to RGB color space
pub fn hwb2rgb(h : Float, w : Float, b : Float) -> (Float, Float, Float) {
  let h = h / 360.0F
  let mut wh = w / 100.0F
  let mut bl = b / 100.0F
  let ratio = wh + bl

  // Wh + bl can't be > 1
  if ratio > 1.0F {
    wh = wh / ratio
    bl = bl / ratio
  }
  let i = (6.0F * h).floor().to_int()
  let v = 1.0F - bl
  let mut f = 6.0F * h - i.to_float()

  // Bitwise operation equivalent
  if i % 2 != 0 {
    f = 1.0F - f
  }
  let n = wh + f * (v - wh)
  let (r, g, b) = match i % 6 {
    0 => (v, n, wh)
    1 => (n, v, wh)
    2 => (wh, v, n)
    3 => (wh, n, v)
    4 => (n, wh, v)
    5 => (v, wh, n)
    _ => (v, n, wh)
  }
  (r * 255.0F, g * 255.0F, b * 255.0F)
}

///|
/// Convert RGB to HCG color space
pub fn rgb2hcg(r : Float, g : Float, b : Float) -> (Float, Float, Float) {
  let r = r / 255.0F
  let g = g / 255.0F
  let b = b / 255.0F
  let max = @cmp.maximum(@cmp.maximum(r, g), b)
  let min = @cmp.minimum(@cmp.minimum(r, g), b)
  let chroma = max - min
  let grayscale = if chroma < 1.0F { min / (1.0F - chroma) } else { 0.0F }
  let hue = if chroma <= 0.0F {
    0.0F
  } else if max == r {
    (g - b) / chroma % 6.0F
  } else if max == g {
    2.0F + (b - r) / chroma
  } else {
    4.0F + (r - g) / chroma
  }
  let hue = hue / 6.0F % 1.0F
  let hue = if hue < 0.0F { hue + 1.0F } else { hue }
  (hue * 360.0F, chroma * 100.0F, grayscale * 100.0F)
}

///|
/// Convert HCG to RGB color space
pub fn hcg2rgb(h : Float, c : Float, g : Float) -> (Float, Float, Float) {
  let h = h / 360.0F
  let c = c / 100.0F
  let g = g / 100.0F
  guard c != 0.0F else { (g * 255.0F, g * 255.0F, g * 255.0F) }
  let hi = h % 1.0F * 6.0F
  let v = hi % 1.0F
  let w = 1.0F - v
  let (pure_r, pure_g, pure_b) = match hi.floor().to_int() {
    0 => (1.0F, v, 0.0F)
    1 => (w, 1.0F, 0.0F)
    2 => (0.0F, 1.0F, v)
    3 => (0.0F, w, 1.0F)
    4 => (v, 0.0F, 1.0F)
    _ => (1.0F, 0.0F, w)
  }
  let mg = (1.0F - c) * g
  (
    (c * pure_r + mg) * 255.0F,
    (c * pure_g + mg) * 255.0F,
    (c * pure_b + mg) * 255.0F,
  )
}

///|
/// Convert RGB to XYZ color space
pub fn rgb2xyz(r : Float, g : Float, b : Float) -> (Float, Float, Float) {
  let srgb_transform = fn(c : Float) -> Float {
    let c = c / 255.0F
    if c > 0.04045F {
      ((c + 0.055F) / 1.055F).pow(2.4F)
    } else {
      c / 12.92F
    }
  }
  let r = srgb_transform(r)
  let g = srgb_transform(g)
  let b = srgb_transform(b)
  let x = r * 0.4124564F + g * 0.3575761F + b * 0.1804375F
  let y = r * 0.2126729F + g * 0.7151522F + b * 0.072175F
  let z = r * 0.0193339F + g * 0.119192F + b * 0.9503041F
  (x * 100.0F, y * 100.0F, z * 100.0F)
}

///|
/// Convert XYZ to RGB color space
pub fn xyz2rgb(x : Float, y : Float, z : Float) -> (Float, Float, Float) {
  let x = x / 100.0F
  let y = y / 100.0F
  let z = z / 100.0F
  let r = x * 3.2404542F + y * -1.5371385F + z * -0.4985314F
  let g = x * -0.969266F + y * 1.8760108F + z * 0.041556F
  let b = x * 0.0556434F + y * -0.2040259F + z * 1.0572252F
  let srgb_transform = fn(c : Float) -> Float {
    let cc = if c > 0.0031308F {
      1.055F * c.pow(1.0F / 2.4F) - 0.055F
    } else {
      c * 12.92F
    }
    @cmp.minimum(@cmp.maximum(0.0F, cc), 1.0F)
  }
  (
    srgb_transform(r) * 255.0F,
    srgb_transform(g) * 255.0F,
    srgb_transform(b) * 255.0F,
  )
}

///|
/// Convert XYZ (D65, 0-100) to OKLab (L,a,b scaled by 100)
pub fn xyz2oklab(x : Float, y : Float, z : Float) -> (Float, Float, Float) {
  let x = x / 100.0F
  let y = y / 100.0F
  let z = z / 100.0F
  let lp = (0.8189330101F * x + 0.3618667424F * y - 0.1288597137F * z)
    |> @math.cbrtf()
  let mp = (0.0329845436F * x + 0.9293118715F * y + 0.0361456387F * z)
    |> @math.cbrtf()
  let sp = (0.0482003018F * x + 0.2643662691F * y + 0.6338517070F * z)
    |> @math.cbrtf()

  // OKLab
  let l = 0.2104542553F * lp + 0.7936177850F * mp - 0.0040720468F * sp
  let a = 1.9779984951F * lp - 2.4285922050F * mp + 0.4505937099F * sp
  let b = 0.0259040371F * lp + 0.7827717662F * mp - 0.8086757660F * sp
  (l * 100.0F, a * 100.0F, b * 100.0F)
}

///|
/// Convert RGB to LAB color space
pub fn rgb2lab(r : Float, g : Float, b : Float) -> (Float, Float, Float) {
  let (x, y, z) = rgb2xyz(r, g, b)
  xyz2lab(x, y, z)
}

///|
/// Convert XYZ to LAB color space  
pub fn xyz2lab(x : Float, y : Float, z : Float) -> (Float, Float, Float) {
  let mut x = x / 95.047F
  let mut y = y / 100.0F
  let mut z = z / 108.883F
  let lab_ft = (6.0F / 29.0F).pow(3.0F)
  let lab_transform = fn(t : Float) -> Float {
    if t > lab_ft {
      t.pow(1.0F / 3.0F)
    } else {
      7.787F * t + 16.0F / 116.0F
    }
  }
  x = lab_transform(x)
  y = lab_transform(y)
  z = lab_transform(z)
  let l = 116.0F * y - 16.0F
  let a = 500.0F * (x - y)
  let b = 200.0F * (y - z)
  (l, a, b)
}

///|
/// Convert LAB to XYZ color space
pub fn lab2xyz(l : Float, a : Float, b : Float) -> (Float, Float, Float) {
  let mut y = (l + 16.0F) / 116.0F
  let mut x = a / 500.0F + y
  let mut z = y - b / 200.0F
  let lab_ft = (6.0F / 29.0F).pow(3.0F)
  let lab_transform_inv = fn(t : Float) -> Float {
    let t3 = t.pow(3.0F)
    if t3 > lab_ft {
      t3
    } else {
      (t - 16.0F / 116.0F) / 7.787F
    }
  }
  x = lab_transform_inv(x) * 95.047F
  y = lab_transform_inv(y) * 100.0F
  z = lab_transform_inv(z) * 108.883F
  (x, y, z)
}

///|
/// Convert LAB to LCH color space
pub fn lab2lch(l : Float, a : Float, b : Float) -> (Float, Float, Float) {
  let hr = @math.atan2f(b, a)
  let mut h = hr * 360.0F / 2.0F / 3.141592653589793F
  if h < 0.0F {
    h = h + 360.0F
  }
  let c = (a * a + b * b).sqrt()
  (l, c, h)
}

///|
/// Convert LCH to LAB color space
pub fn lch2lab(l : Float, c : Float, h : Float) -> (Float, Float, Float) {
  let hr = h / 360.0F * 2.0F * 3.141592653589793F
  let a = c * @math.cosf(hr)
  let b = c * @math.sinf(hr)
  (l, a, b)
}

///|
/// Convert RGB to Gray
pub fn rgb2gray(r : Float, g : Float, b : Float) -> Float {
  (r + g + b) / 3.0F / 255.0F * 100.0F
}

///|
/// Convert Gray to RGB
pub fn gray2rgb(gray : Float) -> (Float, Float, Float) {
  let value = gray / 100.0F * 255.0F
  (value, value, value)
}

///|
/// Convert HEX string (#RGB, #RRGGBB, RGB, or RRGGBB) to RGB (Float components 0-255)
pub fn hex2rgb(hex : String) -> (Float, Float, Float) raise {
  guard hex.length() != 0 else { (0.0F, 0.0F, 0.0F) }
  let mut s = if hex.has_prefix("#") { hex[1:] } else { hex }
  if s.length() == 3 {
    let r = s[0:1]
    let g = s[1:2]
    let b = s[2:3]
    s = r + r + g + g + b + b
  }
  guard s.length() == 6 else { (0.0F, 0.0F, 0.0F) }
  let hex_val = fn(c : Char) -> Int {
    match c {
      '0' => 0
      '1' => 1
      '2' => 2
      '3' => 3
      '4' => 4
      '5' => 5
      '6' => 6
      '7' => 7
      '8' => 8
      '9' => 9
      'a' | 'A' => 10
      'b' | 'B' => 11
      'c' | 'C' => 12
      'd' | 'D' => 13
      'e' | 'E' => 14
      'f' | 'F' => 15
      _ => 0
    }
  }
  let pair = fn(i : Int) -> Int {
    let hi = hex_val(s.get_char(i).unwrap())
    let lo = hex_val(s.get_char(i + 1).unwrap())
    hi * 16 + lo
  }
  let r = pair(0).to_float()
  let g = pair(2).to_float()
  let b = pair(4).to_float()
  (r, g, b)
}

///|
/// Convert RGB (0-255) to Apple 16-bit RGB (0-65535)
pub fn rgb2apple(r : Float, g : Float, b : Float) -> (Float, Float, Float) {
  let f = 257.0F // 65535 / 255
  (r * f, g * f, b * f)
}

///|
/// Convert Apple 16-bit RGB (0-65535) to 8-bit RGB (0-255)
pub fn apple2rgb(r : Float, g : Float, b : Float) -> (Float, Float, Float) {
  let f = 257.0F
  (r / f, g / f, b / f)
}

///|
/// Convert OKLab to OKLCH
pub fn oklab2oklch(l : Float, a : Float, b : Float) -> (Float, Float, Float) {
  lab2lch(l, a, b)
}

///|
/// Convert OKLCH to OKLab
pub fn oklch2oklab(l : Float, c : Float, h : Float) -> (Float, Float, Float) {
  lch2lab(l, c, h)
}

///|
/// Convert OKLab (L,a,b scaled by 100) to XYZ (D65, 0-100)
pub fn oklab2xyz(
  l_val : Float,
  a_val : Float,
  b_val : Float,
) -> (Float, Float, Float) {
  let ll = l_val / 100.0F
  let a = a_val / 100.0F
  let b = b_val / 100.0F
  let l = 0.999999998F * ll + 0.396337792F * a + 0.215803758F * b
  let m = 1.000000008F * ll - 0.105561342F * a - 0.063854175F * b
  let s = 1.000000055F * ll - 0.089484182F * a - 1.291485538F * b
  let l3 = l * l * l
  let m3 = m * m * m
  let s3 = s * s * s
  let x = 1.227013851F * l3 - 0.557799980F * m3 + 0.281256149F * s3
  let y = -0.040580178F * l3 + 1.112256870F * m3 - 0.071676679F * s3
  let z = -0.076381285F * l3 - 0.421481978F * m3 + 1.586163220F * s3
  (x * 100.0F, y * 100.0F, z * 100.0F)
}

///|
/// Convert OKLab (L,a,b scaled by 100) to RGB (sRGB 0-255)
pub fn oklab2rgb(
  l_val : Float,
  a_val : Float,
  b_val : Float,
) -> (Float, Float, Float) {
  let ll = l_val / 100.0F
  let aa = a_val / 100.0F
  let bb = b_val / 100.0F
  let l = ll + 0.3963377774F * aa + 0.2158037573F * bb
  let m = ll - 0.1055613458F * aa - 0.0638541728F * bb
  let s = ll - 0.0894841775F * aa - 1.2914855480F * bb
  let l3 = l * l * l
  let m3 = m * m * m
  let s3 = s * s * s
  let r_lin = 4.0767416621F * l3 - 3.3077115913F * m3 + 0.2309699292F * s3
  let g_lin = -1.2684380046F * l3 + 2.6097574011F * m3 - 0.3413193965F * s3
  let b_lin = -0.0041960863F * l3 - 0.7034186147F * m3 + 1.7076147010F * s3
  let r = srgb_nonlinear_transform(r_lin)
  let g = srgb_nonlinear_transform(g_lin)
  let b = srgb_nonlinear_transform(b_lin)
  (r * 255.0F, g * 255.0F, b * 255.0F)
}