case CronExpressionParser.expression_parser(System.argv()) do
  {:ok,
   %{
     minute: minute,
     hour: hour,
     day_of_month: day_of_month,
     month: month,
     day_of_week: day_of_week,
     command: command
   }} ->
    """
    minute        #{minute}
    hour          #{hour}
    day of month  #{day_of_month}
    month         #{month}
    day of week   #{day_of_week}
    command       #{command}
    """

  {:error, error} ->
    "#{error}"

  _ -> "An unexpected error occured while running the script"
end
|> IO.puts()
