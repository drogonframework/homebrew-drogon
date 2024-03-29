class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.0",
      revision: "f215cb15a0f53abd0ca7ee8b95ed8c9c3b40d262"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "ossp-uuid"
  depends_on "zlib"

  def install
    cmake_args = std_cmake_args
    if OS.linux?
      cmake_args << "-DUUID_LIBRARIES=uuid"
      cmake_args << "-DUUID_INCLUDE_DIRS=#{Formula["ossp-uuid"].opt_include}/ossp"
    end

    system "cmake", "-B", "build", *cmake_args
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
        result = shell_output("curl -s 127.0.0.1:5555")
        assert_match "<hr><center>drogon", result
      ensure
        Process.kill("SIGINT", pid)
        Process.wait(pid)
      end
    end
  end
end
