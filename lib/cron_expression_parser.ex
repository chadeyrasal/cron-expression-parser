defmodule CronExpressionParser do
  @moduledoc """
  Documentation for `CronExpressionParser`.
  """

  @integer_regex ~r/^[[:digit:]]{1,2}$/
  @list_regex ~r/^[[:digit:]]{1,2},[[:digit:]]{1,2}$/
  @range_regex ~r/^[[:digit:]]{1,2}-[[:digit:]]{1,2}$/
  @steps_regex ~r/^\*\/[[:digit:]]{1,2}$/

  def expression_parser([arg]) do
    [minute | [hour | [day_of_month | [month | [day_of_week | command]]]]] =
      arg_list = String.split(arg)

    case length(arg_list) do
      6 ->
        process_data(%{
          minute: minute,
          hour: hour,
          day_of_month: day_of_month,
          month: month,
          day_of_week: day_of_week,
          command: command
        })

      _ ->
        {:error,
         "There is an unexpected number of elements in the argument provided. Please double check the argument before trying again."}
    end
  end

  def expression_parser([]) do
    {:error, "No argument has been provided. Please provide an argument."}
  end

  def expression_parser(arg) when length(arg) > 1 do
    {:error, "More than one argument has been provided. Please provide only one argument."}
  end

  def expression_parser(_) do
    {:error, "There is an issue with the argument provided. Please check the argument provided."}
  end

  @doc """
  Process time field

  ## Examples

      iex> CronExpressionParser.process_time_field("*/15", "minute")
      {:ok, "0, 15, 30, 45"}

      iex> CronExpressionParser.process_time_field("0", "hour")
      {:ok, "0"}

      iex> CronExpressionParser.process_time_field("1,15", "day_of_month")
      {:ok, "1, 15"}

      iex> CronExpressionParser.process_time_field("*", "month")
      {:ok, "1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12"}

      iex> CronExpressionParser.process_time_field("1-5", "day_of_week")
      {:ok, "1, 2, 3, 4, 5"}

      iex> CronExpressionParser.process_time_field("120", "minute")
      {:error, "No match found when parsing data."}

  """

  def process_time_field(value, time_field) when is_binary(value) do
    cond do
      value == "*" ->
        enum_to_string(get_range(time_field)) |> to_ok_tuple()

      String.match?(value, @integer_regex) ->
        value |> to_ok_tuple()

      String.match?(value, @list_regex) ->
        String.replace(value, ",", ", ") |> to_ok_tuple()

      String.match?(value, @range_regex) ->
        format_range(value)

      String.match?(value, @steps_regex) ->
        format_steps(value, time_field)

      true ->
        {:error, "No match found when parsing data."}
    end
  end

  def process_time_field(_value, _time_field),
    do: {:error, "The value to be processes should be a string. Please check and try again"}

  defp process_data(%{
         minute: minute,
         hour: hour,
         day_of_month: day_of_month,
         month: month,
         day_of_week: day_of_week,
         command: [command]
       })
       when is_binary(command) do
    with {:ok, formatted_minute} <- process_minute(minute),
         {:ok, formatted_hour} <- process_hour(hour),
         {:ok, formatted_day_of_month} <- process_day_of_month(day_of_month),
         {:ok, formatted_month} <- process_month(month),
         {:ok, formatted_day_of_week} <- process_day_of_week(day_of_week) do
      %{
        minute: formatted_minute,
        hour: formatted_hour,
        day_of_month: formatted_day_of_month,
        month: formatted_month,
        day_of_week: formatted_day_of_week,
        command: command
      }
      |> to_ok_tuple()
    else
      {:error, error} -> {:error, error}
    end
  end

  defp process_data(_) do
    {:error, "There is an issue with the command format. Please double check before trying again"}
  end

  defp process_minute(minute), do: process_time_field(minute, "minute")

  defp process_hour(hour), do: process_time_field(hour, "hour")

  defp process_day_of_month(day_of_month), do: process_time_field(day_of_month, "day_of_month")

  defp process_month(month), do: process_time_field(month, "month")

  defp process_day_of_week(day_of_week), do: process_time_field(day_of_week, "day_of_week")

  defp enum_to_string(enum) do
    Enum.join(enum, ", ")
  end

  defp format_range(range) do
    [min, max] =
      range
      |> String.split("-")
      |> Enum.map(&String.to_integer(&1))

    enum_to_string(min..max) |> to_ok_tuple()
  end

  defp format_steps(steps, time_field) do
    [_asterisk | [_slash | digits]] = String.split(steps, "", trim: true)
    divisor = Enum.join(digits) |> String.to_integer()

    Enum.filter(get_range(time_field), fn digit -> rem(digit, divisor) == 0 end)
    |> enum_to_string()
    |> to_ok_tuple()
  end

  defp get_range("minute"), do: 0..59

  defp get_range("hour"), do: 0..23

  defp get_range("day_of_month"), do: 1..31

  defp get_range("month"), do: 1..12

  defp get_range("day_of_week"), do: 1..7

  defp to_ok_tuple(value) do
    {:ok, value}
  end
end
