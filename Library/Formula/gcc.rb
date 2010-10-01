require 'formula'

class Gcc <Formula
  url 'http://ftp.gnu.org/gnu/gcc/gcc-4.5.1/gcc-4.5.1.tar.bz2'
  homepage 'http://gcc.gnu.org'
  md5 '48231a8e33ed6e058a341c53b819de1a'

  depends_on 'autoconf' # >= 2.64
  depends_on 'automake' # >= 1.11.1
  depends_on 'gmp'      # >= 4.3.2
  depends_on 'mpfr'     # >= 2.4.2
  depends_on 'libmpc'   # >= 0.8.1

  # FIXME: I don't know ruby, and I am sure this is a much more elegant solution for this.
  def options
    ret = Array.new
    %w[c objc c++ obj-c++ java fortran].each do |e|
      ret << ["--enable-#{e}", "enable #{e} language support"]
      ret << ["--disable-#{e}", "disable #{e} language support"]
    end
    return ret
  end

  def install
    # Remove the built in flags to get it to build properly
    # TODO: LDFLAGS and CPPFLAGS probably don't need to be in here
    %w[MAKEFLAGS CFLAGS LDFLAGS CPPFLAGS CXXFLAGS CXX LD CC].each do |flag|
      ENV.delete(flag)
    end

    # This is the default for OS X gcc.
    base_langs = ['c', 'objc', 'c++', 'obj-c++']

    # Get the prefixs' for the already installed dependencies.
    gmp = Formula.factory 'gmp'
    mpfr = Formula.factory 'mpfr'
    libmpc = Formula.factory 'libmpc'

    # FIXME: Create a better, more ruby, way format for this.
    ARGV.each do |arg|
      case curr = arg
      when '--enable-fortran'
        base_langs << 'fortran'
      when '--enable-java'
        base_langs << 'java'
      when '--disable-c'
        base_langs.delete 'c'
      when '--disable-objc'
        base_langs.delete 'objc'
      when '--disable-c++'
        base_langs.delete 'c++'
      when '--disable-obj-c++'
        base_langs.delete 'obj-c++'
      else 'Sorry, we are working on that...'
      end
    end

    # Attempt to mimic default OS X configure options.
    args =
      [
        "--disable-checking",
        "--enable-werror",
        "--prefix=#{prefix}",
        "--mandir=#{man}",
        "--enable-languages=#{base_langs.uniq.join(',')}",
        "--program-suffix=-4.5",
        "--with-slibdir=#{lib}",
        "--with-gxx-include-dir=#{include}/#{version}",
        "--with-gmp=#{gmp.prefix}",
        "--with-mpfr=#{mpfr.prefix}",
        "--with-mpc=#{libmpc.prefix}"
      ]

    system "./configure", *args
    system "make"

    # TODO: Implement the make checks at some point.
    system "make install"
  end
end
