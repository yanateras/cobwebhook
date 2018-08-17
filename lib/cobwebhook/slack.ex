alias Cobwebhook.Slack.Signature
alias Cobwebhook.Utils

defmodule Cobwebhook.Slack do
  @moduledoc """
    See: <https://api.slack.com/events-api>
  """

  import Plug.Conn

  def init(secrets), do: secrets

  def call(conn, secrets) do
    {:ok, body, conn} = read_body(conn)
    [signature] = get_req_header(conn, "x-slack-signature")
    [timestamp] = get_req_header(conn, "x-slack-request-timestamp")

    if secret = Utils.find_first(secrets, &Signature.valid?(signature, &1, {timestamp, body})) do
      conn |> assign(:payload, Poison.decode!(body)) |> assign(:secret, secret)
    else
      conn |> send_resp(403, "") |> halt()
    end
  end
end
