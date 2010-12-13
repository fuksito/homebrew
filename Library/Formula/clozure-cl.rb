require 'formula'

class ClozureCl <Formula
  url 'ftp://ftp.clozure.com/pub/release/1.6/ccl-1.6-darwinx86.tar.gz'
  version '1.6'
  md5 '290100fdb8dab3b9967ce8b688113199'
  homepage 'http://openmcl.clozure.com/'

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
