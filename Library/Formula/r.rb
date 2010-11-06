require 'formula'

def which_gfortran
  `/usr/bin/which gfortran`.strip
end

class R <Formula
  url 'http://cran.r-project.org/src/base/R-2/R-2.11.1.tar.gz'
  homepage 'http://www.R-project.org/'
  md5 '7421108ade3e9223263394b9bbe277ce'

  depends_on 'gfortran' if which_gfortran.empty?

  def install
    # Select the Fortran compiler to be used:
    ENV["FC"] = ENV["F77"] = which_gfortran

    # Set Fortran optimization flags:
    ENV["FFLAGS"] = ENV["FCFLAGS"] = ENV["CFLAGS"]

    system "./configure", "--prefix=#{prefix}", "--with-aqua", "--enable-R-framework",
           "--with-lapack"
    system "make"
    ENV.j1 # Serialized installs, please
    system "make install"

    # Link binaries and manpages from the Framework
    # into the normal locations
    bin.mkpath
    man1.mkpath

    ln_s prefix+"R.framework/Resources/bin/R", bin
    ln_s prefix+"R.framework/Resources/bin/Rscript", bin
    ln_s prefix+"R.framework/Resources/man1/R.1", man1
    ln_s prefix+"R.framework/Resources/man1/Rscript.1", man1
  end
end
