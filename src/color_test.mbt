///|
test "simple" {
  inspect(rgb2hsv(255, 0, 0), content="(0, 100, 100)") // (0, 100, 100)
  inspect(rgb2hsv(12, 12, 12), content="(0, 0, 4.705882549285889)")
  inspect(
    rgb2hsv(12, 12, 121),
    content="(240, 90.0826416015625, 47.45098114013672)",
  )
}

///|
test "rgb2hsv" {
  inspect(rgb2hsv(255.0F, 0.0F, 0.0F), content="(0, 100, 100)")
  inspect(rgb2hsv(12.0F, 12.0F, 12.0F), content="(0, 0, 4.705882549285889)")
  inspect(
    rgb2hsv(12.0F, 12.0F, 121.0F),
    content="(240, 90.0826416015625, 47.45098114013672)",
  )
}

///|
test "rgb2hsl" {
  inspect(
    rgb2hsl(140.0F, 200.0F, 100.0F),
    content="(95.99999237060547, 47.61904525756836, 58.82353210449219)",
  )
  inspect(rgb2hsl(0.0F, 0.0F, 0.0F), content="(0, 0, 0)")
  inspect(rgb2hsl(255.0F, 255.0F, 255.0F), content="(0, 0, 100)")
}

///|
test "rgb2cmyk" {
  inspect(
    rgb2cmyk(140.0F, 200.0F, 100.0F),
    content="(29.999998092651367, 0, 50.00000762939453, 21.568626403808594)",
  )
  inspect(rgb2cmyk(0.0F, 0.0F, 0.0F), content="(0, 0, 0, 100)")
  inspect(rgb2cmyk(255.0F, 255.0F, 255.0F), content="(0, 0, 0, 0)")
}

///|
test "rgb2hex" {
  inspect(rgb2hex(92.0F, 191.0F, 84.0F), content="5CBF54")
  inspect(rgb2hex(255.0F, 255.0F, 255.0F), content="FFFFFF")
  inspect(rgb2hex(0.0F, 0.0F, 0.0F), content="000000")
  inspect(rgb2hex(171.0F, 205.0F, 239.0F), content="ABCDEF")
}

///|
test "hex2rgb" {
  inspect(hex2rgb("ABCDEF"), content="(171, 205, 239)")
  inspect(hex2rgb("AABBCC"), content="(170, 187, 204)")
  inspect(hex2rgb("ABC"), content="(170, 187, 204)")
  inspect(hex2rgb("#FFFFFF"), content="(255, 255, 255)")
  inspect(hex2rgb("000000"), content="(0, 0, 0)")
}

///|
test "hsl2rgb" {
  inspect(
    hsl2rgb(96.0F, 48.0F, 59.0F),
    content="(140.41319274902344, 200.63397216796875, 100.26600646972656)",
  )
  inspect(hsl2rgb(0.0F, 0.0F, 0.0F), content="(0, 0, 0)")
  inspect(hsl2rgb(240.0F, 100.0F, 50.0F), content="(0, 0, 255)")
}

///|
test "hsv2rgb" {
  inspect(
    hsv2rgb(96.0F, 50.0F, 78.0F),
    content="(139.22999572753906, 198.89999389648438, 99.44999694824219)",
  )
  inspect(hsv2rgb(0.0F, 0.0F, 0.0F), content="(0, 0, 0)")
  inspect(hsv2rgb(240.0F, 100.0F, 100.0F), content="(0, 0, 255)")
}

///|
test "cmyk2rgb" {
  inspect(
    cmyk2rgb(30.0F, 0.0F, 50.0F, 22.0F),
    content="(139.22999572753906, 198.89999389648438, 99.44999694824219)",
  )
  inspect(cmyk2rgb(0.0F, 0.0F, 0.0F, 100.0F), content="(0, 0, 0)")
  inspect(cmyk2rgb(0.0F, 0.0F, 0.0F, 0.0F), content="(255, 255, 255)")
}

///|
test "rgb2hwb" {
  inspect(
    rgb2hwb(140.0F, 200.0F, 100.0F),
    content="(95.99999237060547, 39.2156867980957, 21.568626403808594)",
  )
  inspect(rgb2hwb(255.0F, 0.0F, 0.0F), content="(0, 0, 0)")
  inspect(rgb2hwb(0.0F, 0.0F, 0.0F), content="(0, 0, 100)")
}

///|
test "hwb2rgb" {
  inspect(
    hwb2rgb(96.0F, 39.0F, 22.0F),
    content="(139.22998046875, 198.89999389648438, 99.44999694824219)",
  )
  inspect(hwb2rgb(0.0F, 0.0F, 0.0F), content="(255, 0, 0)")
  inspect(hwb2rgb(0.0F, 0.0F, 100.0F), content="(0, 0, 0)")
  inspect(hwb2rgb(0.0F, 100.0F, 0.0F), content="(255, 255, 255)")
}

///|
test "rgb2hcg" {
  inspect(
    rgb2hcg(140.0F, 200.0F, 100.0F),
    content="(95.99999237060547, 39.2156867980957, 64.51612854003906)",
  )
  inspect(rgb2hcg(255.0F, 0.0F, 0.0F), content="(0, 100, 0)")
  inspect(rgb2hcg(128.0F, 128.0F, 128.0F), content="(0, 0, 50.196083068847656)")
}

///|
test "hcg2rgb" {
  inspect(
    hcg2rgb(96.0F, 39.0F, 64.0F),
    content="(139.3319854736328, 199.0019989013672, 99.55199432373047)",
  )
  inspect(hcg2rgb(0.0F, 100.0F, 0.0F), content="(255, 0, 0)")
  inspect(hcg2rgb(0.0F, 0.0F, 50.0F), content="(127.5, 127.5, 127.5)")
}

///|
test "rgb2xyz" {
  inspect(
    rgb2xyz(92.0F, 191.0F, 84.0F),
    content="(24.643476486206055, 40.17508316040039, 14.841747283935547)",
  )
  inspect(
    rgb2xyz(255.0F, 255.0F, 255.0F),
    content="(95.04700469970703, 100.00001525878906, 108.88299560546875)",
  )
  inspect(rgb2xyz(0.0F, 0.0F, 0.0F), content="(0, 0, 0)")
}

///|
test "xyz2rgb" {
  inspect(
    xyz2rgb(25.0F, 40.0F, 15.0F),
    content="(97.3629379272461, 189.90150451660156, 85.01932525634766)",
  )
  inspect(
    xyz2rgb(95.0F, 100.0F, 109.0F),
    content="(254.76373291015625, 255, 255)",
  )
  inspect(xyz2rgb(0.0F, 0.0F, 0.0F), content="(0, 0, 0)")
}

///|
test "rgb2lab" {
  inspect(
    rgb2lab(92.0F, 191.0F, 84.0F),
    content="(69.59405517578125, -50.11084747314453, 44.64682388305664)",
  )
  inspect(rgb2lab(255.0F, 255.0F, 255.0F), content="(100, 0, 0)")
  inspect(rgb2lab(0.0F, 0.0F, 0.0F), content="(0, 0, 0)")
}

///|
test "lab2lch" {
  inspect(
    lab2lch(69.0F, -48.0F, 44.0F),
    content="(69, 65.11528015136719, 222.51043701171875)",
  )
  inspect(lab2lch(100.0F, 0.0F, 0.0F), content="(100, 0, 0)")
}

///|
test "lch2lab" {
  inspect(
    lch2lab(69.0F, 65.0F, 137.0F),
    content="(69, -47.53799057006836, 44.329891204833984)",
  )
  inspect(lch2lab(100.0F, 0.0F, 0.0F), content="(100, 0, 0)")
}

///|
test "rgb2gray" {
  inspect(rgb2gray(0.0F, 0.0F, 0.0F), content="0")
  inspect(rgb2gray(128.0F, 128.0F, 128.0F), content="50.196083068847656")
  inspect(rgb2gray(255.0F, 255.0F, 255.0F), content="100")
}

///|
test "gray2rgb" {
  inspect(gray2rgb(0.0F), content="(0, 0, 0)")
  inspect(gray2rgb(50.0F), content="(127.5, 127.5, 127.5)")
  inspect(gray2rgb(100.0F), content="(255, 255, 255)")
}

///|
test "hsv2hsl" {
  inspect(
    hsv2hsl(96.0F, 50.0F, 78.0F),
    content="(96, 46.98794937133789, 58.499996185302734)",
  )
  inspect(hsv2hsl(0.0F, 0.0F, 0.0F), content="(0, 0, 0)")
  inspect(hsv2hsl(240.0F, 100.0F, 100.0F), content="(240, 100, 50)")
}

///|
test "hsl2hsv" {
  inspect(
    hsl2hsv(96.0F, 48.0F, 59.0F),
    content="(96, 50.025421142578125, 78.68000030517578)",
  )
  inspect(hsl2hsv(0.0F, 0.0F, 0.0F), content="(0, 0, 0)")
  inspect(hsl2hsv(240.0F, 100.0F, 50.0F), content="(240, 100, 100)")
}

///|
test "hwb_extreme_values" {
  // Test extreme HWB values - should give black, white, or grey
  inspect(hwb2rgb(0.0F, 0.0F, 100.0F), content="(0, 0, 0)") // Black
  inspect(hwb2rgb(0.0F, 100.0F, 0.0F), content="(255, 255, 255)") // White  
  inspect(hwb2rgb(0.0F, 100.0F, 100.0F), content="(127.5, 127.5, 127.5)") // Grey

  // Test specific angles
  inspect(hwb2rgb(120.0F, 0.0F, 0.0F), content="(0, 255, 0)") // Green
  inspect(hwb2rgb(240.0F, 0.0F, 0.0F), content="(0, 0, 255)") // Blue
}

// Additional coverage tests

///|
fn close(a : Float, b : Float, eps : Float) -> Bool {
  let d = a - b
  let d = if d < 0.0F { -d } else { d }
  d < eps
}

///|
test "name_lookup_and_keyword" {
  inspect(name2rgb("ReD"), content="(255, 0, 0)")
  match rgb2keyword(255.0F, 255.0F, 255.0F) {
    Some(name) => inspect(name, content="white")
    None => inspect("", content="white")
  }
}

///|
test "hex2rgb_invalid_inputs" {
  inspect(hex2rgb(""), content="(0, 0, 0)")
  inspect(hex2rgb("FFFFF"), content="(0, 0, 0)")
  inspect(hex2rgb("ZZZZZZ"), content="(0, 0, 0)")
}

///|
test "apple_roundtrip" {
  let (ar, ag, ab) = rgb2apple(255.0F, 0.0F, 128.0F)
  inspect(ar, content="65535")
  inspect(ag, content="0")
  inspect(ab, content="32896")
  let (rr, gg, bb) = apple2rgb(ar, ag, ab)
  // Back to original 8-bit values
  inspect(rr, content="255")
  inspect(gg, content="0")
  inspect(bb, content="128")
}

///|
test "oklab_roundtrip" {
  let rgb = (92.0F, 191.0F, 84.0F)
  let (l, a, b) = rgb2oklab(rgb.0, rgb.1, rgb.2)
  let (r2, g2, b2) = oklab2rgb(l, a, b)
  inspect(close(rgb.0, r2, 1.0F), content="true")
  inspect(close(rgb.1, g2, 1.0F), content="true")
  inspect(close(rgb.2, b2, 1.0F), content="true")
}

///|
test "oklab_xyz_consistency" {
  let (r, g, b) = (140.0F, 200.0F, 100.0F)
  let (x, y, z) = rgb2xyz(r, g, b)
  let (l1, a1, b1) = rgb2oklab(r, g, b)
  let (l2, a2, b2) = xyz2oklab(x, y, z)
  inspect(close(l1, l2, 0.25F), content="true")
  inspect(close(a1, a2, 0.25F), content="true")
  inspect(close(b1, b2, 0.25F), content="true")
}

///|
test "oklch_roundtrip" {
  let (l, a, b) = rgb2oklab(92.0F, 191.0F, 84.0F)
  let (lch_l, lch_c, lch_h) = oklab2oklch(l, a, b)
  let (ll, aa, _bb) = oklch2oklab(lch_l, lch_c, lch_h)
  inspect(close(l, ll, 0.5F), content="true")
  inspect(close(a, aa, 0.5F), content="true")
}

///|
test "lab_xyz_roundtrip" {
  let (l, a, b) = rgb2lab(92.0F, 191.0F, 84.0F)
  let (x, y, z) = lab2xyz(l, a, b)
  let (l2, a2, b2) = xyz2lab(x, y, z)
  inspect(close(l, l2, 0.5F), content="true")
  inspect(close(a, a2, 0.5F), content="true")
  inspect(close(b, b2, 0.5F), content="true")
}
