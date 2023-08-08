#! /bin/bash
today=$(date +%Y%m%d)
weather_report=raw_data_$today
curl -o $weather_report wttr.in/toronto

# Extract only lines with temperatures
grep "°C" $weather_report > temps.txt

# Extract obs_tmp
obs_tmp=$(cat -A temps.txt | head -1 | cut -d "+" -f2 | cut -d "^" -f1)
echo "observed temperature = $obs_tmp"

# Extract tmrw's noon temp
fc_tmp=$(cat -A temps.txt | cut -d "+" -f3 | head -2 | cut -d "^" -f1 | sed -n '2s/^[[:space:]]*//p' )
echo "forecasted temperature = $fc_tmp"

# Current date values
hour=$(TZ='Canada/Toronto' date -u +%H) 
day=$(TZ='Canada/Toronto' date -u +%d) 
month=$(TZ='Canada/Toronto' date +%m)
year=$(TZ='Canada/Toronto' date +%Y)

# Append concatenated record to log file
record=$(echo -e "$year\t$month\t$day\t$hour\t$obs_tmp\t$fc_tmp")
echo $record>>rx_poc.log