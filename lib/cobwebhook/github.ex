alias Cobwebhook.GitHub.Signature
alias Cobwebhook.Utils

defmodule Cobwebhook.GitHub do
  @moduledoc """
    See: <https://developer.github.com/webhooks/>
  """

  import Plug.Conn

  def init(fun), do: fun

  def call(conn, fun) do
    {:ok, body, conn} = read_body(conn)
    [signature] = get_req_header(conn, "x-hub-signature")

    secrets = apply(fun, [])

    if secret = Utils.find_first(secrets, &Signature.valid?(signature, &1, body)) do
      conn
      |> assign(:payload, Poison.decode!(body))
      |> assign(:secret, secret)
    else
      conn |> send_resp(403, "") |> halt()
    end
  end
end
