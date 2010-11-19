require 'formula'

class Crack <Formula
  url 'http://crack-language.googlecode.com/files/crack-0.2.1.tar.gz'
  homepage 'http://code.google.com/p/crack-language/'
  md5 '5792b9644848526530de858ce2289998'

  depends_on 'llvm' # must build with --rtti
  depends_on 'spug'

  def install
    replace_all "#include <malloc.h>", "#include <stdlib.h>"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # XXX: failed because OS X has no ppoll(2)
    system "make"
    system "make check"
    system "make install"
  end

  def patches
    DATA
  end
end

__END__
diff --git a/ltmain.sh b/ltmain.sh
index 7ed280b..4011d2d 100755
--- a/ltmain.sh
+++ b/ltmain.sh
@@ -3168,7 +3168,7 @@ int setenv (const char *, const char *, int);
 #  endif
 # endif
 #endif
-#include <malloc.h>
+#include <sys/malloc.h>
 #include <stdarg.h>
 #include <assert.h>
 #include <string.h>
diff --git a/runtime/Net.cc b/runtime/Net.cc
index 91e4b1b..da2ed07 100644
--- a/runtime/Net.cc
+++ b/runtime/Net.cc
@@ -6,7 +6,7 @@
 #include <arpa/inet.h>
 #include <string.h>
 #include <stdint.h>
-#include <malloc.h>
+#include <sys/malloc.h>
 #include <errno.h>
 #include <signal.h>
 
