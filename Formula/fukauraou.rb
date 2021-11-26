# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Fukauraou < Formula
  desc "YaneuraOu is the World's Strongest Shogi engine(AI player) , WCSC29 1st winner , educational and USI compliant engine."
  homepage "http://yaneuraou.yaneu.com"
  url "https://github.com/yaneurao/YaneuraOu/archive/refs/tags/v6.50.tar.gz"
  version "6.50"
  sha256 "cdf3d6f6b1222e3f273a03cd8d2aae6392e49a024e1742dbdbc3b93912c30a41"
  license "GPL-3.0"

  depends_on "gnu-sed"
  depends_on "onnxruntime"
  
  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "gsed -i -e \"s,-march=corei7-avx,-march=core-avx2,\" source/Makefile"
    system "gsed -i -e \"s,\/\/#define ONNXRUNTIME,#define ONNXRUNTIME,\" source/config.h"
    system "gsed -i -e \"s,std::wstring,\/\/std::wstring,\" -e \"s,\/\/std::string onnx_filename(filename),std::string onnx_filename(model_filename),\" source/eval/deep/nn_onnx_runtime.cpp"

    odie "[ERROR] Your CPU is not 64-bit!" unless Hardware::CPU.is_64_bit?
    odie "[ERROR] Your CPU does not support SSSE3 instruction set!" unless Hardware::CPU.ssse3?
    cpu = "SSSE3" and ohai "[INFO] Your CPU supports SSSE3 instruction set." if Hardware::CPU.ssse3?
    cpu = "SSE41" and ohai "[INFO] Your CPU supports SSE4.1 instruction set." if Hardware::CPU.sse4?
    cpu = "SSE42" and ohai "[INFO] Your CPU supports SSE4.2 instruction set." if Hardware::CPU.sse4_2?
    cpu = "AVX2" and ohai "[INFO] Your CPU supports AVX2 instruction set." if Hardware::CPU.avx2?

    cppflags = "-I#{HOMEBREW_PREFIX}/include/onnxruntime/core/session -I#{HOMEBREW_PREFIX}/include/onnxruntime/core/providers/cpu -fexceptions"
    ldflags = "-L#{HOMEBREW_PREFIX}/lib -lonnxruntime"
	
    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} EXTRA_CPPFLAGS=\"#{cppflags}\" EXTRA_LDFLAGS=\"#{ldflags}\" YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP"
    system "mv source/YaneuraOu-by-gcc FukauraOu"
    system "make -C source clean"

    prefix.install "FukauraOu"
	ohai "[INFO] The path below must be included in environmental variable DYLD_FALLBACK_LIBRARY_PATH."
	ohai "#{HOMEBREW_PREFIX}/lib"
  end

  test do
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./FukauraOu | grep 'usiok'")
  end
end
