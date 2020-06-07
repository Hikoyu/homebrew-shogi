# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Yaneuraou < Formula
  desc "YaneuraOu is the World's Strongest Shogi engine(AI player) , WCSC29 1st winner , educational and USI compliant engine."
  homepage "http://yaneuraou.yaneu.com"
  url "https://github.com/yaneurao/YaneuraOu/archive/V4.91.tar.gz"
  version "4.91"
  sha256 "db13f249d55aa8a5a0c75d4fccb8750446345dd937f4c2cf1326341bf53a84d5"

  depends_on "gnu-sed"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    system "gsed -i -e \"s,CFLAGS += -stdlib=libstdc++,CFLAGS += -stdlib=libc++,\" source/Makefile"
    if Hardware::CPU.is_32_bit? then
      target_cpu_list = ['NO_SSE']
    else 
      target_cpu_list = ['AVX2', 'SSE42', 'SSE41', 'SSE2', 'OTHER']
    end

    target_cpu_list.each do |target_cpu|
      system "make -C source clean"
      system "make -C source TARGET_CPU=#{target_cpu} YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE"
      system "mv source/YaneuraOu-by-gcc YaneuraOu_NNUE"
      begin
        system "echo 'usi' | ./YaneuraOu_NNUE | grep 'usiok'"

        system "make -C source clean"
        system "make -C source TARGET_CPU=#{target_cpu} YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE_KP256"
        system "mv source/YaneuraOu-by-gcc YaneuraOu_NNUE_KP256"

        prefix.install "YaneuraOu_NNUE", "YaneuraOu_NNUE_KP256"
        return
      rescue
      end
    end
    raise "Can't Install"
  end

  test do
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE | grep 'usiok'")
    assert_match 'usiok', shell_output("cd #{prefix} && echo 'usi' | ./YaneuraOu_NNUE_KP256 | grep 'usiok'")
  end
end
