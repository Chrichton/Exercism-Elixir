defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @weekday_to_day_no %{
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, :teenth),
    do: calulate_teenth_day(year, month, @weekday_to_day_no[weekday])

  def meetup(year, month, weekday, :first),
    do: calulate_first_day(year, month, @weekday_to_day_no[weekday])

  def meetup(year, month, weekday, :second),
    do: calulate_second_day(year, month, @weekday_to_day_no[weekday])

  def meetup(year, month, weekday, :third),
    do: calulate_third_day(year, month, @weekday_to_day_no[weekday])

  def meetup(year, month, weekday, :fourth),
    do: calulate_fourth_day(year, month, @weekday_to_day_no[weekday])

  def meetup(year, month, weekday, :last),
    do: calulate_last_day(year, month, @weekday_to_day_no[weekday])

  def meetup(year, month, weekday, schedule) do
  end

  defp calulate_first_day(year, month, weekday_no) do
    new_date(year, month, 1)
    |> find_weekday(weekday_no)
  end

  defp calulate_second_day(year, month, weekday_no) do
    new_date(year, month, 8)
    |> find_weekday(weekday_no)
  end

  defp calulate_third_day(year, month, weekday_no) do
    new_date(year, month, 15)
    |> find_weekday(weekday_no)
  end

  defp calulate_fourth_day(year, month, weekday_no) do
    new_date(year, month, 22)
    |> find_weekday(weekday_no)
  end

  defp calulate_teenth_day(year, month, weekday_no) do
    new_date(year, month, 13)
    |> find_weekday(weekday_no)
  end

  defp calulate_last_day(year, month, weekday_no) do
    date = new_date(year, month, 1)

    new_date(year, month, Date.days_in_month(date) - 6)
    |> find_weekday(weekday_no)
  end

  def find_weekday(date_from, weekday_no) do
    weekday_diff = weekday_no - Date.day_of_week(date_from)

    if weekday_diff < 0,
      do: Date.add(date_from, weekday_diff + 7),
      else: Date.add(date_from, weekday_diff)
  end

  defp new_date(year, month, day) do
    {:ok, date} = Date.new(year, month, day)
    date
  end
end
