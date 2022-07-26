class Drogon < Formula
  desc "HTTP(S) Web Application Framework (C++14/17 based)"
  homepage "https://drogon.docsforge.com"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.7.5",
      revision: "fc68b8c92c8c202d8cc58d83629d6e8c8701fc47"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git"

  depends_on "cmake" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "openssl@1.1"
  depends_on "ossp-uuid"
  depends_on "zlib"

  def install
    # TODO: Verify Parallelization - https://github.com/drogonframework/homebrew-drogon/issues/4
    system "cmake", "-B", "build", "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dg_ctl", "create", "project", "hello"
    cd "hello" do
      system "cmake", "-B", "build", "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}"
      system "cmake", "--build", "build"

      begin
        pid = fork { exec "build/hello" }
        sleep 1
        result = shell_output("curl -s 127.0.0.1")
        assert_match "<hr><center>drogon", result
      ensure
        Process.kill("SIGINT", pid)
        Process.wait(pid)
      end
    end
  end
end
