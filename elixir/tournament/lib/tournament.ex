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
    |> Enum.filter(&has_two_semicolons(&1))
    |> Enum.map(fn line -> String.split(line, ";") end)
    |> Enum.reduce(%{}, fn [first_team, second_team, result | _], acc ->
      case result do
        "win" ->
          update_win(acc, first_team, second_team)

        "draw" ->
          update_draw(acc, first_team, second_team)

        "loss" ->
          update_win(acc, second_team, first_team)

        _ ->
          acc
      end
    end)
    |> Enum.sort_by(
      fn {team, %Tournament{} = tournament} -> {team, tournament.points} end,
      &compare_tournaments/2
    )
  end

  defp compare_tournaments({left_team, left_points}, {right_team, right_points}) do
    if left_points == right_points,
      do: left_team < right_team,
      else: left_points > right_points
  end

  def has_two_semicolons(line) do
    line
    |> String.codepoints()
    |> Enum.filter(&(&1 == ";"))
    |> Enum.count() == 2
  end

  defp update_win(map, first_team, second_team) do
    map
    |> Map.update(first_team, %Tournament{wins: 1, points: 3}, fn tournament ->
      %Tournament{tournament | wins: tournament.wins + 1, points: tournament.points + 3}
    end)
    |> Map.update(second_team, %Tournament{losses: 1}, fn tournament ->
      %Tournament{tournament | losses: tournament.losses + 1}
    end)
  end

  defp update_draw(map, first_team, second_team) do
    map
    |> update_draw(first_team)
    |> update_draw(second_team)
  end

  defp update_draw(map, team) do
    map
    |> Map.update(team, %Tournament{draws: 1, points: 1}, fn tournament ->
      %Tournament{tournament | draws: tournament.draws + 1, points: tournament.points + 1}
    end)
  end
end
