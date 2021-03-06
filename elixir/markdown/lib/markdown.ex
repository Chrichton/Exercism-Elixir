defmodule Markdown do
  alias __MODULE__

  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(m) do
    m
    |> String.split("\n")
    |> Enum.map_join(&process/1)
    |> enclose_list_with_ul()
  end

  defp process("*" <> _ = t), do: parse_list_md_level(t)

  defp process("#" <> _ = t) do
    t
    |> parse_header_md_level()
    |> enclose_with_header_tag()
  end

  defp process(t) do
    t
    |> String.split()
    |> enclose_with_paragraph_tag()
  end

  defp parse_header_md_level(hwt) do
    [h | t] = String.split(hwt)

    {
      h
      |> String.length()
      |> to_string(),
      Enum.join(t, " ")
    }
  end

  defp parse_list_md_level(l) do
    list_markup =
      l
      |> String.trim_leading("* ")
      |> String.split()
      |> join_words_with_tags()

    "<li>" <> list_markup <> "</li>"
  end

  defp enclose_with_header_tag({hl, htl}) do
    "<h" <> hl <> ">" <> htl <> "</h" <> hl <> ">"
  end

  defp enclose_with_paragraph_tag(t) do
    "<p>#{join_words_with_tags(t)}</p>"
  end

  defp join_words_with_tags(t),
    do: Enum.map_join(t, " ", &replace_md_with_tag/1)

  defp replace_md_with_tag(w) do
    w
    |> replace_prefix_md()
    |> replace_suffix_md()
  end

  defp replace_prefix_md(w) do
    cond do
      w =~ ~r/^#{"__"}{1}/ -> String.replace(w, ~r/^#{"__"}{1}/, "<strong>", global: false)
      w =~ ~r/^[#{"_"}{1}][^#{"_"}+]/ -> String.replace(w, ~r/_/, "<em>", global: false)
      true -> w
    end
  end

  defp replace_suffix_md(w) do
    cond do
      w =~ ~r/#{"__"}{1}$/ -> String.replace(w, ~r/#{"__"}{1}$/, "</strong>")
      w =~ ~r/[^#{"_"}{1}]/ -> String.replace(w, ~r/_/, "</em>")
      true -> w
    end
  end

  defp enclose_list_with_ul(l) do
    l
    |> String.replace("<li>", "<ul>" <> "<li>", global: false)
    |> String.replace_suffix("</li>", "</li>" <> "</ul>")
  end
end
