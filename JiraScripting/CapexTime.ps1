Add-Type -Language CSharp @"
public class WorkLogEntry{
    public string Comment;
    public System.DateTime TimeStamp;
    public string UserName;
    public string Seconds;
    public string Project;
}
"@;

function Update-Database([WorkLogEntry]$entry)
{
    $sqlConn = New-Object System.Data.SqlClient.SqlConnection
    $sqlConn.ConnectionString = "Data Source=(local);Initial Catalog=JiraExt;Persist Security Info=True;User ID=JiraImport;Password=jira"
    $sqlConn.Open()

    $sql = "INSERT INTO WorkLogs (TimeStamp, UserName, Project, Comment, Seconds) VALUES ('" + $entry.TimeStamp.ToString("yyyy-MM-dd HH:mm:ss:fff") + "', '" + $entry.UserName + "', '" + $entry.Project + "', '" + "" + "', '" + $entry.Seconds + "')"
    $cmd = New-Object System.Data.SqlClient.SqlCommand($sql,$sqlConn)
    $rdr = $cmd.ExecuteNonQuery()

    $sqlconn.Close()
}

$StreamReader = New-Object System.IO.StreamReader -Arg "timetracking.csv"
[array]$Headers = $StreamReader.ReadLine() -Split "," | % { "$_".Trim() } | ? { $_ }
$StreamReader.Close()

For ($i=1; $i -lt $Headers.Count; $i++)
{
    # If in any previous column, give it a generic header name
    if ($Headers[0..($i-1)] -contains $Headers[$i])
    {
        if($Headers[$i-1] -match "Log Work?")
        {
            $Headers[$i] = "Log Work$i"
        }
        else
        {
            $Headers[$i] = "Header$i"
        }
    }
}

$rawData = Import-Csv "timetracking.csv" -Header $Headers

$relevantHeaders = $Headers | ? {$_ -match "Log Work?" }
$compiledLogs = $null
foreach($h in $relevantHeaders)
{
    $compiledLogs += $rawData | ? { $_."$h" -ne ""} | % { "$($_."$h");$($_."Project key")"} | ? {$_ -notlike "Log Work*"}
 
}

$entries = New-Object Collections.Generic.List[WorkLogEntry]

$workLogData = $compiledLogs | % {$_ -split ";"}

for ($i = 0; $i -lt $workLogData.Length; $i+=5)
{
    if([bool]$workLogData[$i+1])
    {
        $entry = New-Object WorkLogEntry
        #$entry.Comment = $workLogData[$i].Replace("'", "''").Replace("`r`n", "")
        $entry.TimeStamp = $workLogData[$i+1]
        $entry.UserName = $workLogData[$i+2]
        $entry.Seconds = $workLogData[$i+3]
        $entry.Project = $workLogData[$i+4]

        $entries.Add($entry)
    }
}

 $entries | % { Update-Database($_) }