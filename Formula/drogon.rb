class Drogon < Formula
  desc "HTTP(S) Web Application Framework (C++14/17 based)"
  homepage "https://drogon.docsforge.com"
  license "MIT"
  url "https://github.com/drogonframework/drogon/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "7c19846914785116298d9c5d0d3f3fd9d2a3cbd4410ee70c6852fe232f6adb1b"
  head "https://github.com/an-tao/drogon.git", branch: "master"

  resource "trantor" do
    url "https://github.com/an-tao/trantor/archive/refs/tags/v1.5.4.tar.gz"
    sha256 "c9a24d52185daa492f9fa7fd263da4e77bf2649224114f99f2d653c65b3ec6fd"
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp"
  depends_on "ossp-uuid"
  depends_on "openssl@1.1"
  depends_on "zlib"
  depends_on "c-ares"
  depends_on "brotli"

  def install
    (buildpath/"trantor").install resource("trantor")
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Release", "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}", *std_cmake_args
    cd "build" do
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"drogon.cpp").write <<~EOS
      #include <drogon/HttpAppFramework.h>
      int main() {
        //Set HTTP listener address and port
        drogon::app().addListener("0.0.0.0",80);
        //Run HTTP framework,the method will block in the internal event loop
        drogon::app().run();
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", testpath/"drogon.cpp", "-o", "drogon",
           "-I#{include}",
           "-L#{lib}",
           "-ldrogon"
    system "./drogon"
  end
end