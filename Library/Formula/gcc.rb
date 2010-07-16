require 'formula'

class Gcc <Formula
  url 'ftp://ftp.gnu.org/gnu/gcc/gcc-4.5.0/gcc-4.5.0.tar.bz2'
  homepage 'http://gcc.gnu.org'
  md5 'ff27b7c4a5d5060c8a8543a44abca31f'

  depends_on 'automake' # >= 1.11.1
  depends_on 'autoconf' # >= 2.64
  depends_on 'gmp'      # >= 4.3.2
  depends_on 'libmpc'   # >= 0.8.1
  depends_on 'mpfr'     # >= 2.4.2

  aka 'g++'

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
        "--disable-checking", "--enable-werror", "--prefix=#{prefix}",
        "--mandir=#{man}", "--enable-languages=#{base_langs.uniq.join(',')}", 
        "--program-transform-name=/^[cg][^.-]*$/s/$/-#{version.slice(/\d\.\d/)}/",
        "--with-slibdir=#{lib}", "--build=i686-apple-darwin10", 
        "--with-gxx-include-dir=#{include}/#{version}",
        "--host=i686-apple-darwin10", "--target=i686-apple-darwin10"
      ]

    system "./configure", *args
    system "make"

    # TODO: Implement the make checks at some point. 
    system "make install"
  end
end