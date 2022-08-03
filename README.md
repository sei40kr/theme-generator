# theme-generator

Generate themes for various tools from a Vim colorscheme!

## Usage

```
./generate --rtp         <runtime path> \
           --colorscheme <colorscheme> \
           --out-name    <output name> \
           [--setup-hook <setup hook>]
```

### Example

```sh
./generate --rtp         /path/to/tokyonight.nvim \
           --colorscheme tokyonight \
           --out-name    tokyonight_night \
           --setup-hook  'let g:tokyonight_style = "night"'
```

## Supported Tools

- [x] [tmux](https://github.com/tmux/tmux)
- [ ] [alacritty](https://github.com/alacritty/alacritty) TODO
- [ ] [bat](https://github.com/sharkdp/bat) TODO
- [ ] [delta](https://github.com/dandavison/delta) TODO
- [ ] [fzf](https://github.com/junegunn/fzf) TODO
- [ ] [kitty](https://github.com/kovidgoyal/kitty) TODO
- [ ] [ranger](https://github.com/ranger/ranger) TODO
- [ ] [tmux-baseline](https://github.com/sei40kr/tmux-baseline) TODO

## License

MIT
