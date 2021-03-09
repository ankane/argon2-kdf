require "bundler/gem_tasks"
require "rake/testtask"

task default: :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
end

def download_file(file, sha256)
  require "open-uri"

  url = "https://github.com/ankane/ml-builds/releases/download/argon2-20190702/#{file}"
  puts "Downloading #{file}..."
  contents = URI.open(url).read

  computed_sha256 = Digest::SHA256.hexdigest(contents)
  raise "Bad hash: #{computed_sha256}" if computed_sha256 != sha256

  dest = "vendor/#{file}"
  File.binwrite(dest, contents)
  puts "Saved #{dest}"
end

namespace :vendor do
  task :linux do
    download_file("libargon2.so", "5fb6d164f95de57605020ba12998666c64322e6b041eab8bbbf43033af3b3c0a")
  end

  task :mac do
    download_file("libargon2.dylib", "7565ca7b3f1f9a24e028e566586e360489c2f217b739f865528e1891866ee776")
    download_file("libargon2.arm64.dylib", "fcb26cf604385b9a037b74fc228488d5e775cccaa5c602e272c56f68a56e008f")
  end

  task :windows do
    download_file("argon2.dll", "9bd404ab0beafb319c3a7fc020203d31909a71cad51ee9877ce2dfa66a55886d")
  end

  task all: [:linux, :mac, :windows]

  task :platform do
    if Gem.win_platform?
      Rake::Task["vendor:windows"].invoke
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      Rake::Task["vendor:mac"].invoke
    else
      Rake::Task["vendor:linux"].invoke
    end
  end
end

task :benchmark do
  require "argon2/kdf"
  require "benchmark/ips"

  Benchmark.ips do |x|
    x.report("argon2id") do
      Argon2::KDF.argon2id("password", salt: "somesalt", t: 2, m: 16, p: 4, length: 24)
    end
  end
end
