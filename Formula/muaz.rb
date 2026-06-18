class Muaz < Formula
  desc "AI agent CLI with embedded API and UI"
  homepage "https://github.com/shigar-dev/muaz"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/muaz/releases/download/v0.0.1/muaz-aarch64-apple-darwin.tar.xz"
      sha256 "01f2375887cf3c405945613da3f8ffdd79e50d77850415bed064dda38bfe1a9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/muaz/releases/download/v0.0.1/muaz-x86_64-apple-darwin.tar.xz"
      sha256 "08b4f14958a91d9532bb6fcd14c334b3e4ed7938e1539cdbe2bff6a8b4e6348a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/muaz/releases/download/v0.0.1/muaz-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1fb24c01f86fa39fb91bba99fe17b616e7486d57c6619d421d33bb0edb6f335c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/muaz/releases/download/v0.0.1/muaz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0fd688cb2fe4ae182d11868991b911112decafdd66924e678f07dc50b256028f"
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
