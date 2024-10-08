[CmdletBinding()]
param (
    [Parameter()]
    [Int32]
    $thread = 2
)
$APP_NAME = ".\mandelbrot.exe"
$cpuInfo = Get-CimInstance -ClassName Win32_Processor
$OUTPUT_FILE = $cpuInfo.Name + ".txt"

if(!(Test-Path $APP_NAME))
{
  Write-Error "$APP_NAME does not exits"
  return
}

Write-Output "Running..."

"Running Mandelbrot for different -t values" | Out-File -FilePath $OUTPUT_FILE -Encoding utf8

for ($t = 1; $t -le $thread; $t++) {
  "Running with -t $t" | Out-File -FilePath $OUTPUT_FILE -Append
  & $APP_NAME -t $t | Out-File -FilePath $OUTPUT_FILE -Append
  "`n" | Out-File -FilePath $OUTPUT_FILE -Append
}


Write-Output "All Runs are completed. Check $OUTPUT_FILE for result"