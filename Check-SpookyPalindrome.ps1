function Test-SpookyPalindrome{
    param(
        [string]$inputString,
        [string]$wordsFilePath
    )
    

    $allowedWords = @("dracula", "night", "spooky", "eve")

    # check if File is passed to the funciton and exists
    if ($wordsFilePath -and (Test-Path $wordsFilePath)){
        $allowedWords = get-Content $wordsFilePath
    }

    function IsPalindrome($word){
        return $word -eq (-join $word[-1..-($word.Length)])
    }
    
    if(IsPalindrome $inputString){
        if ($allowedWords | Where-Object {$inputString -match $_}) {
                Write-Output "$inputString is a sPoOkY PaLiNdRoMe"
            } else {
                Write-Output "$inputString is a regular Palindrome."
            }

        } else {
            Write-Output "$inputString is not a Palindrome"
        }
}

# Test the function
clear-host

Test-SpookyPalindrome "racecar" # Palindrome
Test-SpookyPalindrome "dracula" # not
Test-SpookyPalindrome "draculalucard" # Spooky
Test-SpookyPalindrome "nighthgin" # spooky
Test-SpookyPalindrome "nighthgin" "C:\Scripts\PowerShell-o-ween\SpookyWords.txt" # regular
Test-SpookyPalindrome "draculalucard" "C:\Scripts\PowerShell-o-ween\SpookyWords.txt" # spooky