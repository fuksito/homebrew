require 'formula'

## The following sub-formulas, Should they really be other formulas of subformulas? Should GAP formulas be thus:
## gap -- installs the core gap system
## gap-pkg -- installs the gap packages
## gap-xtom -- installs extra table of marks
## gap-dev -- installs the dev utilities.

class GapPkg < Formula
  url 'ftp://ftp.gap-system.org/pub/gap/gap4/tar.gz/packages-2010_07_02-09_53_UTC.tar.gz'
  version '2010-07-02'
  md5 '04dd902163d704470946c0b7a70e3109'
end

class GapXtom < Formula
  url 'ftp://ftp.gap-system.org/pub/gap/gap4/tar.gz/xtom1r1p4.tar.gz'
  version '1.1.4'
  md5 'c909e1a736831d97bf325a80627575e2'
end

class GapDev < Formula
  url 'ftp://ftp.gap-system.org/pub/gap/gap4/tar.gz/tools4r4p12.tar.gz'
  version '4.4.12'
  md5 'c11a3b4f1372f33a717a4f51b1b2d87f'
end

class Gap <Formula
  url 'ftp://ftp.gap-system.org/pub/gap/gap4/tar.gz/gap4r4p12.tar.gz'
  homepage 'http://www.gap-system.org/'
  md5 'a0f439f9b33568d73eb99863dcc7f86b'
  version '4.4.12'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
# Either make $GAPROOT or find way to change gap.sh file
    inreplace 'bin/gap.sh' do |s|
      s.gsub! '/usr/bin/cc', 'cc'
      s.gsub! "#{Dir.pwd}", "/usr/local/lib/gap4r4"
    end
    bin.install 'bin/gap.sh' => 'gap'

    gaproot = lib+'gap4r4'
    # make install
    gaproot.install Dir['*']

    # Install the packages
    pkg = gaproot+'pkg'
    GapPkg.new.brew { cp_r Dir['*'], pkg }

    # Install the extra table of marks
    GapXtom.new.brew { cp_r Dir['*'], gaproot }

    # Install the devtools
    GapDev.new.brew { cp_r Dir['*'], gaproot }
  end

  def caveats
    puts <<-EOS
################################################################################
Several of the GAP packages contained code that needs to be compiled. Download:

<http://www.gap-system.org/Download/InstPackages.sh>

to $GAP_ROOT/pkg and execute the script. Where $GAP_ROOT is the location of
where GAP was installed this should be:

#{lib}/gap4r4/

You might need to chmod +x the script before it compiles. Be warned that you
may face errors during compilation. If you do try copy and pasting lines from
InstPackages.sh if this fails to work consult the packages readme files.
################################################################################
     EOS
  end
end
