require 'formula'

class Openssh <Formula
  url 'ftp://ftp.lambdaserver.com/pub/OpenBSD/OpenSSH/portable/openssh-5.6p1.tar.gz'
  homepage 'http://www.openssh.com/'
  md5 'e6ee52e47c768bf0ec42a232b5d18fb0'
  version '5.6p1'

  def patches
    "http://www.psc.edu/networking/projects/hpn-ssh/openssh-5.6p1-hpn13v10.diff.gz" if ARGV.include? '--enable-hpn'
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--with-libedit", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
