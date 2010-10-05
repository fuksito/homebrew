require 'formula'

class Clisp <Formula
  url 'http://ftp.gnu.org/pub/gnu/clisp/release/2.49/clisp-2.49.tar.bz2'
  homepage 'http://clisp.cons.org/'
  md5 '1962b99d5e530390ec3829236d168649'

  depends_on 'readline'
  depends_on 'libsigsegv'

  def install
    # This build isn't parallel safe.
    ENV.j1
    # Clisp will handle optimization flags by its own.
    ENV.no_optimization
    # This build is i386 only, because it uses inline asm.
    # ENV.m32 doesn't work, this is from http://trac.macports.org/browser/trunk/dports/lang/clisp/Portfile
    ENV['CC'] = "#{ENV.cc} -arch i386"

    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=yes"
    cd "src" do
      system "ulimit -s 16384 && make"
      system "make check"
      system "make install"
    end
  end
end
