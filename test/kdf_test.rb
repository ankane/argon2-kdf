require_relative "test_helper"

class KDFTest < Minitest::Test
  def test_argon2i
    hash = Argon2::KDF.argon2i("password", salt: "somesalt", t: 2, m: 16, p: 4, length: 24)
    assert_equal "45d7ac72e76f242b20b77b9bf9bf9d5915894e669a24e6c6", to_hex(hash)
  end

  def test_argon2d
    hash = Argon2::KDF.argon2d("password", salt: "somesalt", t: 2, m: 16, p: 4, length: 24)
    assert_equal "eca9fa5768a652e68591998a7592dbde7be0f753792edec7", to_hex(hash)
  end

  def test_argon2id
    hash = Argon2::KDF.argon2id("password", salt: "somesalt", t: 2, m: 16, p: 4, length: 24)
    assert_equal "1758c6d82577fcdafec91b88b0f2b0d09f6be2cedc247054", to_hex(hash)
  end

  def test_invalid_salt
    error = assert_raises(Argon2::KDF::Error) do
      Argon2::KDF.argon2i("password", salt: "salt", t: 3, m: 16, p: 4, length: 24)
    end
    assert_equal "Salt is too short", error.message
  end

  def test_invalid_t
    error = assert_raises(Argon2::KDF::Error) do
      Argon2::KDF.argon2i("password", salt: "somesalt", t: 0, m: 16, p: 4, length: 24)
    end
    assert_equal "Time cost is too small", error.message
  end

  def test_invalid_m
    error = assert_raises(Argon2::KDF::Error) do
      Argon2::KDF.argon2i("password", salt: "somesalt", t: 3, m: 0, p: 4, length: 24)
    end
    assert_equal "Memory cost is too small", error.message
  end

  def test_invalid_p
    error = assert_raises(Argon2::KDF::Error) do
      Argon2::KDF.argon2i("password", salt: "somesalt", t: 3, m: 16, p: 0, length: 24)
    end
    assert_equal "Too few lanes", error.message
  end

  def test_invalid_length
    error = assert_raises(Argon2::KDF::Error) do
      Argon2::KDF.argon2i("password", salt: "somesalt", t: 3, m: 16, p: 4, length: 0)
    end
    assert_equal "Output is too short", error.message
  end

  private

  def to_hex(str)
    str.unpack1("H*")
  end
end
