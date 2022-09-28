x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, 'C[LX]+')
str_view(x, "C{2}")
str_view(x, "C{2,3}")
str_view(x, 'C{2,3}?')
str_view(x, 'C[LX]+?')
str_view(fruit, "(..)\\1", match = TRUE)

str_view("21.21", "\\d{1,2}", match = TRUE)


deg <- c("9◦ 34\004 e", "52°07 n", "53°13′n", "52◦ 31’n", "08°16 w", "54.18◦ n",
         "9.59 °w", "n54:41:1", "6.7 8C", "568570N", "568570 n", "28440 e", "52° 8′ N ", 
         "53 410 000 N", "2 580 000 W", "55°02.5′N", "54° 1′50” N", "458380 N", "54.18◦N")

length(deg)

coord <- str_extract(deg, "\\d{1,2}.*(◦|°|\\.||8?|:).*[NSEWnsew]")
coord
coord1 <- str_extract(deg, "[NSEWnsew].?(\\d{1,2})(◦|°|\\.||8|:).+")
coord1


degrees <- str_extract(coord, "\\d{1,2}.?(◦|°|\\.||..8|:)?")
degrees1 <- ifelse(str_detect(degrees, "\\d{2}8$"), parse_number(str_sub(degrees, 1,2)), parse_number(degrees))
degrees1
point <- str_extract(deg, "[NSEWnsew]")
point
str_extract(coord, "(◦|°|\\.||:).*") |>
  parse_number()
