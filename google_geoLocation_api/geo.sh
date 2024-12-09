#!/bin/bash


API_URL="https://www.googleapis.com/geolocation/v1/geolocate?key=${API_KEY}"


REQUEST_DATA=$(cat <<EOF
{
  "homeMobileCountryCode": 450,
  "homeMobileNetworkCode": 5,
  "radioType": "lte",
  "carrier": "SKTelecom",
  "considerIp": false,
  "cellTowers": [
    {
      "cellId": 7127819,
      "locationAreaCode": 9990,
      "mobileCountryCode": 450,
      "mobileNetworkCode": 5
    }
  ],
  "wifiAccessPoints": []
}
EOF
)


curl -X POST "$API_URL" \
     -H "Content-Type: application/json" \
     -d "$REQUEST_DATA"