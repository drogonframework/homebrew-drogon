class Drogon < Formula
  desc "HTTP(S) Web Application Framework (C++14/17 based)"
  homepage "https://drogon.docsforge.com"
  url "https://github.com/drogonframework/drogon/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "a682fafc3619ba69d3d9278a80f6a386d1effcc3692b47e976de7cf9ff89d6b8"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git"

  depends_on "cmake" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "openssl@1.1"
  depends_on "ossp-uuid"
  depends_on "zlib"

  resource "trantor" do
    url "https://github.com/an-tao/trantor.git",
        revision: "bef06c4f5e2dfc80303aee06a12770d09d5e8f5b"
  end

  def install
    # TODO: Verify Parallelization - https://github.com/drogonframework/homebrew-drogon/issues/4
    # head gets trantor as a git submodule
    (buildpath/"trantor").install resource("trantor")
    system "cmake", "-B", "build", "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test drogon`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
