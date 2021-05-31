# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Drogon < Formula
  desc "HTTP(S) Web Application Framework (C++14/17 based)"
  homepage "https://drogon.docsforge.com"
  license "MIT"
  url "https://github.com/an-tao/drogon/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "9f8802b579aac29e9eddfb156e432276727a3d3c49fffdf453a2ddcd1cb69093"
  head "https://github.com/an-tao/drogon.git"

  resource "trantor" do
    url "https://github.com/an-tao/trantor.git",
        revision: "941dc48384bd14a2b6a14f3a0dba7b7453d91ed5"
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp"
  depends_on "ossp-uuid"
  depends_on "openssl@1.1"
  depends_on "zlib"
  depends_on "c-ares"
  depends_on "brotli"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    # system "./configure", *std_configure_args, "--disable-silent-rules"
    # head gets trantor as a git submodule
    (buildpath/"trantor").install resource("trantor")
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Release", "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}", *std_cmake_args
    cd "build" do
      system "make"
      system "make", "install"
    end
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
