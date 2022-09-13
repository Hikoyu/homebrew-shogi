# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Yaneuraou < Formula
  desc "YaneuraOu is the World's Strongest Shogi engine(AI player) , WCSC29 1st winner , educational and USI compliant engine."
  homepage "http://yaneuraou.yaneu.com"
  url "https://github.com/yaneurao/YaneuraOu/archive/refs/tags/v7.50-wcsc32.tar.gz"
  version "7.50"
  sha256 "8d1f65cee1c628c0da70754cf5ae52b3c5c7f1ea21ea27ccdbb86db1a62f171a"
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

    editions = {
      "YANEURAOU_ENGINE_NNUE" => "YaneuraOu_NNUE",
      "YANEURAOU_ENGINE_NNUE_KP256" => "YaneuraOu_NNUE_KP256",
      "YANEURAOU_ENGINE_NNUE_HALFKPE9" => "YaneuraOu_NNUE_HALFKPE9",
      "YANEURAOU_ENGINE_NNUE_HALFKP_VM_256X2_32_32" => "YaneuraOu_NNUE_HALFKP_VM_256X2_32_32",
      "YANEURAOU_MATE_ENGINE" => "YaneuraOu_MATE"
    }
	
    editions.each do |ed, exe|
      system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} YANEURAOU_EDITION=#{ed}"
      system "mv source/YaneuraOu-by-gcc #{exe}"
      system "make -C source clean"
    end

    prefix.install editions.values
  end

  test do
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE_KP256 | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE_HALFKPE9 | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE_HALFKP_VM_256X2_32_32 | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_MATE | grep 'usiok'")
  end
end
