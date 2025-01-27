# stdlib
require "fiddle/import"

# modules
require_relative "kdf/version"

module Argon2
  module KDF
    class Error < StandardError; end

    class << self
      attr_accessor :ffi_lib
    end
    lib_name =
      if Gem.win_platform?
        "argon2.dll"
      elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
        if RbConfig::CONFIG["host_cpu"] =~ /arm|aarch64/i
          "libargon2.arm64.dylib"
        else
          "libargon2.dylib"
        end
      else
        if RbConfig::CONFIG["host_cpu"] =~ /arm|aarch64/i
          "libargon2.arm64.so"
        else
          "libargon2.so"
        end
      end
    vendor_lib = File.expand_path("../../vendor/#{lib_name}", __dir__)
    self.ffi_lib = [vendor_lib]

    # friendlier error message
    autoload :FFI, "argon2/kdf/ffi"

    class << self
      def argon2i(pass, salt:, t:, m:, p:, length:)
        kdf(:argon2i, pass, salt, t, m, p, length)
      end

      def argon2d(pass, salt:, t:, m:, p:, length:)
        kdf(:argon2d, pass, salt, t, m, p, length)
      end

      def argon2id(pass, salt:, t:, m:, p:, length:)
        kdf(:argon2id, pass, salt, t, m, p, length)
      end

      def argon2i_encoded(pass, salt:, t:, m:, p:, length:)
        encoded(:argon2i, pass, salt, t, m, p, length)
      end

      def argon2d_encoded(pass, salt:, t:, m:, p:, length:)
        encoded(:argon2d, pass, salt, t, m, p, length)
      end

      def argon2id_encoded(pass, salt:, t:, m:, p:, length:)
        encoded(:argon2id, pass, salt, t, m, p, length)
      end

      private

      def kdf(variant, pass, salt, t, m, p, length)
        pwd = Fiddle::Pointer[pass.to_str]
        salt = Fiddle::Pointer[salt.to_str]
        hash = Fiddle::Pointer.malloc(length)
        check_status FFI.send("#{variant}_hash_raw", t, 1 << m, p, pwd, pwd.size, salt, salt.size, hash, hash.size)
        hash[0, hash.size]
      end

      ARGON2_TYPES = { :argon2d => 0, :argon2i => 1, :argon2id => 2 }

      def encoded(variant, pass, salt, t, m, p, length)
        pwd = Fiddle::Pointer[pass.to_str]
        salt = Fiddle::Pointer[salt.to_str]
        encodedlen = FFI.send(:argon2_encodedlen, t, 1 << m, p, salt.size, length, ARGON2_TYPES[variant])
        encoded = Fiddle::Pointer.malloc(encodedlen)
        check_status FFI.send("#{variant}_hash_encoded", t, 1 << m, p, pwd, pwd.size, salt, salt.size, length, encoded, encoded.size)
        # Remove terminating null
        encoded[0, encoded.size - 1]
      end

      def check_status(status)
        if status != 0
          raise Error, FFI.argon2_error_message(status).to_s
        end
      end
    end
  end
end
