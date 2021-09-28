# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class UonumaYaneuraou < Formula
  desc "YaneuraOu is the World's Strongest Shogi engine(AI player) , WCSC29 1st winner , educational and USI compliant engine."
  homepage "http://yaneuraou.yaneu.com"
  url "https://github.com/yaneurao/YaneuraOu/releases/download/20190212_k-p-256-32-32/20190212_k-p-256-32-32.zip"
  version "20190212"
  sha256 "e8d7359a8648acfadfba6ef87ff129e4466091643e6094a1b1a82c91e640eebb"

  depends_on "yaneuraou"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    author = "yaneurao"
    exe = "#{HOMEBREW_PREFIX}/opt/yaneuraou/YaneuraOu_NNUE_KP256"

    system "mkdir eval"
    system "mv nn.bin eval"
    system "echo #{name}_#{version} >engine_name.txt"
    system "echo #{author} >>engine_name.txt"
    system "echo '#!/bin/sh' >#{name}"
    system "echo #{exe} >>#{name}"
    system "chmod 755 #{name}"
    prefix.install "eval", "engine_name.txt", "#{name}"
    ohai "[INFO] #{name} is installed in the path below."
    ohai "#{opt_prefix}/#{name}"
  end

  test do
    assert_match 'readyok', shell_output("cd #{prefix} && echo 'isready' | ./#{name} | grep 'readyok'")
  end
end
