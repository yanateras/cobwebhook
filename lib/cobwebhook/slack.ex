defmodule Cobwebhook.Slack do
  @moduledoc ~S"""
  See: <https://api.slack.com/events-api>
  """

  use Cobwebhook.Adapter

  def parse(conn, body) do
    case get_req_header(conn, "content-type") do
      ["application/json"] ->
        Jason.decode!(body)
      ["application/x-www-form-urlencoded"] ->
        URI.decode_query(body)
    end
  end

  defp data(timestamp, body) do
    Enum.join(["v0", timestamp, body], ":")
  end

  defp sign(data, secret) do
    "v0=" <> Base.encode16(:crypto.hmac(:sha256, secret, data), case: :lower)
  end

  def verify(conn, body, secret) do
    [signature] = get_req_header(conn, "x-slack-signature")
    [timestamp] = get_req_header(conn, "x-slack-request-timestamp")

    Plug.Crypto.secure_compare(signature, data(timestamp, body) |> sign(secret))
  end
end
