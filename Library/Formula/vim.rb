require 'formula'

class Vim <Formula
  url 'ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2'
  homepage 'http://www.vim.org/'
  md5 '5b9510a17074e2b37d8bb38ae09edbf2'
  head 'http://vim.svn.sourceforge.net/svnroot/vim/trunk/'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-gui=no",
                          "--without-x",
                          "--disable-nls",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-pythoninterp",
                          "--enable-rubyinterp",
                          "--with-features=huge"
    system "make"
    system "make install"
  end
end
