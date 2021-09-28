# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Takeshi < Formula
  desc "Takeshi, furi-bisha evaluation function for Shogi"
  homepage "https://twitter.com/floodgate_mania"
  url "https://drive.google.com/u/0/uc?export=download&id=1X32zvm7raFH9iK-_PHWxoOigvj_HuyEK"
  version "20210101"
  sha256 "5e3c9d7a3b1963b41bc21b23d7f7dc1e34ee6efe2fa767988a27eb35e53c5d7c"
  
  depends_on "p7zip"
  depends_on "yaneuraou"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    author = "frenzy"
    exe = "#{HOMEBREW_PREFIX}/opt/yaneuraou/YaneuraOu_NNUE"

    system "mv Takeshi-20210101 eval"
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
