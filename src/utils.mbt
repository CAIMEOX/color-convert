///|
fn int2hex(i : Int) -> String {
  guard i != 0 else { "0" }
  let mut result = ""
  let mut n = i
  while n > 0 {
    let digit = n % 16
    let char = match digit {
      i if i <= 9 => i.to_string()
      10 => "a"
      11 => "b"
      12 => "c"
      13 => "d"
      14 => "e"
      15 => "f"
      _ => "0"
    }
    result = char + result
    n = n / 16
  }
  result
}

///|
fn srgb_nonlinear_transform_inv(c : Float) -> Float {
  if c <= 0.04045F {
    c / 12.92F
  } else {
    @math.powf((c + 0.055F) / 1.055F, 2.4F)
  }
}

fn srgb_nonlinear_transform(c : Float) -> Float {
  if c <= 0.0031308F { 12.92F * c } else { 1.055F * c.pow(1.0F / 2.4F) - 0.055F }
}