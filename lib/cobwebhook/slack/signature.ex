defmodule Cobwebhook.Slack.Signature do
  defp input({timestamp, body}) do
    Enum.join(["v0", timestamp, body], ":")
  end

  def sign(secret, data) do
    "v0=" <> Base.encode16(:crypto.hmac(:sha256, secret, input(data)), case: :lower)
  end

  def valid?(signature, secret, data) do
    Plug.Crypto.secure_compare(signature, sign(secret, data))
  end
end
