require 'formula'

def build_clang?
  ARGV.include? '--with-clang'
end
def all_targets?
  ARGV.include? '--enable-all-targets'
end
def ocaml_binding?
  ARGV.include? '--enable-ocaml-binding'
end

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
        ['--with-clang', 'Build and install clang and clang static analyzer'],
        ['--all-targets', 'Build non-host targets'],
        ['--enable-ocaml-binding', 'Enable Ocaml language binding']
    ]
  end

  depends_on 'objective-caml' if ocaml_binding?

  def install
    fails_with_llvm "The llvm-gcc in Xcode is outdated to compile current version of llvm"

    if build_clang?
      clang_dir = Pathname(Dir.pwd)+'tools/clang'
      Clang.new.brew { clang_dir.install Dir['*'] }
    end

    source_dir = Pathname(Dir.pwd)
    build_dir = source_dir+'../build'
    mkdir build_dir
    cd build_dir do
      build_dir = Pathname(Dir.pwd)
      system "#{source_dir}/configure", "--prefix=#{prefix}",
                            "--disable-assertions",
                            "--enable-bindings=#{ocaml_binding? ? 'ocaml':'none'}",
                            "--enable-libffi",
                            "--enable-optimized",
                            "--enable-shared",
                            "--enable-targets=#{all_targets? ? 'all':'host-only'}"
      system "make install"
    end

    src_dir = prefix+'lib/llvm/src'
    obj_dir = prefix+'lib/llvm/obj'
    mkdir_p [src_dir, obj_dir]
    cp_r source_dir+'include', src_dir
    cp_r [build_dir+'include', build_dir+'Release', build_dir+'Makefile.config'], obj_dir
    rm_f Dir["#{prefix}/lib/llvm/obj/Release/**/.dir"]

    inreplace ["#{prefix}/bin/llvm-config", "#{obj_dir}/Release/bin/llvm-config"] do |s|
      s.gsub! build_dir, obj_dir.realpath
      s.gsub! source_dir, src_dir.realpath
    end

    if build_clang?
      # install Clang Static Analyzer (http://clang-analyzer.llvm.org/)
      for tool in ['scan-build', 'scan-view'] do
        dest_dir = libexec+tool
        dest_dir.install Dir["tools/clang/tools/#{tool}/*"]
        ln_s dest_dir+tool, bin
      end
      # pre-compile Python scripts
      for opt_arg in ['', '-O'] do
        system 'usr/bin/env python', opt_arg, '-m',
               'compileall', libexec
      end
    end
  end

  def caveats; <<-EOS
    If you already have pre-2.8 LLVM installed, then "brew upgrade llvm" might not work. Instead, try:
        $ brew rm llvm
        $ brew install llvm
    EOS
  end
end
