require 'formula'

BIN_NAME = 'github_upload' # as suggested in `readme.md`

class GithubUpload <Formula
  head 'git://github.com/github/upload.git'
  homepage 'http://github.com/github/upload'

  depends_on 'xml-simple' => :ruby
  depends_on 'mime-types' => :ruby

  def install
    mv 'upload.rb', BIN_NAME
    bin.install BIN_NAME
    doc.install 'README.md'
  end
end
