class Muaz < Formula
  desc "AI agent CLI with embedded API and UI"
  homepage "https://github.com/shigar-dev/releases-muaz"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.4.0/muaz-aarch64-apple-darwin.tar.xz"
      sha256 "bd700e42739f50f301fed706963949972ae9a555743093edb09acb3814d242df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.4.0/muaz-x86_64-apple-darwin.tar.xz"
      sha256 "f5ab593ed5d8cc15f8658d9341e38e3423ec5de88d0b27cc338609fa6b0a71f8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.4.0/muaz-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "abac7264cb70a775197ac0a3f23c1fc10231215e9d7f06046ff6b495f88c11c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.4.0/muaz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d5a40c22f823e197061cd5418197f097936aac29f2a02f51859eaa210dcfbd47"
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
