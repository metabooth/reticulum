defmodule RetWeb.Plugs.Empty do
  require Logger
  alias Plug.Conn

  def init([]), do: []

  def call(conn, _opts) do
      Logger.debug("FIXME: Empty response ...")
      conn
      |> Plug.Conn.send_resp(200, [])
      |> Plug.Conn.halt()
  end

  def call(conn, []), do: conn
end
