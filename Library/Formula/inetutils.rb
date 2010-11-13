require 'formula'

class Inetutils <Formula
  url 'http://ftp.gnu.org/gnu/inetutils/inetutils-1.8.tar.gz'
  homepage 'http://www.gnu.org/software/inetutils/'
  md5 ''

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
