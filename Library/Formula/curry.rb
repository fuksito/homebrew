require 'formula'

class Curry <Formula
  url 'http://danae.uni-muenster.de/~lux/curry/download/curry-0.9.11/curry-0.9.11.tar.gz'
  homepage 'http://danae.uni-muenster.de/~lux/curry/'
  md5 '70c9b8bf97198324a5da71164532ff9a'

  depends_on 'ghc'

  def install
    ENV.m32
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
