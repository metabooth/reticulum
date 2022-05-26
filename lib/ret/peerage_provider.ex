defmodule Ret.PeerageProvider do
  alias Ret.Habitat

  def poll do
    #FIXME
    #Habitat.get_service_members("reticulum")
    Habitat.get_service_members(nil)
    |> Enum.map(fn {host, _ip} -> host |> hostname_to_erlang_node end)
    |> Enum.filter(&(&1 != Node.self()))
  end

  defp hostname_to_erlang_node(hostname) do
    [name | tail] = String.split(hostname, ".")
    Enum.join(["ret@#{name}-local" | tail], ".") |> :erlang.binary_to_atom(:utf8)
  end
end
