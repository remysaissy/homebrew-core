class Libbpf < Formula
  desc "Berkeley Packet Filter library"
  homepage "https://github.com/libbpf/libbpf"
  url "https://github.com/libbpf/libbpf/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "b4fe864ed96cf276e3370a4706bafbafde1eccd5894418c4d8eeb941f371eb8a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "48feab000bf704e6859b236d2c97ce7f0cf4f609255273279dbba306d0087bbc"
  end

  depends_on "pkg-config" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib"

  def install
    system "make", "-C", "src"
    system "make", "-C", "src", "install", "PREFIX=#{prefix}", "LIBDIR=#{lib}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "bpf/libbpf.h"
      #include <stdio.h>

      int main() {
        printf("%s", libbpf_version_string());
        return(0);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbpf", "-o", "test"
    system "./test"
  end
end
