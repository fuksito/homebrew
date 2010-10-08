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
        ['--with-clang', 'Also build and install clang'],
        ['--all-targets', 'Build non-host targets'],
        ['--enable-ocaml-binding', 'Enable Ocaml language binding']
    ]
  end

  depends_on 'objective-caml' if ocaml_binding?

  def install
    if build_clang?
      clang_dir = Pathname(Dir.pwd)+'tools/clang'
      Clang.new.brew { clang_dir.install Dir['*'] }
    end

    cur_path = Pathname(Dir.pwd)
    build_path = cur_path/'build'
    mkdir build_path
    cd build_path do
      system "../configure", "--prefix=#{prefix}",
                            "--disable-assertions",
                            "--enable-bindings=#{ocaml_binding? ? 'ocaml':'none'}",
                            "--enable-libffi",
                            "--enable-optimized",
                            "--enable-shared",
                            "--enable-targets=#{all_targets? ? 'all':'host-only'}"
      system "make" # seperate steps required, otherwise the build fails
      system "make install"
    end

    src_dir = prefix/'lib/llvm/src'
    obj_dir = prefix/'lib/llvm/obj'
    mkdir_p [src_dir, obj_dir]
    cp_r cur_path+'include', src_dir
    cp_r [build_path+'include', build_path+'Release', build_path+'Makefile.config'], obj_dir
    rm_f Dir["#{prefix}/lib/llvm/obj/Release/**/.dir"]

    inreplace ["#{prefix}/bin/llvm-config", "#{obj_dir}/Release/bin/llvm-config"] do |s|
      s.gsub! build_path, obj_dir.realpath
      s.gsub! cur_path, src_dir.realpath
    end
  end

  def caveats; <<-EOS
    If you already have LLVM installed, then "brew upgrade llvm" might not
    work. Instead, try:
        $ brew rm llvm
        $ brew install llvm
    EOS
  end
end
