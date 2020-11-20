locals {
  binary = {
    "10" = parseint("10",2)
    "1111" = parseint("1111",2)
    "10100111001" = parseint("10100111001",2)
  }

  hexa = {
    "F" = parseint("F",16)
    "10" = parseint("10",16)
    "AA" = parseint("AA",16)
    "FF" = parseint("FF",16)
    "ff" = parseint("ff",16)
    "2A3F" = parseint("2A3F",16)
    "2a3f" = parseint("2a3f",16)
  }

  base36 = {
    "K" = parseint("K",37)
    "Q" = parseint("Q",37)
    "k" = parseint("k",37)
    "q" = parseint("q",37)
    "hello" = parseint("hello",36)
    "thisisaverylongtext" = parseint("thisisaverylongtext",36)
  }

  base62 = {
    "K" = parseint("K",62)
    "Q" = parseint("Q",62)
    "k" = parseint("k",62)
    "q" = parseint("q",62)
    "hello" = parseint("hello",62)
    "thisisaverylongtext" = parseint("thisisaverylongtext",62)
  }
}

output "base_2" {
  value = local.binary.*
}

output "base_16" {
  value = local.hexa.*
}

output "base_36" {
  value = local.base36.*
}

output "base_62" {
  value = local.base62.*
}
