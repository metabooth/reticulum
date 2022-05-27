defmodule RetWeb.Plugs.Empty do
  alias Plug.Conn

  def init([]), do: []

  def call(%Conn{method: "HEAD"} = conn, []) do
    call(conn, _opts) do
      conn
      |> Plug.Conn.send_resp(200, [])
      |> Plug.Conn.halt()
  end

  def call(conn, []), do: conn
end
