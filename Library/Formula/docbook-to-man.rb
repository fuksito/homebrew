require 'formula'

class DocbookToMan <Formula
  url 'http://www.oasis-open.org/docbook/tools/dtm/docbook-to-man.tar.gz'
  version '2.0.0'
  homepage 'http://www.oasis-open.org/docbook/tools/dtm/'
  md5 'b28ddaaa8eb4b775100c67fd1205240a'

  depends_on 'docbook'
  depends_on 'opensp'

  def install
    mkdir_p lib
    system "make install ROOT=#{prefix}"
  end
end
