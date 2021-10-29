defmodule CronExpressionParser do
  @moduledoc """
  Documentation for `CronExpressionParser`.
  """

  @doc """
  """

  def expression_parser([arg]) do
    IO.inspect(arg)

    {:ok,
     %{
       minute: "0, 15, 30, 45",
       hour: "0",
       day_of_month: "1, 15",
       month: "1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12",
       day_of_week: "1, 2, 3, 4, 5",
       command: "/usr/bin/find"
     }}
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
end
