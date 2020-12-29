require "bundler/gem_tasks"
require "rake/testtask"

task default: :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
end

def download_file(file)
  require "open-uri"

  url = "https://github.com/ankane/ml-builds/releases/download/argon2-20190702/#{file}"
  puts "Downloading #{file}..."
  dest = "vendor/#{file}"
  File.binwrite(dest, URI.open(url).read)
  puts "Saved #{dest}"
end

namespace :vendor do
  task :linux do
    download_file("libargon2.so")
  end

  task :mac do
    download_file("libargon2.dylib")
    download_file("libargon2.arm64.dylib")
  end

  task :windows do
    download_file("argon2.dll")
  end

  task all: [:linux, :mac, :windows]
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
