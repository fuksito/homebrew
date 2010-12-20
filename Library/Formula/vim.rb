require 'formula'

class Vim <Formula
  head 'https://vim.googlecode.com/hg/'
  homepage 'http://www.vim.org/'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-gui=no",
                          "--without-x",
                          "--disable-nls",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-pythoninterp",
                          "--disable-rubyinterp",
                          "--with-features=huge"
    system "make"
    system "make install"
  end
end
