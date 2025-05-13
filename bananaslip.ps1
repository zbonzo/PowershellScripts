# Function to fetch weather data from OpenWeatherMap API
function Fetch-WeatherData {
    param (
        [string]$lat,
        [string]$lon,
        [string]$weatherApiKey
    )

    $weatherUrl = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$weatherApiKey"
    $weatherDataJson = Invoke-RestMethod -Uri $weatherUrl -Method Get
    return $weatherDataJson
}

# Function to fetch nearby places from Google Places API
function Fetch-NearbyPlaces {
    param (
        [string]$lat,
        [string]$lon,
        [int]$radius,
        [string]$placeType,
        [string]$googleMapsApiKey
    )

    $placesUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lon&radius=$radius&type=$placeType&key=$googleMapsApiKey"
    $placesDataJson = Invoke-RestMethod -Uri $placesUrl -Method Get
    return $placesDataJson
}

# Function to calculate the banana slip risk index
function Calculate-BananaSlipRiskIndex {
    param (
        [Hashtable]$weatherData,
        [Hashtable]$groceryStores
    )

    $index = 0

    # Add points for grocery stores
    for ($i = 1; $i -le 5; $i++) {
        $radiusMeters = $i * 1609.34  # Convert miles to meters
        $nearbyGroceryStores = Fetch-NearbyPlaces -lat $lat -lon $lon -radius $radiusMeters -placeType "grocery_or_supermarket" -googleMapsApiKey $googleMapsApiKey
        $index += $nearbyGroceryStores.results.Count * (6 - $i)
    }

    # Add points for parks and schools
    $nearbyParks = Fetch-NearbyPlaces -lat $lat -lon $lon -radius (3 * 1609.34) -placeType "park" -googleMapsApiKey $googleMapsApiKey
    $nearbySchools = Fetch-NearbyPlaces -lat $lat -lon $lon -radius (3 * 1609.34) -placeType "school" -googleMapsApiKey $googleMapsApiKey
    $index += ($nearbyParks.results.Count + $nearbySchools.results.Count) * 5

    # Adjust index based on temperature
    $temperature = $weatherData.main.temp - 273.15  # Convert Kelvin to Celsius
    if ($temperature -lt 26.67) {  # Less than 80°F
        $index *= 1
    } elseif ($temperature -ge 26.67 -and $temperature -lt 32.22) {  # Between 80°F and 90°F
        $index *= 1.25
    } elseif ($temperature -ge 32.22 -and $temperature -lt 37.78) {  # Between 90°F and 100°F
        $index *= 1.5
    } else {  # More than 100°F
        $index *= 2
    }

    return $index
}

# Input: Latitude and Longitude
$lat = Read-Host "Enter Latitude"
$lon = Read-Host "Enter Longitude"

# Replace with your API keys
$weatherApiKey = 'your_openweathermap_api_key'
$googleMapsApiKey = 'your_google_maps_api_key'

# Fetch weather data and nearby grocery stores
$weatherData = Fetch-WeatherData -lat $lat -lon $lon -weatherApiKey $weatherApiKey
$groceryStores = Fetch-NearbyPlaces -lat $lat -lon $lon -radius 1609.34 -placeType "grocery_or_supermarket" -googleMapsApiKey $googleMapsApiKey

# Calculate the banana slip risk index
$bananaSlipRiskIndex = Calculate-BananaSlipRiskIndex -weatherData $weatherData -groceryStores $groceryStores

# Output the result
$result = @{ "bananaSlipRiskIndex" = $bananaSlipRiskIndex }
$resultJson = $result | ConvertTo-Json
Write-Host $resultJson