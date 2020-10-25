defmodule Bob do
  @non_letter_characters ["§", "%", "&", "/", "/", "(", ")", "=", ",", "_", "-"]
  def hey(input) do
    input = String.trim(input)

    cond do
      input == "" -> "Fine. Be that way!"
      question_with_numbers?(input) -> "Sure."
      question_with_non_letter_characters?(input) -> "Sure."
      asking_in_capitals?(input) -> "Calm down, I know what I'm doing!"
      String.last(input) == "?" -> "Sure."
      talking_forcefully(input) -> "Whatever."
      shouting_in_capitals(input) -> "Whoa, chill out!"
      talking_in_capitals?(input) -> "Whatever."
      String.last(input) == "!" -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end

  defp talking_forcefully(sentence),
    do: String.last(sentence) == "!" && !all_words_capitals?(sentence)

  defp shouting_in_capitals(sentence), do: String.upcase(sentence) == sentence

  defp talking_in_capitals?(sentence), do: all_words_capitals?(sentence)

  defp all_words_capitals?(sentence) do
    sentence
    |> String.split(" ")
    |> Enum.all?(fn word ->
      first_character = String.first(word)
      first_character == String.upcase(first_character)
    end)
  end

  defp asking_in_capitals?(sentence),
    do: shouting_in_capitals(sentence) && String.last(sentence) == "?"

  defp question_with_non_letter_characters?(sentence) do
    String.last(sentence) == "?" && String.contains?(sentence, @non_letter_characters)
  end

  defp question_with_numbers?(sentence),
    do:
      String.last(sentence) == "?" &&
        contains_numbers_only?(String.slice(sentence, 0..(String.length(sentence) - 2)))

  defp contains_numbers_only?(sentence) do
    case Integer.parse(sentence) do
      {_, ""} -> true
      _ -> false
    end
  end
end
