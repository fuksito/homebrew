require 'formula'

class Diffutils <Formula
  url 'http://ftp.gnu.org/gnu/diffutils/diffutils-3.0.tar.gz'
  homepage 'http://www.gnu.org/software/diffutils/'
  md5 ''

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
