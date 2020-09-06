#!/usr/bin/awk -f
BEGIN {
  "date +%A" | getline day_of_week;
  close("date +%A");

  "date +%d" | getline day_of_month;
  close("date +%d");

  "date +%Z" | getline timezone;
  close("date +%Z");

  printf "happy %s the ", day_of_week;
  if (day_of_month == "1") {
    printf "1st";
  } else if (day_of_month == "2") {
    printf "2nd";
  } else if (day_of_month == "3") {
    print "3rd";
  } else {
    printf "%sth", day_of_month;
  }
  printf " from awk (in %s)", timezone;
}
