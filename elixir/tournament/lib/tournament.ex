defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """

  defstruct wins: 0, draws: 0, losses: 0

  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    to_map(input)
  end

  defp to_map(input) do
    components = Enum.map(input, fn line -> String.split(line, ";") end)

    Enum.reduce(components, %{}, fn [first_team, second_team, result], acc ->
      case result do
        "win" ->
          acc
          |> Map.update(first_team, %Tournament{wins: 1}, fn tournament ->
            %Tournament{tournament | wins: tournament.wins + 1}
          end)
          |> Map.update(second_team, %Tournament{losses: 1}, fn tournament ->
            %Tournament{tournament | losses: tournament.losses + 1}
          end)

        "draw" ->
          acc
          |> Map.update(first_team, %Tournament{draws: 1}, fn tournament ->
            %Tournament{tournament | losses: tournament.draws + 1}
          end)
          |> Map.update(second_team, %Tournament{draws: 1}, fn tournament ->
            %Tournament{tournament | losses: tournament.draws + 1}
          end)

        "loss" ->
          acc
          |> Map.update(second_team, %Tournament{wins: 1}, fn tournament ->
            %Tournament{tournament | wins: tournament.wins + 1}
          end)
          |> Map.update(first_team, %Tournament{losses: 1}, fn tournament ->
            %Tournament{tournament | losses: tournament.losses + 1}
          end)
      end
    end)
  end
end
