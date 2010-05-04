require 'formula'

class Gcc <Formula
  url 'ftp://ftp.gnu.org/gnu/gcc/gcc-4.5.0/gcc-4.5.0.tar.bz2'
  homepage 'http://gcc.gnu.org'
  md5 'ff27b7c4a5d5060c8a8543a44abca31f'

  # TODO: Did not realize that these were not here.
  #depends_on 'automake' # 1.11.1
  #depends_on 'autoconf' # 2.64
  depends_on 'gmp'      # >= 4.3.2
  depends_on 'libmpc'   # >= 0.8.1
  depends_on 'mpfr'     # >= 2.4.2

  aka 'g++'
  aka 'gfortran-4.5' # statically named, as not sure if you can put variable here
  
  # FIXME: Include support for Ada at some point, there are other dependencies,
  # and I have never used it, so have not explored it yet (GNAT Compiler).
  avail_langs = ['c', 'c++', 'fortran', 'java', 'objc', 'objc++']
  
  # FIXME: I don't know ruby, and I am sure this is a much more elegant solution for this.
  def options 
    [
      ["--with-suffix", "Add #{version.slice(/\d\.\d/)} to the suffix of the commands"],
      ["--enable-fortran", "Enable Fortran language support"],
      ["--enable-java", "Enable Java languagesupport"],
      ["--enable-objc", "Enable Objective-C language support"],
      ["--enable-objc++", "Enable Objective-C++ language support"],
      ["--disable-c", "Disable C language support"],
      ["--disable-c++", "Disable C++ language support"]
      #avail_langs.map { |e| ["--enable-#{e}", "enable #{e} language support"] },
      #avail_langs.map { |e| ["--disable-#{e}", "disable #{e} language support"] }
    ]
  end
  
  def install
    # Remove the built in flags to get it to build properly
    # TODO: LDFLAGS and CPPFLAGS probably don't need to be in here
    %w[MAKEFLAGS CFLAGS LDFLAGS CPPFLAGS CXXFLAGS CXX LD CC].each do |flag|
      ENV.delete(flag)  
    end
    
    # Get the prefixs' for the already installed dependencies.
    gmp = Formula.factory 'gmp'
    libmpc = Formula.factory 'libmpc'
    mpfr = Formula.factory 'mpfr'
    
    # This is not the default for GCC (which is all but Ada and Obj-C++)
    base_langs = ['c', 'c++']
    
    # Automatically tack on fortran if user trys to install from 'gfortran' alias
    base_langs << 'fortran' if ARGV.include? 'gfortran'
    
    # FIXME: Create a better, more ruby, way format for this.
    ARGV.each do |arg|
      case curr = arg
      when '--enable-fortran'
        base_langs << 'fortran'
      when '--enable-java'
        base_langs << 'java'
      when '--enable-objc'
        base_langs << 'objc'
      when '--enable-objc++'
        base_langs << 'objc++'
      when '--disable-c'
        base_langs.delete 'c'
      when '--disable-c++'
        base_langs.delete 'c++'
      else 'Sorry, we are working on that...'
      end
    end
    
    args = 
      [
        "--prefix=#{prefix}", "--libexecdir=#{libexec}", "--libdir=#{lib}",
        "--mandir=#{man}", "--infodir=#{info}", # "--includedir=#{include}",
        "--with-gmp=#{gmp.prefix}", "--with-mpfr=#{mpfr.prefix}", "--with-mpc=#{libmpc.prefix}",
        "--enable-languages=#{base_langs.uniq.join(',')}"
      ]
      
    args << "--program-suffix=-#{version.slice(/\d\.\d/)}" if ARGV.include? "--with-suffix"

    # FIXME: This may be able to be taken out at this point, this was from early on when
    # the include directories and *FLAGS were not working properly.
    # When building there were errors stating that it was "Waiting for unfinished jobs"
    ENV.j1
    system "./configure", *args
    system "make"
    
    # TODO: Implement the make checks at some point.
    
    system "make install"
  end
end