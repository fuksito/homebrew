require 'formula'

class Anic <Formula
  head 'https://anic.googlecode.com/hg/'
  homepage 'http://code.google.com/p/anic/'

  def patches
    DATA
  end

  def install
    system "make"
    system "make test"
    bin.install "anic"
    man1.install "man/anic.1"
  end
end

# The patch was taken from the package from Arch User Repository, http://aur.archlinux.org/packages.php?ID=43455
__END__
diff -r a487a021ed5d src/types.cpp
--- a/src/types.cpp	Thu Sep 30 21:21:28 2010 -0700
+++ b/src/types.cpp	Sat Nov 13 11:35:32 2010 +0900
@@ -1511,7 +1511,7 @@
 TypeStatus::TypeStatus(Type *type, const TypeStatus &otherStatus) : type(type), retType(otherStatus.retType), code(NULL) {}
 TypeStatus::~TypeStatus() {}
 TypeStatus::operator Type *() const {return type;}
-TypeStatus::operator uintptr_t() const {return (unsigned int)type;}
+TypeStatus::operator uintptr_t() const {return (uintptr_t)type;}
 DataTree *TypeStatus::castCode(const Type &destType) const {
 	StdType *thisType = (StdType *)type;
 	StdType *otherType = (StdType *)(&destType);
