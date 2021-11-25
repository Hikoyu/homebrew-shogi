# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Tanuki < Formula
  desc "shogi engine(AI player), stronger than Bonanza6 , educational and tiny code(about 2500 lines) , USI compliant engine , capable of being compiled by VC++2015"
  homepage "https://github.com/nodchip/tanuki-"
  url "https://github.com/nodchip/tanuki-/archive/refs/tags/tanuki-denryu2.tar.gz"
  version "denryu2"
  sha256 "86e2742ce8292e836b587f7e1a48442b7c00d89dd234f43f142502111d604ded"
  license "GPL-3.0"

  depends_on "gnu-sed"
  depends_on "unar"
  depends_on "libomp"

  resource "tanuki-eval-book" do
    url "https://github.com/nodchip/tanuki-/releases/download/tanuki-denryu2/tanuki-denryu2.7z"
    sha256 "945b94ed42446213ea6786a904e7c50a29c7d009d4cd238f1662c6b2c2c46e52"
  end

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "gsed -i -e \"s,-march=corei7-avx,-march=core-avx2,\" source/Makefile"
    system "gsed -i -e \"s,-lsqlite3\.dll,-lsqlite3 #,\" source/Makefile"

    cpu = "OTHER"
    cpu = "SSE2" if Hardware::CPU.intel?
    cpu = "SSE41" if Hardware::CPU.sse4?
    cpu = "SSE42" if Hardware::CPU.sse4_2?
    cpu = "AVX2" if Hardware::CPU.avx2?

    cppflags = "-Xpreprocessor -I#{HOMEBREW_PREFIX}/include"
    ldflags = "-L#{HOMEBREW_PREFIX}/lib -lomp"

    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} EXTRA_CPPFLAGS=\"#{cppflags}\" EXTRA_LDFLAGS=\"#{ldflags}\" YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE_HALFKP_VM_256X2_32_32"
    system "mv source/YaneuraOu-by-gcc tanuki"
    system "make -C source clean"

    resource("tanuki-eval-book").fetch
    system "cp", resource("tanuki-eval-book").downloader.cached_location, "tanuki-denryu2.7z"
    system "unar tanuki-denryu2.7z eval/* book/*"

    author = "Ziosoft, Inc. Computer Shogi Club"
    exe = "#{opt_prefix}/YaneuraOu_NNUE_HALFKP_VM_256X2_32_32"

    system "echo #{name}_#{version} >engine_name.txt"
    system "echo #{author} >>engine_name.txt"
    prefix.install Dir["tanuki-denryu2/*"], "engine_name.txt", "#{name}"
    ohai "[INFO] #{name} is installed in the path below."
    ohai "#{opt_prefix}/#{name}"
  end

  test do
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./#{name} | grep 'usiok'")
    assert_match 'readyok', shell_output("cd #{prefix} && echo 'isready' | ./#{name} | grep 'readyok'")
  end
end
