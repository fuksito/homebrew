require 'formula'

class Hugs98 < Formula
  url 'http://www.haskell.org/hugs/downloads/2006-09/hugs98-plus-Sep2006.tar.gz'
  version 'plus-Sep2006'
  homepage 'http://www.haskell.org/hugs/'
  sha256 "fc8ba1cb9979010507633be97d5812c9d62adc52b8d1cff2ced53a7b27849e9b"

  depends_on 'readline'

  def patches
    { :p0 => [
      "http://trac.macports.org/export/72943/trunk/dports/lang/hugs98/files/patch-packages-base-include-HsBase.h.diff",
      "https://trac.macports.org/raw-attachment/ticket/20950/patch-libraries-tools-make-bootlib.diff"
    ] }
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
