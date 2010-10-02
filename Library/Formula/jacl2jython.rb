require 'formula'

class Jacl2jython <Formula
  url 'http://public.dhe.ibm.com/software/websphere/appserv/support/tools/AST/utilities/Jacl2Jython/Jacl2Jython_v25.zip'
  version '2.5'
  homepage 'http://www-01.ibm.com/support/docview.wss?uid=swg24012144'
  md5 '8c089ffa482aa0804a3f070b56463230'

  def install
    rm %w[Jacl2Jython.bat]
    mv "Jacl2Jython.sh", "Jacl2Jython"
    chmod 0775, %w[Jacl2Jython]
    inreplace "Jacl2Jython", "JAVA_HOME=$binDir/../eclipse", "JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home"
    inreplace "Jacl2Jython", "/jre/bin", "/bin"
    bin.install %w[Jacl2Jython.jar Jacl2Jython]
    doc.install %w[doc license]
  end
end
