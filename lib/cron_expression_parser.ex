defmodule CronExpressionParser do
  @moduledoc """
  Documentation for `CronExpressionParser`.
  """

  @doc """
  """

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

        {:ok,
         %{
           minute: "0, 15, 30, 45",
           hour: "0",
           day_of_month: "1, 15",
           month: "1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12",
           day_of_week: "1, 2, 3, 4, 5",
           command: "/usr/bin/find"
         }}

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

  defp process_data(%{
         minute: minute,
         hour: hour,
         day_of_month: day_of_month,
         month: month,
         day_of_week: day_of_week,
         command: command
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

  defp process_minute(minute) do
    IO.inspect(minute)

    case minute do
      "*" -> IO.inspect(0..59)
    end
  end

  defp process_hour(hour) do
    hour
  end

  defp process_day_of_month(day_of_month) do
    day_of_month
  end

  defp process_month(month) do
    month
  end

  defp process_day_of_week(day_of_week) do
    day_of_week
  end

  defp to_ok_tuple(value) do
    {:ok, value}
  end
end
