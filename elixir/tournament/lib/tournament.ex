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

  defstruct wins: 0, draws: 0, losses: 0, points: 0

  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    "Team                           | MP |  W |  D |  L |  P\n" <>
      to_tally_results(input)
  end

  defp to_tally_results(input) do
    input
    |> to_map()
    |> Enum.map_join("\n", fn {team, %Tournament{} = tournament} ->
      "#{String.pad_trailing(team, 31)}|  #{
        tournament.wins + tournament.draws + tournament.losses
      } |  #{tournament.wins} |  #{tournament.draws} |  #{tournament.losses} |  #{
        tournament.points
      }"
    end)
  end

  defp to_map(input) do
    input
    |> Enum.map(fn line -> String.split(line, ";") end)
    |> Enum.reduce(%{}, fn [first_team, second_team, result], acc ->
      case result do
        "win" ->
          acc
          |> Map.update(first_team, %Tournament{wins: 1, points: 3}, fn tournament ->
            %Tournament{tournament | wins: tournament.wins + 1, points: tournament.points + 3}
          end)
          |> Map.update(second_team, %Tournament{losses: 1}, fn tournament ->
            %Tournament{tournament | losses: tournament.losses + 1}
          end)

        "draw" ->
          acc
          |> Map.update(first_team, %Tournament{draws: 1, points: 1}, fn tournament ->
            %Tournament{tournament | draws: tournament.draws + 1}
          end)
          |> Map.update(second_team, %Tournament{draws: 1, points: 1}, fn tournament ->
            %Tournament{tournament | draws: tournament.draws + 1, points: tournament.points + 1}
          end)

        "loss" ->
          acc
          |> Map.update(second_team, %Tournament{wins: 1, points: 3}, fn tournament ->
            %Tournament{tournament | wins: tournament.wins + 1, points: tournament.points + 3}
          end)
          |> Map.update(first_team, %Tournament{losses: 1}, fn tournament ->
            %Tournament{tournament | losses: tournament.losses + 1}
          end)
      end
    end)
    |> Enum.sort_by(fn {_, %Tournament{} = tournament} -> tournament.points end, :desc)
  end
end
