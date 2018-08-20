defmodule Cobwebhook.GitHub do
  @moduledoc """
    See: <https://developer.github.com/webhooks/>
  """

  use Cobwebhook.Adapter

  def parse(_conn, body) do
    Poison.decode!(body)
  end

  defp sign(data, secret) do
    "sha1=" <> Base.encode16(:crypto.hmac(:sha, secret, data), case: :lower)
  end

  def verify(conn, body, secret) do
    [signature] = get_req_header(conn, "x-hub-signature")
    Plug.Crypto.secure_compare(signature, sign(body, secret))
  end
end
