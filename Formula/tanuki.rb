# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Tanuki < Formula
  desc "shogi engine(AI player), stronger than Bonanza6 , educational and tiny code(about 2500 lines) , USI compliant engine , capable of being compiled by VC++2015"
  homepage "https://github.com/nodchip/tanuki-"
  url "https://github.com/nodchip/tanuki-/archive/refs/tags/tanuki-wcsc32.tar.gz"
  version "wcsc32-2022-05-06"
  sha256 "4df718b3b680c2b8c1db4674c9854676b19ddc8c62ae7d82ec3712fab1a6f00a"
  license "GPL-3.0"

  depends_on "gnu-sed"
  depends_on "unar"
  depends_on "libomp"

  resource "tanuki-eval-book" do
    url "https://github.com/nodchip/tanuki-/releases/download/tanuki-wcsc32/tanuki-wcsc32-2022-05-06.7z"
    sha256 "6b5d7d3ba0fcf03c07f5511cc259c1f6cb3e241b0dd6b19b1eb9ceed7d6abdfc"
  end

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    author = "Ziosoft, Inc. Computer Shogi Club"
    exe = "tanuki"

    system "gsed -i -e \"s,-march=corei7-avx,-march=core-avx2,\" source/Makefile"
    system "gsed -i -e \"s,-lsqlite3\.dll,-lsqlite3 #,\" source/Makefile"

    odie "[ERROR] Your CPU is not 64-bit!" unless Hardware::CPU.is_64_bit?
    ohai "[INFO] Your CPU is Intel processor." if Hardware::CPU.intel?
    odie "[ERROR] Your CPU does not support SSSE3 instruction set!" if Hardware::CPU.intel? && !Hardware::CPU.ssse3?
    cpu = "SSSE3" and ohai "[INFO] Your CPU supports SSSE3 instruction set." if Hardware::CPU.intel? && Hardware::CPU.ssse3?
    cpu = "SSE41" and ohai "[INFO] Your CPU supports SSE4.1 instruction set." if Hardware::CPU.intel? && Hardware::CPU.sse4?
    cpu = "SSE42" and ohai "[INFO] Your CPU supports SSE4.2 instruction set." if Hardware::CPU.intel? && Hardware::CPU.sse4_2?
    cpu = "AVX2" and ohai "[INFO] Your CPU supports AVX2 instruction set." if Hardware::CPU.intel? && Hardware::CPU.avx2?
    cpu = "OTHER" and ohai "[INFO] Your CPU is Apple M processor." if Hardware::CPU.arm?

    cppflags = "-Xpreprocessor -I#{HOMEBREW_PREFIX}/include"
    ldflags = "-L#{HOMEBREW_PREFIX}/lib -lomp"

    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} EXTRA_CPPFLAGS=\"#{cppflags}\" EXTRA_LDFLAGS=\"#{ldflags}\" YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE_HALFKP_1024X2_8_32"
    system "mv source/YaneuraOu-by-gcc #{exe}"
    system "make -C source clean"

    resource("tanuki-eval-book").fetch
    system "cp", resource("tanuki-eval-book").downloader.cached_location, "tanuki-eval-book.7z"
    system "unar tanuki-eval-book.7z eval/* book/*"

    system "echo #{name}_#{version} >engine_name.txt"
    system "echo #{author} >>engine_name.txt"

    prefix.install Dir["tanuki-eval-book/*"], "engine_name.txt", "#{exe}"
    ohai "[INFO] #{name} is installed in the path below."
    ohai "#{opt_prefix}/#{exe}"
  end

  test do
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./#{name} | grep 'usiok'")
    assert_match 'readyok', shell_output("cd #{prefix} && echo 'isready' | ./#{name} | grep 'readyok'")
  end
end
