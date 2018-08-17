defmodule Cobwebhook.GitHub.Signature do
  def sign(secret, data) do
    "sha1=" <> Base.encode16(:crypto.hmac(:sha, secret, data), case: :lower)
  end

  def valid?(signature, secret, data) do
    Plug.Crypto.secure_compare(signature, sign(secret, data))
  end
end
