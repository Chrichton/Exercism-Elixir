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
    do: calulate(year, month, @weekday_to_day_no[weekday], 10..19)

  def meetup(year, month, weekday, schedule) do
  end

  defp calulate(year, month, weekday_no, day_range) do
    {:ok, date} = Date.new(year, month, 1)
    find_next_date_on_weekday(date, weekday_no, day_range)
  end

  def find_next_date_on_weekday(date_from, weekday_no, day_range) do
    if Date.day_of_week(date_from) == weekday_no && date_from.day in 10..19,
      do: date_from,
      else: find_next_date_on_weekday(Date.add(date_from, 1), weekday_no, day_range)
  end
end
