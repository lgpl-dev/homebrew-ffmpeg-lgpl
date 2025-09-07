# ffmpeg-lgpl

cf. https://github.com/Homebrew/homebrew-core/blob/main/Formula/f/ffmpeg.rb

### uninstall

```
brew uninstall ffmpeg-lgpl
brew untap lgpl-dev/ffmpeg-lgpl
```

### install

```
brew tap lgpl-dev/ffmpeg-lgpl
brew install ffmpeg-lgpl
```

### pathch

```
diff -u ffmpeg.rb ffmpeg-lgpl.rb > gpl2lgpl.patch
```

```
patch -o ffmpeg-lgpl.rb ffmpeg.rb gpl2lgpl.patch
```
