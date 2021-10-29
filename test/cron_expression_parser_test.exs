defmodule CronExpressionParserTest do
  use ExUnit.Case
  doctest CronExpressionParser

  test "greets the world" do
    assert CronExpressionParser.hello() == :world
  end
end
