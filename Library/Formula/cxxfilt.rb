require 'formula'

class Cxxfilt <Formula
  url 'http://www.opensource.apple.com/tarballs/cxxfilt/cxxfilt-9.tar.gz'
  homepage 'http://www.opensource.apple.com/tarballs/cxxfilt/'
  md5 'efbfc221794b5a260ede9831841b234d'

  def install
    mkdir_p ['BUILD/obj', 'BUILD/sym', 'BUILD/dst']
    system "make install RC_ARCHS='i386 x86_64' RC_CFLAGS='-arch i386 -arch x86_64 #{ENV['CFLAGS']}' RC_OS=macos RC_RELEASE=SnowLeopard SRCROOT=#{pwd} OBJROOT=#{pwd}/BUILD/obj SYMROOT=#{pwd}/BUILD/sym DSTROOT=#{pwd}/BUILD/dst"
    system "ditto #{pwd}/BUILD/dst/usr/local #{prefix}"
  end
end
