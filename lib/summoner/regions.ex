defmodule Summoner.Regions do
  @americas ~w(na br lan las oce)
  @asia ~w(kr jp)
  @europe ~w(eune euw tr ru)

  @region_to_subdomain_map %{
    "br" => "br1",
    "eune" => "eun1",
    "euw" => "euw1",
    "jp" => "jp1",
    "kr" => "kr",
    "lan" => "la1",
    "las" => "la2",
    "na" => "na1",
    "oce" => "oc1",
    "tr" => "tr1",
    "ru" => "ru"
  }

  def resolve_region(region) do
    region
    |> String.downcase()
    |> region_downcase()
  end

  defp region_downcase(region) when region in @americas,
    do: {:ok, {"americas", Map.get(@region_to_subdomain_map, region)}}

  defp region_downcase(region) when region in @asia,
    do: {:ok, {"asia", Map.get(@region_to_subdomain_map, region)}}

  defp region_downcase(region) when region in @europe,
    do: {:ok, {"europe", Map.get(@region_to_subdomain_map, region)}}

  defp region_downcase(_region), do: {:error, :unknown_region}
end
