# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class BurningBridges < Formula
  desc "BURNING BRIDGES evaluation function for Shogi (Denryu1 edition)"
  homepage "https://twitter.com/floodgate_mania"
  url "https://drive.google.com/u/0/uc?export=download&id=1JBzBFZzB-O1763n9aW8G8YQVk3jZweYO"
  version "denryu1"
  sha256 "b8b0e7613b6d8c5216b0ff1a9eeb0a802015f6e040219582eafdcb6940ec1c0e"
  
  depends_on "p7zip"
  depends_on "yaneuraou"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "mv BB_denryu-tsec1 eval"
    system "echo #{name}_#{version} >engine_name.txt"
    system "cp #{HOMEBREW_PREFIX}/opt/yaneuraou/YaneuraOu_NNUE #{name}"
    prefix.install "eval", "engine_name.txt", "#{name}"
    ohai "[INFO] #{name} is installed in the path below."
    ohai "#{opt_prefix}/#{name}"
  end

  test do
    assert_match 'readyok', shell_output("cd #{prefix} && echo 'isready' | ./#{name} | grep 'readyok'")
  end
end
