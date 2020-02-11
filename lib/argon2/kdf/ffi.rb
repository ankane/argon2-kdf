module Argon2
  module KDF
    module FFI
      extend Fiddle::Importer

      libs = Array(Argon2::KDF.ffi_lib).dup
      begin
        dlload Fiddle.dlopen(libs.shift)
      rescue Fiddle::DLError => e
        retry if libs.any?
        raise e
      end

      # https://github.com/P-H-C/phc-winner-argon2/blob/master/include/argon2.h

      if Fiddle::SIZEOF_INT == 4
        typealias "uint32_t", "uint"
      else
        # TODO try to find 4 byte type
        raise "Expected int to be 4 bytes, got #{Fiddle::SIZEOF_INT}"
      end

      extern "int argon2i_hash_raw(uint32_t t_cost, uint32_t m_cost, uint32_t parallelism, void *pwd, size_t pwdlen, void *salt, size_t saltlen, void *hash, size_t hashlen)"
      extern "int argon2d_hash_raw(uint32_t t_cost, uint32_t m_cost, uint32_t parallelism, void *pwd, size_t pwdlen, void *salt, size_t saltlen, void *hash, size_t hashlen)"
      extern "int argon2id_hash_raw(uint32_t t_cost, uint32_t m_cost, uint32_t parallelism, void *pwd, size_t pwdlen, void *salt, size_t saltlen, void *hash, size_t hashlen)"
      extern "char *argon2_error_message(int error_code)"
    end
  end
end
