# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Gikou < Formula
  desc "Shogi AI 'Gikou'"
  homepage "https://github.com/gikou-official/Gikou"
  url "https://github.com/gikou-official/Gikou/archive/v2.0.2.tar.gz"
  version "2.0.2"
  sha256 "2e018c8ed0eafa7c1695ed1ccb0e4564661eb106855b3ebd3b27745b3afd08d1"

  depends_on "gnu-sed"
  depends_on "unar"
  depends_on "libomp"

  resource "Gikou2_win" do
    url "https://github.com/gikou-official/Gikou/releases/download/v2.0.2/gikou2_win.zip"
    sha256 "3bbb667bfd77e0236b052593b5c61b7fe1827ed72b5b5f437760c60974852757"
  end

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    cpu = "sse4.1" if Hardware::CPU.sse4?
    cpu = "sse4.2" if Hardware::CPU.sse4_2?
    cpu = "avx2" if Hardware::CPU.avx2?

    system "gsed -i -e \"s,-msse4.2,-m#{cpu},\" Makefile"
    system "gsed -i -e \"s,-fopenmp,-Xpreprocessor -fopenmp,\" Makefile"
    system "gsed -i -e \"s,-lpthread,-L/opt/intelbrew/lib -lomp -lpthread,\" Makefile"
    system "make INCLUDES=-I#{HOMEBREW_PREFIX}/include release"
    system "mv bin/release #{name}"

    resource("Gikou2_win").fetch
    system "cp", resource("Gikou2_win").downloader.cached_location, "gikou2_win.zip"
    system "unar gikou2_win.zip Copying.txt Readme.md.txt gikou_ja.txt *.bin"
    prefix.install "#{name}", Dir["gikou2_win/*"]
    ohai "[INFO] #{name} is installed in the path below."
    ohai "#{opt_prefix}/#{name}"
  end

  test do
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./#{name} | grep 'usiok'")
    assert_match 'readyok', shell_output("cd #{prefix} && echo 'isready' | ./#{name} | grep 'readyok'")
  end
end
