# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Yaneuraou < Formula
  desc "YaneuraOu is the World's Strongest Shogi engine(AI player) , WCSC29 1st winner , educational and USI compliant engine."
  homepage "http://yaneuraou.yaneu.com"
  url "https://github.com/yaneurao/YaneuraOu/archive/refs/tags/v7.00.tar.gz"
  version "7.00"
  sha256 "3547a074f0ca74610e3fcab40f51c2da85ff7056f0471bc6d371956daf03bfde"
  license "GPL-3.0"

  depends_on "gnu-sed"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "gsed -i -e \"s,-march=corei7-avx,-march=core-avx2,\" source/Makefile"

    odie "[ERROR] Your CPU is not 64-bit!" unless Hardware::CPU.is_64_bit?
    odie "[ERROR] Your CPU does not support SSSE3 instruction set!" unless Hardware::CPU.ssse3?
    cpu = "SSSE3" and ohai "[INFO] Your CPU supports SSSE3 instruction set." if Hardware::CPU.ssse3?
    cpu = "SSE41" and ohai "[INFO] Your CPU supports SSE4.1 instruction set." if Hardware::CPU.sse4?
    cpu = "SSE42" and ohai "[INFO] Your CPU supports SSE4.2 instruction set." if Hardware::CPU.sse4_2?
    cpu = "AVX2" and ohai "[INFO] Your CPU supports AVX2 instruction set." if Hardware::CPU.avx2?

    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_NNUE"
    system "make -C source clean"

    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE_KP256"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_NNUE_KP256"
    system "make -C source clean"

    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE_HALFKPE9"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_NNUE_HALFKPE9"
    system "make -C source clean"

    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE_HALFKP_VM_256X2_32_32"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_NNUE_HALFKP_VM_256X2_32_32"
    system "make -C source clean"

    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} YANEURAOU_EDITION=YANEURAOU_MATE_ENGINE"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_MATE"
    system "make -C source clean"

    prefix.install "YaneuraOu_NNUE", "YaneuraOu_NNUE_KP256", "YaneuraOu_NNUE_HALFKPE9", "YaneuraOu_NNUE_HALFKP_VM_256X2_32_32", "YaneuraOu_MATE"
  end

  test do
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE_KP256 | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE_HALFKPE9 | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE_HALFKP_VM_256X2_32_32 | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_MATE | grep 'usiok'")
  end
end
