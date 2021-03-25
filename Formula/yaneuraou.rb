# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Yaneuraou < Formula
  desc "YaneuraOu is the World's Strongest Shogi engine(AI player) , WCSC29 1st winner , educational and USI compliant engine."
  homepage "http://yaneuraou.yaneu.com"
  url "https://github.com/yaneurao/YaneuraOu/archive/refs/tags/v6.00.tar.gz"
  version "6.00"
  sha256 "3e8015db48dcf4727448a81fe347e97c52e7621c78b2f73a5db80914a6e44ae7"
  license "GPL-3.0"

  depends_on "gnu-sed"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "gsed -i -e \"s,#define USE_AVX2,//#define USE_AVX2,\" source/config.h"
    system "gsed -i -e \"s,//#define NO_SSE,#define NO_SSE,\" source/config.h" if Hardware::CPU.is_32_bit?
    system "gsed -i -e \"s,//#define USE_SSE2,#define USE_SSE2,\" source/config.h" if Hardware::CPU.is_64_bit?
    system "gsed -i -e \"s,//#define USE_SSE41,#define USE_SSE41,\" -e \"s,#define USE_SSE2,//#define USE_SSE2,\" source/config.h" if Hardware::CPU.sse4?
    system "gsed -i -e \"s,//#define USE_SSE42,#define USE_SSE42,\" -e \"s,#define USE_SSE41,//#define USE_SSE41,\" source/config.h" if Hardware::CPU.sse4_2?
    system "gsed -i -e \"s,//#define USE_AVX2,#define USE_AVX2,\" -e \"s,#define USE_SSE42,//#define USE_SSE42,\" source/config.h" if Hardware::CPU.avx2?

    system "gsed -i -e \"s,#COMPILER = g++,COMPILER = g++,\" -e \"s,COMPILER = clang++,#COMPILER = clang++,\" source/Makefile"

    system "gsed -i -e \"s,TARGET_CPU = AVX2,#TARGET_CPU = AVX2,\" source/Makefile"
    system "gsed -i -e \"s,#TARGET_CPU = NO_SSE,TARGET_CPU = NO_SSE,\" source/Makefile" if Hardware::CPU.is_32_bit?
    system "gsed -i -e \"s,#TARGET_CPU = SSE2,TARGET_CPU = SSE2,\" source/Makefile" if Hardware::CPU.is_64_bit?
    system "gsed -i -e \"s,#TARGET_CPU = SSE41,TARGET_CPU = SSE41,\" -e \"s,TARGET_CPU = SSE2,#TARGET_CPU = SSE2,\" source/Makefile" if Hardware::CPU.sse4?
    system "gsed -i -e \"s,#TARGET_CPU = SSE42,TARGET_CPU = SSE42,\" -e \"s,TARGET_CPU = SSE41,#TARGET_CPU = SSE41,\" source/Makefile" if Hardware::CPU.sse4_2?
    system "gsed -i -e \"s,#TARGET_CPU = AVX2,TARGET_CPU = AVX2,\" -e \"s,TARGET_CPU = SSE42,#TARGET_CPU = SSE42,\" source/Makefile" if Hardware::CPU.avx2?

    system "gsed -i -e \"s,-march=corei7-avx,-march=core-avx2,\" source/Makefile"

    system "make -C source"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_NNUE"

    system "gsed -i -e \"s,YANEURAOU_EDITION = YANEURAOU_ENGINE_NNUE,#YANEURAOU_EDITION = YANEURAOU_ENGINE_NNUE,\" -e \"s,##YANEURAOU_EDITION = YANEURAOU_ENGINE_NNUE_KP256,YANEURAOU_EDITION = YANEURAOU_ENGINE_NNUE_KP256,\" source/Makefile"
    system "make clean -C source"
    system "make -C source"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_NNUE_KP256"

    system "gsed -i -e \"s,YANEURAOU_EDITION = YANEURAOU_ENGINE_NNUE_KP256,#YANEURAOU_EDITION = YANEURAOU_ENGINE_NNUE_KP256,\" -e \"s,#YANEURAOU_EDITION = YANEURAOU_ENGINE_KPPT,YANEURAOU_EDITION = YANEURAOU_ENGINE_KPPT,\" source/Makefile"
    system "make clean -C source"
    system "make -C source"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_KPPT"

    system "gsed -i -e \"s,YANEURAOU_EDITION = YANEURAOU_ENGINE_KPPT,#YANEURAOU_EDITION = YANEURAOU_ENGINE_KPPT,\" -e \"s,#YANEURAOU_EDITION = YANEURAOU_ENGINE_KPP_KKPT,YANEURAOU_EDITION = YANEURAOU_ENGINE_KPP_KKPT,\" source/Makefile"
    system "make clean -C source"
    system "make -C source"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_KPP_KKPT"

    prefix.install "YaneuraOu_NNUE", "YaneuraOu_NNUE_KP256", "YaneuraOu_KPPT", "YaneuraOu_KPP_KKPT"
  end

  test do
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE_KP256 | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_KPPT | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_KPP_KKPT | grep 'usiok'")
  end
end
