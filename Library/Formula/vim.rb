require 'formula'

class Vim <Formula
  # Actually vim HEAD is always stable
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
                          "--enable-rubyinterp",
                          "--with-ruby-command=/usr/bin/ruby", # ruby 1.9 won't work
                          "--with-features=huge"
    system "make"
    system "make install"
  end
end
