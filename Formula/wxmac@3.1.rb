class WxmacAT31 < Formula
  desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.5/wxWidgets-3.1.5.tar.bz2"
  sha256 "d7b3666de33aa5c10ea41bb9405c40326e1aeb74ee725bb88f90f1d50270a224"
  license "wxWindows"
  head "https://github.com/wxWidgets/wxWidgets.git"

  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f8d6ccae11c8d99b893e2605ca272a376a374faac8864304d1cdf544c6152421"
    sha256 cellar: :any, big_sur:       "95b66fefa42f869430da0597abb27500d551d5f99662e285c4f0d3a9e2800bdf"
    sha256 cellar: :any, catalina:      "110aa0b2134d8bff1647de0cd8500f160133794b347f789bba3e1894b991b788"
    sha256 cellar: :any, mojave:        "5f703423fc3f1e36d647a2d8be2d271a92f5d60f49ceba8e3478391bbd4f5303"
    sha256 cellar: :any, high_sierra:   "1de8aa03e1c50af387888ffa51cfa4e0c99d158f25edb0acbf312e10c629a31d"
  end

  keg_only :versioned_formula

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+"
    depends_on "libsm"
    depends_on "mesa-glu"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webview",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-osx",
      "--with-zlib",
      "--with-libcurl",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
    ]

    on_macos do
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      args << "--with-macosx-version-min=#{MacOS.version}"
      args << "--with-osx_cocoa"
    end

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxmac's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxmac and wxpython headers,
    # which are linked to the same place
    inreplace "#{bin}/wx-config", prefix, HOMEBREW_PREFIX
  end

  test do
    system bin/"wx-config", "--libs"
  end
end
