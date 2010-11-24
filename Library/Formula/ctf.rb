require 'formula'

class Ctf <Formula
  url 'http://www.opensource.apple.com/tarballs/dtrace/dtrace-78.tar.gz'
  homepage 'http://www.opensource.apple.com/tarballs/dtrace/'
  md5 'dafa0319bd6733c30ac63cc1d5854d1f'

  depends_on 'cxxfilt'

  def install
    mkdir_p ['BUILD/obj', 'BUILD/sym', 'BUILD/dst']
    system "xcodebuild install ARCHS='i386 x86_64' -target ctfconvert -target ctfdump -target ctfmerge OBJROOT=#{pwd}/BUILD/obj SYMROOT=#{pwd}/BUILD/sym DSTROOT=#{pwd}/BUILD/dst"
    system "ditto #{pwd}/BUILD/dst/usr/local #{prefix}"
  end
end
