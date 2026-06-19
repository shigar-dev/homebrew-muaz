class Muaz < Formula
  desc "AI agent CLI with embedded API and UI"
  homepage "https://github.com/shigar-dev/muaz"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/muaz/releases/download/v0.0.1/muaz-aarch64-apple-darwin.tar.xz"
      sha256 "69ad42acf0ad782e29b46b81155093061ecaabfb93f69eee0f999e18d5067209"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/muaz/releases/download/v0.0.1/muaz-x86_64-apple-darwin.tar.xz"
      sha256 "ae29dc8379787e97b401f417428c26a0207f57366a7c6e0826b61363f2e9bc52"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/muaz/releases/download/v0.0.1/muaz-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7a95ac5c73f223c58b917bf14b87c5770c1c4992f9e2b897995d2a12dd259463"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/muaz/releases/download/v0.0.1/muaz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4c45875e541b32d3e8df4fd5eb6f6f6e1d25b96dd7108fdc7715b51ae673063c"
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
