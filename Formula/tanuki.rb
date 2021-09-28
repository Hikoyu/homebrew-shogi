# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Tanuki < Formula
  desc "tanuki- evaluation function for Shogi (Denryu1 edition)"
  homepage "https://github.com/nodchip/tanuki-"
  url "https://github.com/nodchip/tanuki-/releases/download/tanuki-wcsc31-2021-05-04/tanuki-wcsc31-2021-05-04.7z"
  version "wcsc31"
  sha256 "d3ef4e1d8887ec21f169fc2e28bfbef6d5e2ffec7e8559c9c95bc551692f98fd"
  
  depends_on "p7zip"
  depends_on "yaneuraou"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    author = "Ziosoft, Inc. Computer Shogi Club"
    exe = "#{HOMEBREW_PREFIX}/opt/yaneuraou/YaneuraOu_NNUE"

    system "echo #{name}_#{version} >engine_name.txt"
    system "echo #{author} >>engine_name.txt"
    system "echo '#!/bin/sh' >#{name}"
    system "echo #{exe} >>#{name}"
    system "chmod 755 #{name}"
    prefix.install "eval", "book", "engine_name.txt", "#{name}"
    ohai "[INFO] #{name} is installed in the path below."
    ohai "#{opt_prefix}/#{name}"
  end

  test do
    assert_match 'readyok', shell_output("cd #{prefix} && echo 'isready' | ./#{name} | grep 'readyok'")
  end
end
