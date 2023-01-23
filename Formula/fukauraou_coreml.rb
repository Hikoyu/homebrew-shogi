# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class FukauraouCoreml < Formula
  desc "YaneuraOu is the World's Strongest Shogi engine(AI player) , WCSC29 1st winner , educational and USI compliant engine."
  homepage "https://github.com/select766/FukauraOu-CoreML"
  url "https://github.com/select766/FukauraOu-CoreML/archive/refs/tags/coreml-sample-20220613.tar.gz"
  version "20220613"
  sha256 "1b78d1fb923a8c4352830ad19e2d17e4f1cfb74dc97a01906f7c620531928b2e"
  license "GPL-3.0"

  depends_on "gnu-sed"

  resource "fukauraou-coreml-model" do
    url "https://github.com/select766/FukauraOu-CoreML/releases/download/coreml-sample-20220613/DlShogiResnet15x224SwishBatch.mlmodel"
    sha256 "803c49bbdd3adfd70383b60f14e5b46e8f31ebf939ce5896372162f3c6f4ec55"
  end

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    author = "select766, yaneurao"
    exe = "FukauraOu-CoreML"

    system "gsed -i -e \"s,-march=corei7-avx,-march=core-avx2,\" source/Makefile"

    odie "[ERROR] Your CPU is not 64-bit!" unless Hardware::CPU.is_64_bit?
    ohai "[INFO] Your CPU is Intel processor." if Hardware::CPU.intel?
    odie "[ERROR] Your CPU does not support SSE4.2 instruction set!" if Hardware::CPU.intel? && !Hardware::CPU.sse4_2?
    cpu = "APPLESSE42" and ohai "[INFO] Your CPU supports SSE4.2 instruction set." if Hardware::CPU.intel? && Hardware::CPU.sse4_2?
    cpu = "APPLEAVX2" and ohai "[INFO] Your CPU supports AVX2 instruction set." if Hardware::CPU.intel? && Hardware::CPU.avx2?
    cpu = "APPLEM1" and ohai "[INFO] Your CPU is Apple M processor." if Hardware::CPU.arm?

    system "make -C source COMPILER=g++ TARGET_CPU=#{cpu} YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_COREML"
    system "mv source/YaneuraOu-by-gcc #{exe}"
    system "make -C source clean"

    resource("fukauraou-coreml-model").fetch
    system "mkdir eval"
    system "mv", resource("fukauraou-coreml-model").downloader.cached_location, "eval/model.mlmodel"

    system "echo #{name}_#{version} >engine_name.txt"
    system "echo #{author} >>engine_name.txt"

    prefix.install "eval", "engine_name.txt", "#{exe}"
    ohai "[INFO] #{name} is installed in the path below."
    ohai "#{opt_prefix}/#{exe}"
  end

  test do
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./FukauraOu-CoreML | grep 'usiok'")
    assert_match 'Compiling model', shell_output("cd #{prefix} && echo 'isready' | ./FukauraOu-CoreML | grep 'Compiling model'") unless Dir.exist?("#{opt_prefix}/eval/model.mlmodelc")
    assert_match 'readyok', shell_output("cd #{prefix} && echo 'isready' | ./FukauraOu-CoreML | grep 'readyok'") if Dir.exist?("#{opt_prefix}/eval/model.mlmodelc")
  end
end
