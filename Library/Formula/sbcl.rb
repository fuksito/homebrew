require 'formula'

# The official binary for 1.0.29 is used to bootstrap the latest version.
class SbclBinary < Formula
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.29/sbcl-1.0.29-x86-darwin-binary-r2.tar.bz2'
  md5 '6e6b027a5fd05ef0c8faee30d89ffe54'
  version '1.0.29'
end

class Sbcl < Formula
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.0.43/sbcl-1.0.43-source.tar.bz2'
  homepage 'http://www.sbcl.org/'
  md5 '2b125844371881a99cfdf63c286e74cd'

  def install
    original_path = pwd
    puts "original_path=#{original_path}"
    mktemp do
      # install 1.0.29 to a temporary location
      binary_path = pwd
      SbclBinary.new('sbcl-binary').brew do
        install_sbcl binary_path
      end
      # build and install 1.0.43
      cd original_path do
        system "env",
               "PATH=#{binary_path}/bin:#{ENV['PATH']}",
               "SBCL_HOME=#{binary_path}/lib/sbcl",
               "sh",
               "make.sh",
               "--prefix=#{prefix}"
        cd 'tests' do
          system "sh run-tests.sh"
        end
        install_sbcl prefix
      end
    end
  end

  def install_sbcl path
    system "env",
           "INSTALL_ROOT=#{path}",
           "sh",
           "install.sh"
  end

end
