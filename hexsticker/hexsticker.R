#Import necessary packages
library(hexSticker)
library(here)
library(showtext)

# Loading Google fonts
font_add_google("Gochi Hand", "gochi")
#Automatically use showtext to render text for future device
showtext_auto()

sticker(here("icon_pkg.png"), package = "olympics", p_size = 25, p_y = 1.5, s_x = 1.05, s_y =0.8, s_width = .4, s_height = .2, h_fill = "#FFFFFF",p_color = "black",p_family = "gochi", filename = here("sticker.png"), h_color = "#d8b365")

