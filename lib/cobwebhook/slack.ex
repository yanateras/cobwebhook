alias Cobwebhook.Slack.Signature
alias Cobwebhook.Utils

defmodule Cobwebhook.Slack do
  @moduledoc """
    See: <https://api.slack.com/events-api>
  """

  import Plug.Conn

  def init(fun), do: fun

  def call(conn, fun) do
    {:ok, body, conn} = read_body(conn)
    [signature] = get_req_header(conn, "x-slack-signature")
    [timestamp] = get_req_header(conn, "x-slack-request-timestamp")

    secrets = apply(fun, [])

    conn = if secret = Utils.find_first(secrets, &Signature.valid?(signature, &1, {timestamp, body})) do
      conn |> assign(:secret, secret)
    else
      conn |> send_resp(403, "") |> halt()
    end

    payload = case get_req_header(conn, "content-type") do
      ["application/json"] ->
        Poison.decode!(body)
      ["application/x-www-form-urlencoded"] ->
        URI.decode_query(body)
      _ ->
        body
    end

    conn |> assign(:payload, payload)
  end
end
