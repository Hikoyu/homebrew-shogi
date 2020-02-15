# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class UonumaYaneuraou < Formula
  desc "YaneuraOu is the World's Strongest Shogi engine(AI player) , WCSC29 1st winner , educational and USI compliant engine."
  homepage ""
  url "https://github.com/yaneurao/YaneuraOu/releases/download/20190212_k-p-256-32-32/20190212_k-p-256-32-32.zip"
  version "20190212"
  sha256 "e8d7359a8648acfadfba6ef87ff129e4466091643e6094a1b1a82c91e640eebb"

  depends_on "yaneuraou"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "mkdir eval"
    system "mv nn.bin eval"
    system "cp #{HOMEBREW_PREFIX}/opt/yaneuraou/YaneuraOu_NNUE_KP256 Uonuma-YaneuraOu_#{version}"
    system "echo Uonuma-YaneuraOu_#{version} >engine_name.txt"
    prefix.install "eval", "Uonuma-YaneuraOu_#{version}", "engine_name.txt"
    ohai "[INFO] Copy and paste the path below to the box for defining Shogi engine in GUI software."
    ohai "#{prefix}/Uonuma-YaneuraOu_#{version}"
  end

  test do
    assert_match 'readyok', shell_output("cd #{prefix} && echo 'isready' | ./Uonuma-YaneuraOu_#{version} | grep 'readyok'")
  end
end
