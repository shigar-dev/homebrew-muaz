class Muaz < Formula
  desc "AI agent CLI with embedded API and UI"
  homepage "https://github.com/shigar-dev/releases-muaz"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.1.0/muaz-aarch64-apple-darwin.tar.xz"
      sha256 "331148bd4f326232e4d2d4f5f211d25d32ffbc2db483f017980dda07b604e3bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.1.0/muaz-x86_64-apple-darwin.tar.xz"
      sha256 "8091035e465556003459e4049558644b2ef1b864067ae3f897143f406658d6e3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.1.0/muaz-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1e1be63e811a5dee8975883dfe1e470f78705b0cd36d7f6f5c343579442377ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.1.0/muaz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e5e3bc84fb7f4c439870f2ae86ad6e24b80967e69dfab5c925bd621deb6b85e7"
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
