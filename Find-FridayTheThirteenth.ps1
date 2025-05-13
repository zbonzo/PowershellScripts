# Accept a date as an input and then find the next Friday the 13th.

function Find-FridayTheThirteenth{
    param(
        [string]$InputString = (Get-Date -Format "yyyy-MM-dd")
    )

    if ($InputString -eq (Get-Date -Format "yyyy-MM-dd")) {
        Write-Output "Using today's date. To specify a different date, please pass a valid date to the function.  Suggested versions include YYYY-MM-DD or MonthName DD YYYY."
    }

    try {
        # Convert the input string to a DateTime object and extract only the date component
        $DateToTest = [DateTime]::Parse($InputString).Date

        # Get the 13th day of the Month of the input date
        $ThirteenthDayOfMonth = Get-Date -Year $DateToTest.Year -Month $DateToTest.Month -Day 13

        # Check if ThirteenthDayOfMonth is a Friday
        if($ThirteenthDayOfMonth -eq [System.DayOfWeek]::Friday){
            Write-Output "The 13th of $($DateToTest.ToString("MMMM")) $($DateToTest.Year) is a Friday"
        }
        else{
            # Check the next Month
            while ($ThirteenthDayOfMonth.DayOfWeek -ne [System.DayOfWeek]::Friday) {
                $ThirteenthDayOfMonth = $ThirteenthDayOfMonth.AddMonths(1)
            }
            Write-Output "The next Friday the 13th is $($ThirteenthDayOfMonth.ToString("MMMM dd yyyy"))"
        }
    }
    catch {
        Write-Output "Input is not a date, please enter in format of YYYY-MM-DD or MonthName DD YYYY"
    }

}

# Test the function
Find-FridayTheThirteenth # Uses today's date, The next Firday the 13th is October 13 2023
Find-FridayTheThirteenth -InputString "1975-12-15" # Returns The next Friday the 13th is February 13 1976
Find-FridayTheThirteenth -InputString "2100-08-01" # Returns The next Friday the 13th is August 13 2100