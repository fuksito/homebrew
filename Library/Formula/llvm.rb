require 'formula'

def build_clang?; ARGV.include? '--with-clang'; end

class Clang <Formula
  url       'http://llvm.org/releases/2.8/clang-2.8.tgz'
  homepage  'http://llvm.org/'
  md5       '10e14c901fc3728eecbd5b829e011b59'
  head      'git://repo.or.cz/clang.git'
end

class Llvm <Formula
  url       'http://llvm.org/releases/2.8/llvm-2.8.tgz'
  homepage  'http://llvm.org/'
  md5       '220d361b4d17051ff4bb21c64abe05ba'
  head      'git://repo.or.cz/llvm.git'

  def options
    [['--with-clang', 'Also build & install clang']]
  end

  def install
    ENV.gcc_4_2 # llvm can't compile itself

    if build_clang?
      clang_dir = Pathname.new(Dir.pwd)+'tools/clang'
      Clang.new.brew { clang_dir.install Dir['*'] }
    end

    system "./configure", "--prefix=#{prefix}",
                          "--enable-optimized",
                          "--enable-bindings=none",
                          "--disable-assertions",
                          "--enable-shared"
    system "make" # seperate steps required, otherwise the build fails
    system "make install"

    # FIXME: obj and src files!
  end

  def caveats; <<-EOS
    If you already have LLVM installed, then "brew upgrade llvm" might not
    work. Instead, try:
        $ brew rm llvm
        $ brew install llvm
    EOS
  end
end
