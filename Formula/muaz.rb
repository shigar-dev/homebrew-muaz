class Muaz < Formula
  desc "AI agent CLI with embedded API and UI"
  homepage "https://github.com/shigar-dev/releases-muaz"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.2.0/muaz-aarch64-apple-darwin.tar.xz"
      sha256 "f7b38d022e09d91bf3be4e5115340b0c1a41ec814d9e62071eeb922bff1952de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.2.0/muaz-x86_64-apple-darwin.tar.xz"
      sha256 "dc1b45f03643af569a48f85d758742faff1515b51c15e5844856c761868b4dfa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.2.0/muaz-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e51046f196f0833bfdd71cddf7a46a10966980735503c3bd73ddb47bb978d991"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shigar-dev/releases-muaz/releases/download/v0.2.0/muaz-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa1c41bf135ff0510268c388158d8586a6bf05fe1c412812ef2c4d4e03d9859a"
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
