# CronExpressionParser

This cron expression parser takes in an input as single argument, and returns a table where each field is expanded to show at what time the job will run.

## Installation

1. Ensure you have elixir installed on your machine. If it is not the case, please visit https://elixir-lang.org/install.html for installation instructions

2. Clone this repository: https://github.com/chadeyrasal/cron-expression-parser

## Input format

Each entry in the crontab corresponds to a single task and must follow a precise notation:

- Minute: from 0 to 59
- Hour: from 0 to 23
- Day of the month: from 1 to 31
- Month: from 1 to 12
- Day of the week: from 1 to 7
- Command to execute

N.B. This script does not support the usage of the following for input:

- Month: jan, feb... abbreviations
- Day of the week: 0 is not supported
- Nonstandard predefined scheduling definitions like `@yearly`

## Running the script

1. Run the script in the terminal as the following example:
   `mix run scripts/parse_cron_expression.exs "*/15 0 1,15 * 1-5 /usr/bin/find"`

2. See the result displayed in the terminal
