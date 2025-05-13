function IsAfterOrOnSecondTuesday {
    param (
        [string]$InputString = (Get-Date -Format "yyyy-MM-dd")
    )

    if (-not $InputString) {
        Write-Output "Using today's date. To specify a different date, please pass it to the function in the format of YYYY-MM-DD or MonthName DD YYYY."
    }

    try {
        # Convert the input string to a DateTime object and extract only the date component
        $InputDate = [DateTime]::Parse($InputString).Date

        # Get the first day of the month of the input date
        $firstDayOfMonth = Get-Date -Year $InputDate.Year -Month $InputDate.Month -Day 1

        # Find the first Tuesday of the month
        while ($firstDayOfMonth.DayOfWeek -ne [System.DayOfWeek]::Tuesday) {
            $firstDayOfMonth = $firstDayOfMonth.AddDays(1)
        }

        # Calculate the second Tuesday of the month
        $secondTuesday = $firstDayOfMonth.AddDays(7).Date

        # Check if the input date is on or after the second Tuesday
        return $InputDate -ge $secondTuesday

    } catch {
        # If the input string can't be converted to a DateTime object, return the error message
        return "Input is not a date, please enter in format of YYYY-MM-DD or MonthName DD YYYY"
    }
}

# Test the function

IsAfterOrOnSecondTuesday -InputString "1975-12-15" # Returns True
IsAfterOrOnSecondTuesday -InputString "2100-08-01" # Returns False
IsAfterOrOnSecondTuesday -InputString "September 12 2023" # Returns True
IsAfterOrOnSecondTuesday -InputString "Septmber 2 2023" # Returns "Input is not a date"
IsAfterOrOnSecondTuesday # Uses today's date