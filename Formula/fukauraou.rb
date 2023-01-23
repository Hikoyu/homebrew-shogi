# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Fukauraou < Formula
  desc "YaneuraOu is the World's Strongest Shogi engine(AI player) , WCSC29 1st winner , educational and USI compliant engine."
  homepage "http://yaneuraou.yaneu.com"
  url "https://github.com/yaneurao/YaneuraOu/archive/refs/tags/V7.61.tar.gz"
  version "7.61"
  sha256 "b012daa2ed8f1c41daccbb0c994c41fbb57691c3ebb892824278fc7c9ae60ac6"
  license "GPL-3.0"

  depends_on "gnu-sed"
  depends_on "onnxruntime"
  
  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    author = "yaneurao"
    exe = "FukauraOu"

    system "gsed -i -e \"s,-march=corei7-avx,-march=core-avx2,\" source/Makefile"
    system "gsed -i -e \"s,\/\/#define ONNXRUNTIME,#define ONNXRUNTIME,\" source/config.h"
    system "gsed -i -e \"s,std::wstring,\/\/std::wstring,\" -e \"s,\/\/std::string onnx_filename(filename),std::string onnx_filename(model_filename),\" source/eval/deep/nn_onnx_runtime.cpp"

    odie "[ERROR] Your CPU is not 64-bit!" unless Hardware::CPU.is_64_bit?
    ohai "[INFO] Your CPU is Intel processor." if Hardware::CPU.intel?
    odie "[ERROR] Your CPU does not support SSSE3 instruction set!" if Hardware::CPU.intel? && !Hardware::CPU.ssse3?
    cpu = "SSSE3" and ohai "[INFO] Your CPU supports SSSE3 instruction set." if Hardware::CPU.intel? && Hardware::CPU.ssse3?
    cpu = "SSE41" and ohai "[INFO] Your CPU supports SSE4.1 instruction set." if Hardware::CPU.intel? && Hardware::CPU.sse4?
    cpu = "SSE42" and ohai "[INFO] Your CPU supports SSE4.2 instruction set." if Hardware::CPU.intel? && Hardware::CPU.sse4_2?
    cpu = "AVX2" and ohai "[INFO] Your CPU supports AVX2 instruction set." if Hardware::CPU.intel? && Hardware::CPU.avx2?
    cpu = "OTHER" and ohai "[INFO] Your CPU is Apple M processor." if Hardware::CPU.arm?

    cppflags = "-I#{HOMEBREW_PREFIX}/include/onnxruntime/core/session -I#{HOMEBREW_PREFIX}/include/onnxruntime/core/providers/cpu -fexceptions"
    ldflags = "-L#{HOMEBREW_PREFIX}/lib -lonnxruntime"
	
    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} EXTRA_CPPFLAGS=\"#{cppflags}\" EXTRA_LDFLAGS=\"#{ldflags}\" YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP"
    system "mv source/YaneuraOu-by-gcc #{exe}"
    system "make -C source clean"

    system "echo #{name}_#{version} >engine_name.txt"
    system "echo #{author} >>engine_name.txt"

    prefix.install "engine_name.txt", "#{exe}"
    ohai "[INFO] #{name} is installed in the path below."
    ohai "#{opt_prefix}/#{exe}"
    ohai "[INFO] The path below must be included in environmental variable DYLD_FALLBACK_LIBRARY_PATH."
    ohai "#{HOMEBREW_PREFIX}/lib"
  end

  test do
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./FukauraOu | grep 'usiok'")
  end
end
