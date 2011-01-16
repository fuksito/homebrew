require 'formula'

class Tidy <Formula
  url 'ftp://mirror.internode.on.net/pub/gentoo/distfiles/tidy-20090325.tar.bz2'
  homepage 'http://tidy.sourceforge.net/'
  md5 '39a05125a2a2dbacaccac84af64e1dbc'
  head 'cvs://:pserver:anonymous@tidy.cvs.sourceforge.net:/cvsroot/tidy:tidy'

  keg_only :provided_by_osx

  def install
    system 'sh', 'build/gnuauto/setup.sh'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}",
                          "--includedir=#{prefix}/include/tidy"
    system "make", "install"
  end
end