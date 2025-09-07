export TERMINAL=kitty
# Some have success with these instead:
#export GDK_DPI_SCALE=1.5
#export QT_SCALE_FACTOR=1.5

# This leads to a blurry display.
#xrandr --output eDP --scale 0.666 --dpi 256
xrandr --output eDP --scale 1 --dpi 192

# Xresources isn't integrated by default.
# Have to check why.
xrdb -merge ~/.Xresources

# Polybar doesn't pick up the one from Xresources.
xsetroot -cursor_name left_ptr

. ~/.profile
exec herbstluftwm --locked
