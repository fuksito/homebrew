require 'formula'

class BootstrapCmds <Formula
  url 'http://www.opensource.apple.com/tarballs/bootstrap_cmds/bootstrap_cmds-72.tar.gz'
  homepage 'http://www.opensource.apple.com/tarballs/bootstrap_cmds/'
  md5 '90ed9b35b385f1379831d7d7b3f3207a'

  def install
    ENV.j1
    mkdir_p ['BUILD/obj', 'BUILD/sym', 'BUILD/dst']
    system "make install RC_ARCHS='i386' RC_CFLAGS='-arch i386 #{ENV['CFLAGS']}' RC_OS=macos RC_RELEASE=SnowLeopard SRCROOT=#{pwd} OBJROOT=#{pwd}/BUILD/obj SYMROOT=#{pwd}/BUILD/sym DSTROOT=#{pwd}/BUILD/dst"
    system "ditto #{pwd}/BUILD/dst/usr/local #{prefix}"
  end
end
