require 'formula'

class KextTools <Formula
  url 'http://www.opensource.apple.com/tarballs/kext_tools/kext_tools-180.2.tar.gz'
  homepage 'http://www.opensource.apple.com/tarballs/kext_tools/'
  md5 '539a07608a73459a35603ab91257b687'

  def install
    mkdir_p ['BUILD/obj', 'BUILD/sym', 'BUILD/dst']
    system "xcodebuild install -target kextsymboltool -target setsegname ARCHS='i386 x86_64' OBJROOT=#{pwd}/BUILD/obj SYMROOT=#{pwd}/BUILD/sym DSTROOT=#{pwd}/BUILD/dst"
    system "ditto #{pwd}/BUILD/dst/usr/local #{prefix}"
  end
end
