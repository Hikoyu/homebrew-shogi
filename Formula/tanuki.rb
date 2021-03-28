# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Tanuki < Formula
  desc "tanuki- evaluation function for Shogi (Denryu1 edition)"
  homepage "https://github.com/nodchip/tanuki-"
  url "https://github.com/nodchip/tanuki-/releases/download/tanuki-denryu1/tanuki-denryu1.7z"
  version "denryu1"
  sha256 "ccc28cc60b2c10cdcac17330b52d83ce9158f352512dc56f5f7859955b3c70f4"
  
  depends_on "p7zip"
  depends_on "yaneuraou"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "echo #{name}_#{version} >engine_name.txt"
    system "cp #{HOMEBREW_PREFIX}/opt/yaneuraou/YaneuraOu_NNUE #{name}"
    prefix.install "eval", "book", "engine_name.txt", "#{name}"
    ohai "[INFO] #{name} is installed in the path below."
    ohai "#{opt_prefix}/#{name}"
  end

  test do
    assert_match 'readyok', shell_output("cd #{prefix} && echo 'isready' | ./#{name} | grep 'readyok'")
  end
end
