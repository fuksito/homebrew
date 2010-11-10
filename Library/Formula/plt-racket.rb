require 'formula'

class PltRacket <Formula
  # Use GitHub; tarball doesn't have everything needed for building on OS X
  head 'git://github.com/plt/racket.git'
  url 'https://github.com/plt/racket/zipball/v5.0.2'
  homepage 'http://racket-lang.org/'

  # Don't sttip symbols; need them for dynamic linking.
  skip_clean 'bin'

  def install
    Dir.chdir 'src' do
      args = ["--disable-debug", "--disable-dependency-tracking",
              "--enable-xonx",
              "--enable-shared",
              "--prefix=#{prefix}" ]

      if snow_leopard_64?
        args += ["--enable-mac64", "--enable-sgc", "--disable-gracket"]
      end

      system "./configure", *args
      system "make"
      ohai   "Installing might take a long time (~40 minutes)"
      system "make install"
    end
  end
end
