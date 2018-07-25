alias Cobwebhook.GitHub.Signature

defmodule Cobwebhook.GitHub do
  import Plug.Conn

  def init(options) do: options.secrets

  def call(conn, []) do
    {:ok, body, conn} = read_body(conn)
    secret = "aloha"
    [signature] = get_req_header(conn, "x-hub-signature")

    if Signature.verify(body, secret, signature) do
      assign(conn, :payload, Poison.decode!(body))
    else
      conn |> send_resp(403, "") |> halt()
    end
  end
end
