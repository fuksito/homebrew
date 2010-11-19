require 'formula'

class Crack <Formula
  url 'http://crack-language.googlecode.com/files/crack-0.2.1.tar.gz'
  homepage 'http://code.google.com/p/crack-language/'
  md5 '5792b9644848526530de858ce2289998'

  depends_on 'llvm' # must build with --rtti
  depends_on 'spug'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
