class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.8.5",
      revision: "83e08f4b2732e9f3d58f71379d3f7e117cb9180e"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git"

  depends_on "cmake" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "ossp-uuid"
  depends_on "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dg_ctl", "create", "project", "hello"
    cd "hello" do
      system "cmake", "-B", "build"
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
