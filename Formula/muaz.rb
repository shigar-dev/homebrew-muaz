class Muaz < Formula
  desc "AI agent CLI with embedded API and UI"
  homepage "https://github.com/shigar-dev/releases-muaz"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.3.0/muaz-aarch64-apple-darwin.tar.xz"
      sha256 "2bc2fdd4c5f84d7fe0cdab67c4706601a92c12a2dbba79bb370787bdc8d4a64b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.3.0/muaz-x86_64-apple-darwin.tar.xz"
      sha256 "c7bba9aea5fcbe2e4a6a181b777423cb516afdc379678b460d61eb4093ca874a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.3.0/muaz-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b1067cf206745bbd143cfcafe7f91c436faf548e0452b51b73f51315eac81d8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.3.0/muaz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "45a564fe65a297a4889fd5dc927de49f37e433565a64538cb5006329f6a4f6d9"
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
    bin.install "muaz" if OS.mac? && Hardware::CPU.arm?
    bin.install "muaz" if OS.mac? && Hardware::CPU.intel?
    bin.install "muaz" if OS.linux? && Hardware::CPU.arm?
    bin.install "muaz" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
