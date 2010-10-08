require 'formula'

def build_clang?; ARGV.include? '--with-clang'; end
def all_targets?; ARGV.include? '--enable-all-targets'; end
def ocaml_binding?; ARGV.include? '--enable-ocaml-binding'; end

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
    [
        ['--with-clang', 'Also build & install clang'],
        ['--all-targets', 'Enable non-host targets'],
        ['--enable-ocaml-binding', 'Enable Ocaml language binding']
    ]
  end

  depends_on 'ocaml' if ocaml_bindings?

  def install
    if build_clang?
      clang_dir = Pathname.new(Dir.pwd)+'tools/clang'
      Clang.new.brew { clang_dir.install Dir['*'] }
    end

    system "./configure", "--prefix=#{prefix}",
                          "--enable-targets=#{all_targets?'all':'host-only'}",
                          "--enable-optimized",
                          "--enable-bindings=#{ocaml_bindings?'ocaml':'none'}",
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
