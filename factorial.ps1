function MultiplyStrings([string]$a, [string]$b) {
    $result = "0"
    $bToCharArray = $b.ToCharArray()
    $zeroesToAdd = 0

    for ($i = $bToCharArray.Length - 1; $i -ge 0; $i--) {
        $carry = 0
        $digitB = [int]$bToCharArray[$i]
        $tempResult = ''

        for ($j = $a.Length - 1; $j -ge 0; $j--) {
            $product = ([int]::Parse($a[$j]) * $digitB) + $carry
            $tempResult = ($product % 10) + $tempResult
            $carry = [int]($product / 10)
        }

        while ($carry -ne 0) {
            $tempResult = ($carry % 10) + $tempResult
            $carry = [int]($carry / 10)
        }

        $result = AddStrings $result ($tempResult + ('0' * $zeroesToAdd))
        $zeroesToAdd++
    }
    return $result
}

function AddStrings([string]$a, [string]$b) {
    while ($a.Length -lt $b.Length) {
        $a = "0" + $a
    }

    while ($b.Length -lt $a.Length) {
        $b = "0" + $b
    }

    $result = ''
    $carry = 0

    for ($i = $a.Length - 1; $i -ge 0; $i--) {
        $sum = [int]::Parse($a[$i]) + [int]::Parse($b[$i]) + $carry
        $result = ($sum % 10) + $result
        $carry = [int]($sum / 10)
    }

    while ($carry -ne 0) {
        $result = ($carry % 10) + $result
        $carry = [int]($carry / 10)
    }

    return $result
}

function Factorial([int]$n) {
    if ($n -eq 0) {
        return "1"
    }

    $result = "1"
    for ($i = 2; $i -le $n; $i++) {
        if ($i -le 20) {
            $result = [string]([math]::BigMul([long]$result, $i))
        } else {
            $result = MultiplyStrings $result [string]$i
        }
    }
    return $result
}

# Testing
$n = Read-Host "Enter a number"
$result = Factorial $n
Write-Output "Factorial of $n is: $result"