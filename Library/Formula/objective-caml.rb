require 'formula'

class ObjectiveCaml <Formula
  url 'http://caml.inria.fr/pub/distrib/ocaml-3.12/ocaml-3.12.0.tar.bz2'
  homepage 'http://caml.inria.fr/ocaml/index.en.html'
  md5 'bd92c8970767f412bc1e9a6c625b5ccf'

  # Don't strip symbols, so dynamic linking doesn't break.
  skip_clean :all

  def install
    check_buggy_ld
    system "./configure", "--prefix", prefix, "--mandir", man
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "make", "world.opt"
    system "make", "install"

    (HOMEBREW_PREFIX+"lib/ocaml/site-lib").mkpath
    ln_s HOMEBREW_PREFIX+"lib/ocaml/site-lib", lib+"ocaml/site-lib"
  end

  def check_buggy_ld
    fail "The version of your linker (/usr/bin/ld) is ld64-115.4 from some version of Xcode 4 preview, which is known to be buggy and will cause the build fail mysteriously. To build this formula, you should either upgrade to latest version of Xcode 4 or uninstall it." if `/usr/bin/ld -v`.match 'ld64-115.4'
  end
end
