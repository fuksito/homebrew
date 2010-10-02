require 'formula'

class Jacl <Formula
  url 'http://downloads.sourceforge.net/project/tcljava/jacl/1.4.1/jacl1.4.1.tar.gz'
  version '1.4.1'
  homepage 'http://tcljava.sourceforge.net/'
  md5 'a7ec8300e8933164e854460c73ac6269'

  def install
    system "./configure", "--prefix=#{prefix}"
    inreplace "Makefile", "mkdir ", "mkdir -p "
    system "make"
    system "make install"
    system "make tjc2"
    system "make install"
  end
end
