# Set the start and end years
$startYear = 1967
$endYear = 2022

# Initialize an empty array to store the records
$records = @()

# Loop through each season
for ($year = $startYear; $year -le $endYear; $year++) {
		# Format the year values as needed
		$startYearString = $year.ToString("0000")
		$endYearString = ($year + 1).ToString("0000")
		$seasonString = $year.ToString("00") + "-" + ($year + 1).ToString("00")

		# Build the API URL for the season
		$season = "$startYearString$endYearString"

	$url = "https://statsapi.web.nhl.com/api/v1/standings/divisionLeaders?expand=standings.record&season=$season"
	$response = Invoke-WebRequest -Uri $url
	$data = $response | ConvertFrom-Json


	# Loop through each division
	foreach ($division in $data.records) {
		# Get the name of the division leader (team 0 in teamrecords)
		$teamName = $division.teamrecords[0].team.name

		# Calculate the home points
		$homeWins = $division.teamrecords[0].records.overallRecords[0].wins
		$homeTies = $division.teamrecords[0].records.overallRecords[0].ties
		$homeOT = $division.teamrecords[0].records.overallRecords[0].ot
		$homePoints = ($homeWins * 2) + $homeTies + $homeOT

		# Calculate the away points
		$awayWins = $division.teamrecords[0].records.overallRecords[1].wins
		$awayTies = $division.teamrecords[0].records.overallRecords[1].ties
		$awayOT = $division.teamrecords[0].records.overallRecords[1].ot
		$awayPoints = ($awayWins * 2) + $awayTies + $awayOT

		# Determine if the division leader had a better home season or away season
		    if ($homePoints -gt $awayPoints) {
        $betterSeason = "Home"
		$pointDifferential = ($homePoints / $awayPoints)
    } elseif ($awayPoints -gt $homePoints) {
        $betterSeason = "Away"
		$pointDifferential = ($awayPoints / $homePoints)
    } else {
        $pointDifferential = 1
    }


		# Create a PowerShell object with the team name, home points, away points, and better season
		$obj = [PsCustomObject]@{
			Season = $seasonString
			TeamName = $teamName
			HomePoints = $homePoints
			AwayPoints = $awayPoints
			pointDifferential = $pointDifferential
			betterSeason = $betterSeason
		}

		# Add the object to the array
		$records += $obj
		}
	}

# Output the array of records
$records | out-html table.html