require 'formula'

class Nix <Formula
  url 'http://hydra.nixos.org/build/565033/download/5/nix-0.16.tar.gz'
  homepage 'http://nixos.org/nix/'
  md5 'f214607a8ab8d1e37acfe6d5023feec4'

  skip_clean :all # otherwise unusable

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats
    <<-EOS.undent
    You should add
      source "`brew --prefix nix`/etc/profile.d/nix.sh"
    to your ~/.bashrc or some other login file
    EOS
  end
end
