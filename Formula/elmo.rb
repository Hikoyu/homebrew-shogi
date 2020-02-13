# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Elmo < Formula
  desc "elmo evaluation function for Shogi (WCSC29 edition)"
  homepage "https://mk-takizawa.github.io/elmo/howtouse_elmo.html"
  url "https://drive.google.com/uc?export=download&id=1geE42yhY8fAG-ouEUx7_u6HQw1OjBQ2O"
  version "wcsc29"
  sha256 "d3a938a024cfe654bbd56c7b63a7dae211ee6a5aa508ac9b08308cd73c56b91a"
  
  depends_on "p7zip"
  depends_on "yaneuraou"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    system "mkdir eval"
    system "mv nn.bin eval"
    system "cp #{HOMEBREW_PREFIX}/opt/yaneuraou/bin/YaneuraOu YaneuraOu_elmo_wcsc29"
    system "echo elmo_wcsc29 >engine_name.txt"
    prefix.install "eval", "YaneuraOu_elmo_wcsc29", "engine_name.txt"
  end

  test do
    assert_match 'readyok', shell_output("cd #{prefix} && echo 'isready' | ./YaneuraOu_elmo_wcsc29 | tail -n 1")
  end
end
