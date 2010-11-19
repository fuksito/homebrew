require 'formula'

class Spug <Formula
  url 'http://crack-language.googlecode.com/files/spug%2B%2B-0.8.tar.gz'
  homepage 'http://code.google.com/p/crack-language/'
  md5 'c18e37de56092b31f431239333619cae'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def patches
    DATA
  end

end

__END__
diff --git a/Mutex.h b/Mutex.h
index b34b86e..f40a52d 100644
--- a/Mutex.h
+++ b/Mutex.h
@@ -24,6 +24,8 @@
 
 #include <pthread.h>
 
+#define PTHREAD_MUTEX_RECURSIVE_NP PTHREAD_MUTEX_RECURSIVE
+
 namespace spug {
 
 class Condition;

