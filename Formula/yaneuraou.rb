# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Yaneuraou < Formula
  desc "YaneuraOu is the World's Strongest Shogi engine(AI player) , WCSC29 1st winner , educational and USI compliant engine."
  homepage "http://yaneuraou.yaneu.com"
  url "https://github.com/yaneurao/YaneuraOu/archive/refs/tags/v6.50.tar.gz"
  version "6.50"
  sha256 "cdf3d6f6b1222e3f273a03cd8d2aae6392e49a024e1742dbdbc3b93912c30a41"
  license "GPL-3.0"

  depends_on "gnu-sed"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "gsed -i -e \"s,-march=corei7-avx,-march=core-avx2,\" source/Makefile"

    cpu = "OTHER"
    cpu = "SSE2" if Hardware::CPU.intel?
    cpu = "SSE41" if Hardware::CPU.sse4?
    cpu = "SSE42" if Hardware::CPU.sse4_2?
    cpu = "AVX2" if Hardware::CPU.avx2?

    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_NNUE"
    system "make -C source clean"

    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE_KP256"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_NNUE_KP256"
    system "make -C source clean"

    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE_HALFKPE9"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_NNUE_HALFKPE9"
    system "make -C source clean"

    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} YANEURAOU_EDITION=YANEURAOU_MATE_ENGINE"
    system "mv source/YaneuraOu-by-gcc YaneuraOu_MATE"
    system "make -C source clean"

    prefix.install "YaneuraOu_NNUE", "YaneuraOu_NNUE_KP256", "YaneuraOu_NNUE_HALFKPE9", "YaneuraOu_MATE"
  end

  test do
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE_KP256 | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE_HALFKPE9 | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_MATE | grep 'usiok'")
  end
end
