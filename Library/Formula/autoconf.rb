require 'formula'

class Autoconf <Formula
  url 'http://ftp.gnu.org/gnu/autoconf/autoconf-2.68.tar.bz2'
  homepage 'http://www.gnu.org/software/autoconf'
  md5 '864d785215aa60d627c91fcb21b05b07'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
