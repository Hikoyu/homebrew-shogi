# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Suisho < Formula
  desc ""
  homepage ""
  url "https://github.com/HiraokaTakuya/get_suisho5_nn.git"
  version "5"
  sha256 "f21f6e263736339202f06befc3a7e3b3f7d87519193a9487b61319f1b9997fe1"

  depends_on "yaneuraou"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    author = "Tatsuya Sugimura, Takuya Hiraoka"
    exe = "#{HOMEBREW_PREFIX}/opt/yaneuraou/YaneuraOu_NNUE"

    system("mv suisho5_nn eval")
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
