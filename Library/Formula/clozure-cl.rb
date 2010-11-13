require 'formula'

class ClozureCl <Formula
  url 'ftp://ftp.clozure.com/pub/release/1.5/ccl-1.5-darwinx86.tar.gz'
  version '1.5'
  homepage 'http://openmcl.clozure.com/'
  md5 'd43f9c2aa94b58d9ef56e48638a22ebc'

  def install
    rm_rf Dir['**/.svn/']+Dir['**/.cvsignore']
    system "echo '(ccl::rebuild-ccl :full t)' | ./#{bootimg} --batch"
    (share/'ccl').install Dir['*']
    (bin/'ccl').write <<-EOF.undent
    #!/bin/sh
    export CCL_DEFAULT_DIRECTORY=#{share/'ccl'}
    exec ${CCL_DEFAULT_DIRECTORY}/#{bootimg} "$@"
    EOF
    chmod 0755, bin/'ccl'
  end

  def bootimg
    "dx86cl#{snow_leopard_64? ? '64':''}"
  end

end
