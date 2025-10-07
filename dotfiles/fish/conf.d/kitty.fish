set -gx TERM xterm-kitty

# Show images in kitty terminal
alias icat="kitty +kitten icat"
alias rg="rg --hyperlink-format=kitty"

bind \ct 'kitty @ get-text --extent=last_non_empty_output | kitten clipboard'
