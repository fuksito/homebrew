require 'formula'

class Nasm <Formula
  url 'http://www.nasm.us/pub/nasm/releasebuilds/2.09.04/nasm-2.09.04.tar.bz2'
  homepage 'http://www.nasm.us/'
  md5 'c11f083a501adae843d0bc3e7c106c73'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
