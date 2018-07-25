defmodule Cobwebhook.GitHub.Signature do
  def calculate(payload, secret) do
    :crypto.hmac(:sha, secret, payload)
  end

  def encode(bytes) do
    "sha1=" <> Base.encode16(bytes, case: :lower)
  end

  def verify(payload, secret, signature) do
    Plug.Crypto.secure_compare(signature, encode(calculate(payload, secret)))
  end
end
