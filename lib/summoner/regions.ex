defmodule Summoner.Regions do
  @americas ~w(americas na br lan las oce)
  @asia ~w(asia kr jp)
  @europe ~w(europe eune euw tr ru)

  def region_by_platform_or_region(platform) do
    platform
    |> IO.inspect()
    |> String.downcase()
    |> region_by_platform_or_region_downcase()
  end

  defp region_by_platform_or_region_downcase(platform) when platform in @americas,
    do: {:ok, List.first(@americas)}

  defp region_by_platform_or_region_downcase(platform) when platform in @asia,
    do: {:ok, List.first(@asia)}

  defp region_by_platform_or_region_downcase(platform) when platform in @europe,
    do: {:ok, List.first(@europe)}

  defp region_by_platform_or_region_downcase(_platform), do: {:error, :unknown_platform}
end
