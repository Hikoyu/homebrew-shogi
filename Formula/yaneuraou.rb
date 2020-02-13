# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Yaneuraou < Formula
  desc "YaneuraOu is the World's Strongest Shogi engine(AI player) , WCSC29 1st winner , educational and USI compliant engine."
  homepage "http://yaneuraou.yaneu.com"
  url "https://github.com/yaneurao/YaneuraOu/archive/V4.88.tar.gz"
  version "4.88"
  sha256 "a55b139290451777db20b41dd90b86f15c8600f7f991e8740b38e0b7debac5e0"

  depends_on "gnu-sed"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    system "gsed -i -e \"s,#COMPILER = g++,COMPILER = g++,\" -e \"s,COMPILER = clang++,#COMPILER = clang++,\" source/Makefile"
	
    system "gsed -i -e \"s,TARGET_CPU = AVX2,#TARGET_CPU = AVX2,\" source/Makefile"
    system "gsed -i -e \"s,#TARGET_CPU = NO_SSE,TARGET_CPU = NO_SSE,\" source/Makefile" if Hardware::CPU.is_32_bit?
    system "gsed -i -e \"s,#TARGET_CPU = SSE2,TARGET_CPU = SSE2,\" source/Makefile" if Hardware::CPU.is_64_bit?
    system "gsed -i -e \"s,#TARGET_CPU = SSE41,TARGET_CPU = SSE41,\" -e \"s,TARGET_CPU = SSE2,#TARGET_CPU = SSE2,\" source/Makefile" if Hardware::CPU.sse4?
    system "gsed -i -e \"s,#TARGET_CPU = SSE42,TARGET_CPU = SSE42,\" -e \"s,TARGET_CPU = SSE41,#TARGET_CPU = SSE41,\" source/Makefile" if Hardware::CPU.sse4_2?
    system "gsed -i -e \"s,#TARGET_CPU = AVX2,TARGET_CPU = AVX2,\" -e \"s,TARGET_CPU = SSE42,#TARGET_CPU = SSE42,\" source/Makefile" if Hardware::CPU.avx2?

    system "gsed -i -e \"s,#define USE_AVX2,//#define USE_AVX2,\" source/config.h"
    system "gsed -i -e \"s,//#define NO_SSE,#define NO_SSE,\" source/config.h" if Hardware::CPU.is_32_bit?
    system "gsed -i -e \"s,//#define USE_SSE2,#define USE_SSE2,\" source/config.h" if Hardware::CPU.is_64_bit?
    system "gsed -i -e \"s,//#define USE_SSE41,#define USE_SSE41,\" -e \"s,#define USE_SSE2,//#define USE_SSE2,\" source/config.h" if Hardware::CPU.sse4?
    system "gsed -i -e \"s,//#define USE_SSE42,#define USE_SSE42,\" -e \"s,#define USE_SSE41,//#define USE_SSE41,\" source/config.h" if Hardware::CPU.sse4_2?
    system "gsed -i -e \"s,//#define USE_AVX2,#define USE_AVX2,\" -e \"s,#define USE_SSE42,//#define USE_SSE42,\" source/config.h" if Hardware::CPU.avx2?
	
    system "make -C source"
    system "mv source/YaneuraOu-by-gcc source/YaneuraOu"
    bin.install "source/YaneuraOu"
  end

  test do
    assert_match 'usiok', shell_output("echo 'usi' | #{bin}/YaneuraOu | tail -n 1")
  end
end
