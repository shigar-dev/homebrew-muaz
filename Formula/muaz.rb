class Muaz < Formula
  desc "AI agent CLI with embedded API and UI"
  homepage "https://github.com/shigar-dev/releases-muaz"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.5.0/muaz-aarch64-apple-darwin.tar.xz"
      sha256 "cc76bf8bd65357b42052840aba265c48eb91569d24db5262428b6ac77967dcd3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.5.0/muaz-x86_64-apple-darwin.tar.xz"
      sha256 "02010693a40e1434ecb8492289a121ca37bd7699d21895b96af7fb63e2edf34e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.5.0/muaz-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e13dcf81c2c95f98b2679749a8a6a28cf0e310aa1d303df22641f88b5351583d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.5.0/muaz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "680db94fa3220d1da17fc03ad1142fe4e99f15af205d58a299fd3904ab8f798b"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "muaz"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "muaz"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "muaz"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "muaz"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
