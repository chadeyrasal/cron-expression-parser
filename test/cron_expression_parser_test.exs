defmodule CronExpressionParserTest do
  use ExUnit.Case
  doctest CronExpressionParser

  describe "expression_parser/1" do
    test "returns an ok tuple with the expected result if the argument format is correct" do
      {:ok, result} = CronExpressionParser.expression_parser(["*/15 0 1,15 * 1-5 /usr/bin/find"])

      assert result == %{
               minute: "0 15 30 45",
               hour: "0",
               day_of_month: "1 15",
               month: "1 2 3 4 5 6 7 8 9 10 11 12",
               day_of_week: "1 2 3 4 5",
               command: "/usr/bin/find"
             }
    end

    test "returns appropriate error message if an empty list is provided" do
      {:error, error} = CronExpressionParser.expression_parser([])

      assert error == "No argument has been provided. Please provide an argument."
    end

    test "returns appropriate error message if the argument is a list containing more than one element" do
      {:error, error} = CronExpressionParser.expression_parser(["Boaty", "McBoatface"])

      assert error ==
               "More than one argument has been provided. Please provide only one argument."
    end

    test "returns appropriate error message if any other type of argument is provided" do
      {:error, error} = CronExpressionParser.expression_parser("Boaty McBoatface")

      assert error ==
               "There is an issue with the argument provided. Please check the argument provided."
    end
  end
end
