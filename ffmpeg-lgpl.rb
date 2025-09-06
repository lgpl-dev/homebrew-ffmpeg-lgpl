# typed: strict
# frozen_string_literal: true

# Homebrew formula for FFmpeg with only LGPL-compatible libraries enabled.
# This formula provides a non-GPL, non-free version of FFmpeg.
class FfmpegLgpl < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-8.0.tar.xz"
  sha256 "b2751fccb6cc4c77708113cd78b561059b6fa904b24162fa0be2d60273d27b8e"
  # This formula is configured to only enable libraries with an LGPL-compatible license.
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/FFmpeg/FFmpeg.git", branch: "master"

  # ここにbottleブロックを追加
  bottle do
    root_url "https://github.com/lgpl-dev/homebrew-ffmpeg-lgpl/releases/download/v8.0_1"
    sha256 arm64_sequoia: "902430338339abf0ae82a60268e5c5fae4ab623f01d1050b3eec8773fa928d91"
  end

  bottle do
    root_url "https://github.com/lgpl-dev/homebrew-ffmpeg-lgpl/releases/download/v8.0_1"
    sha256 arm64_sequoia: "902430338339abf0ae82a60268e5c5fae4ab623f01d1050b3eec8773fa928d91"    
    sha256 arm64_sonoma:  "22bbbe0eb3014af09772c29416750ab70226a6a9783545687a2979dc3235bd7a"
    sha256 arm64_ventura: "060fe8d538f8a205a4cc0087c60797aef7bb6e0a91fcd0a0883e0b5e44dfd5c7"
    sha256 sonoma:        ""
    sha256 ventura:       "060fe8d538f8a205a4cc0087c60797aef7bb6e0a91fcd0a0883e0b5e44dfd5c7"
  end

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "pkgconf" => :build
  depends_on "aom"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "jpeg-xl"
  depends_on "libass"
  depends_on "libssh"
  depends_on "libvmaf"
  depends_on "libvorbis"
  depends_on "openjpeg"
  depends_on "opus"
  depends_on "tesseract"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libarchive"
    depends_on "libogg"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxext"
    depends_on "libxv"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  # Fix for QtWebEngine, do not remove
  # https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=270209
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/ffmpeg/-/raw/5670ccd86d3b816f49ebc18cab878125eca2f81f/add-av_stream_get_first_dts-for-chromium.patch"
    sha256 "57e26caced5a1382cb639235f9555fc50e45e7bf8333f7c9ae3d49b3241d3f77"
  end

  def install
    # The new linker leads to duplicate symbol issue https://github.com/homebrew-ffmpeg/homebrew-ffmpeg/issues/140
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --disable-version3
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --disable-gnutls
      --disable-gpl
      --disable-nonfree
      --enable-libaom
      --disable-libaribb24
      --disable-libbluray
      --disable-libdav1d
      --enable-libharfbuzz
      --enable-libjxl
      --disable-libmp3lame
      --enable-libopus
      --disable-librav1e
      --disable-librist
      --disable-librubberband
      --disable-libsnappy
      --disable-libsrt
      --enable-libssh
      --disable-libsvtav1
      --enable-libtesseract
      --disable-libtheora
      --disable-libvidstab
      --enable-libvmaf
      --enable-libvorbis
      --disable-libvpx
      --enable-libwebp
      --disable-libx264
      --disable-libx265
      --enable-libxml2
      --disable-libxvid
      --enable-lzma
      --enable-libfontconfig
      --enable-libfreetype
      --disable-frei0r
      --enable-libass
      --disable-libopencore-amrnb
      --disable-libopencore-amrwb
      --enable-libopenjpeg
      --disable-libspeex
      --disable-libsoxr
      --disable-libzmq
      --disable-libzimg
      --disable-libjack
      --disable-indev=jack
    ]

    # Needs corefoundation, coremedia, corevideo
    args += %w[--enable-videotoolbox --enable-audiotoolbox] if OS.mac?
    args << "--enable-neon" if Hardware::CPU.arm?

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install (buildpath/"tools").children.select { |f| f.file? && f.executable? }
    pkgshare.install buildpath/"tools/python"
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_path_exists mp4out
  end
end
