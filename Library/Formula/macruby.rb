require 'formula'

class LlvmForMacruby < Formula
  url 'https://llvm.org/svn/llvm-project/llvm/trunk', :using => :svn, :revision => 106781
  version '106781'
end

class Macruby < Formula
  head 'git://git.macruby.org/macruby/MacRuby.git'
  homepage 'http://www.macruby.org/'

  def install
    ENV['UNIVERSAL']='0'

    llvm_path = Pathname.new(pwd) + 'llvm-trunk'
    LlvmForMacruby.new('llvm-for-macruby').brew do
      llvm_path.install Dir['*']
    end

    cd llvm_path do
       system "./configure",
              "--enable-bindings=none",
              "--enable-targets=host-only",
              "--enable-optimized",
              "--with-llvmgccdir=/tmp"
system "ln", "-s", "/Users/tianyi/OSS/~ruby/macruby/llvm-trunk/Release", "."
#       system "make"
    end

    args = [
      "CC=#{ENV['CC']}",
      "CXX=#{ENV['CXX']}",
      "DESTDIR=#{prefix}",
      "INSTALL='/usr/bin/install -c -d'",
      "archs=#{snow_leopard_64? ? 'x86_64' : 'i386'}",
      "framework_instdir=/",
      "jobs=#{Hardware.processor_count}",
      "llvm_path=#{llvm_path}/Release",
      "sym_instdir=/"
    ]

    rake *args
    rake "install", *args
  end

  def rake *args
    system "/usr/bin/ruby", "-S", "rake", *args
  end
end
