#!/usr/bin/awk -f
BEGIN {
  "date +%A" | getline day_of_week;
  close("date +%A");

  "date +%d" | getline day_of_month;
  close("date +%d");

  "date +%Z" | getline timezone;
  close("date +%Z");

  # coerce to a number to avoid leading zeroes
  day_of_month=day_of_month + 0;

  printf "happy %s the ", day_of_week;
  if (day_of_month == "1" || day_of_month == "21" || day_of_month == "31") {
    printf "%sst", day_of_month;
  } else if (day_of_month == "2" || day_of_month == "22") {
    printf "%snd", day_of_month;
  } else if (day_of_month == "3" || day_of_month == "23") {
    printf "%srd", day_of_month;
  } else {
    printf "%sth", day_of_month;
  }
  printf " from awk (in %s)", timezone;
}
