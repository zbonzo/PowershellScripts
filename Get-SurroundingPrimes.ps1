function Get-SurroundingPrimes{

    param (
        [int]$Number
    )

    function Is-Prime{
        param(
            [int]$NumberToTest
        )

        if ($NumberToTest -lt 2) {
            return $false
        }
        for ($counter = 2; $counter -le [math]::sqrt($NumberToTest); $counter++) {
            if ($NumberToTest % $counter -eq 0) {
                return $false
            }
            return $true

        }

    }

    $previousprime = $null
    $nextprime = $null

    $i = $number - 1
    while ($previousprime -eq $null){
        if(Is-Prime $i){$previousprime = $i}
        $i--
    }

    $i = $number + 1
    while ($nextprime -eq $null){
        if(Is-Prime $i){$nextprime = $i}
        $i++
    }

    return $previousprime, $nextprime

}
function Get-SurroundingPrimes {
    param (
        [int]$number
    )

    function Is-Prime {
        param (
            [int]$num
        )

        if ($num -lt 2) { return $false }
        for ($i = 2; $i -le [math]::sqrt($num); $i++) {
            if ($num % $i -eq 0) { return $false }
        }
        return $true
    }

    $previousPrime = $null
    $nextPrime = $null

    $i = $number - 1
    while ($previousPrime -eq $null) {
        if (Is-Prime $i) {
            $previousPrime = $i
        }
        $i--
    }

    $i = $number + 1
    while ($nextPrime -eq $null) {
        if (Is-Prime $i) {
            $nextPrime = $i
        }
        $i++
    }

    return $previousPrime, $nextPrime
}

# Test the function
$number = 123457
$result = Get-SurroundingPrimes -number $number
Write-Output "The surrounding prime numbers of $number are: $($result[0]) and $($result[1])"