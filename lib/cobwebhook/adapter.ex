defmodule Cobwebhook.Adapter do
  @type secret :: String.t()
  @type secrets :: List.t(secret()) | MapSet.t(secret())

  @doc ~S"""
  Parse trusted body into params.
  """
  @callback parse(conn :: Plug.Conn.t(), body :: Plug.Conn.body()) :: map()

  @doc ~S"""
  Check if request was signed with the given secret.
  """
  @callback verify(conn :: Plug.Conn.t(), body :: Plug.Conn.body(), secret :: secret()) :: boolean()

  defmacro __using__([]) do
    quote location: :keep do
      @behaviour Cobwebhook.Adapter
      @behaviour Plug

      import Plug.Conn

      @spec init((-> Cobwebhook.Adapter.secrets())) :: (-> Cobwebhook.Adapter.secrets())
      def init(secrets_getter), do: secrets_getter

      @spec call(Plug.Conn.t(), (-> Cobwebhook.Adapter.secrets())) :: Plug.Conn.t()
      def call(conn, secrets_getter) do
        {:ok, body, conn} = read_body(conn)

        secret =
          apply(secrets_getter, [])
          |> Enum.filter(&verify(conn, body, &1))
          |> List.first()

        if secret do
	  conn
	  |> Map.put(:body_params, parse(conn, body))
	  |> assign(:secret, secret)
        else
          conn |> send_resp(403, "") |> halt()
        end
      end
    end
  end
end
