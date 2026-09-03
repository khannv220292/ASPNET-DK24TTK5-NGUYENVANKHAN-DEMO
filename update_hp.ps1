$ErrorActionPreference = "Stop"
$c = New-Object System.Data.SqlClient.SqlConnection "Server=localhost;Database=webgaming;Integrated Security=True"
$c.Open()

function Exec([string]$sql, $params) {
  $cmd = $c.CreateCommand()
  $cmd.CommandText = $sql
  foreach ($k in $params.Keys) {
    [void]$cmd.Parameters.AddWithValue($k, $params[$k])
  }
  [void]$cmd.ExecuteNonQuery()
}

Exec "UPDATE ItemType SET TypeName=@n WHERE ID=5" @{ n = "Elitebook" }
Exec "UPDATE ItemType SET TypeName=@n WHERE ID=6" @{ n = "OmniBook" }

function UpsertItem($id, $name, $buy, $sell, $qty, $tid, $pic, $short, $desc) {
  $cmd = $c.CreateCommand()
  $cmd.CommandText = "SELECT COUNT(*) FROM Item WHERE ID=@id"
  [void]$cmd.Parameters.AddWithValue("@id", $id)
  $exists = [int]$cmd.ExecuteScalar()
  if ($exists -eq 0) {
    $cmd2 = $c.CreateCommand()
    $cmd2.CommandText = @"
SET IDENTITY_INSERT Item ON;
INSERT INTO Item (ID,Name,PurcharsePrice,SellPrice,DateImport,Quantity,TypeID,BrandID,Picture,Active,ShortTitle,Describe)
VALUES (@id,@name,@buy,@sell,GETDATE(),@qty,@tid,1,@pic,1,@short,@desc);
SET IDENTITY_INSERT Item OFF;
"@
    [void]$cmd2.Parameters.AddWithValue("@id", $id)
    [void]$cmd2.Parameters.AddWithValue("@name", $name)
    [void]$cmd2.Parameters.AddWithValue("@buy", $buy)
    [void]$cmd2.Parameters.AddWithValue("@sell", $sell)
    [void]$cmd2.Parameters.AddWithValue("@qty", $qty)
    [void]$cmd2.Parameters.AddWithValue("@tid", $tid)
    [void]$cmd2.Parameters.AddWithValue("@pic", $pic)
    [void]$cmd2.Parameters.AddWithValue("@short", $short)
    [void]$cmd2.Parameters.AddWithValue("@desc", $desc)
    [void]$cmd2.ExecuteNonQuery()
  } else {
    Exec @"
UPDATE Item SET Name=@name, PurcharsePrice=@buy, SellPrice=@sell, Quantity=@qty, TypeID=@tid, BrandID=1,
 Active=1, Picture=@pic, ShortTitle=@short, Describe=@desc, DateImport=GETDATE() WHERE ID=@id
"@ @{ name=$name; buy=$buy; sell=$sell; qty=$qty; tid=$tid; pic=$pic; short=$short; desc=$desc; id=$id }
  }
}

UpsertItem 5 "Elitebook 6 G11" 35900000 42590000 8 5 "resizer.png" "U7-255H / 16GB / 512GB / 14 WUXGA" "<p><b>HP Elitebook 6 G11 - BQ9N4PT</b> (phongvu.vn).</p><p>Ultra 7-255H, Intel Graphics, 16GB, 512GB, 1.4kg, 14 WUXGA IPS. Gia 42.590.000d.</p>"
UpsertItem 6 "OmniBook 7 14" 29000000 31590000 10 6 "resizer.jpg" "Ultra 7-255U / 16GB / 512GB / 14 WUXGA" "<p><b>HP OmniBook 7 14-fr0027TU - C1MN1PA</b>.</p><p>Ultra 7-255U, 16GB, 512GB, 1.41kg, 14 WUXGA IPS. Gia 31.590.000d.</p>"
UpsertItem 17 "HP 14 em0023AU" 17990000 20990000 15 6 "resizer.png" "R5 7520U / 16GB / 512GB / 14 FHD" "<p><b>HP 14 em0023AU - D0BG7PA</b>.</p><p>Ryzen 5 7520U, AMD Radeon, 16GB, 512GB, 1.4kg, 14 FHD IPS. Tiet kiem 3.000.000d. Gia 20.990.000d.</p>"
UpsertItem 18 "ProBook 4 G11" 30000000 34990000 6 5 "resizer (1).jpg" "Ultra 5-225U / 16GB / 512GB / 14 WUXGA" "<p><b>HP ProBook 4 G11 - BQ5B3PT</b>.</p><p>Ultra 5-225U, 16GB, 512GB, 1.4kg, 14 WUXGA IPS. Gia 34.990.000d.</p>"
UpsertItem 19 "HP 14-hc0028TU" 21000000 24990000 12 6 "resizer.png" "Ultra 5-225U / 16GB / 512GB / 14 FHD" "<p><b>HP 14-hc0028TU - D72BJPA</b>.</p><p>U5-225U, 16GB, 512GB, Win 11 Home SL, 14 FHD 60Hz. Gia 24.990.000d.</p>"
UpsertItem 20 "HP 14-ep1012TU" 20500000 23490000 9 6 "resizer.jpg" "Core 5 120U / 16GB / 512GB / 14 FHD" "<p><b>HP 14-ep1012TU - D72CPPA</b>. Tra gop 0%.</p><p>Core 5 120U, 16GB, 512GB, 1.4kg, 14 FHD. Gia 23.490.000d.</p>"
UpsertItem 21 "OmniBook 5 16" 23000000 25990000 7 6 "resizer.png" "R5 8640HS / 16GB / 512GB / 16 WUXGA" "<p><b>HP OmniBook 5 16-ag1069AU - BZ7T1PA</b>.</p><p>Ryzen 5 8640HS, 16GB, 512GB, 1.8kg, 16 WUXGA. Gia 25.990.000d.</p>"
UpsertItem 22 "HP 250R G10" 18900000 22490000 11 5 "AMD-Ryzen-5-4600G.jpg" "Core 5 120U / 16GB / 512GB / 15.6 FHD" "<p><b>HP 250R G10 - C3SH7AT</b>.</p><p>Core 5 120U, 16GB, 512GB, 1.6kg, 15.6 FHD IPS. Gia 22.490.000d.</p>"
UpsertItem 23 "Elitebook 640 G11" 30000000 33990000 5 5 "resizer.png" "U7-165U / 16GB / 512GB / 14 FHD IPS" "<p><b>HP Elitebook 640 G11 - A7LB4PT</b>.</p><p>Ultra 7-165U, 16GB, 512GB, 1.4kg, 14 FHD IPS. Gia 33.990.000d.</p>"
UpsertItem 24 "Victus 15 RTX4050" 25000000 28990000 8 6 "GSPC-Aphrodite.png" "i5-13420H / RTX 4050 / 16GB / 512GB" "<p><b>HP Victus 15 fa2732TX - B85LPPA</b> gaming.</p><p>i5-13420H, RTX 4050, 16GB, 512GB, 15.6 FHD 144Hz. Gia 28.990.000d.</p>"
UpsertItem 25 "OmniBook X Flip" 28000000 31390000 6 6 "resizer.jpg" "Ultra 5-226V / 16GB / 512GB / 14 WUXGA" "<p><b>HP OmniBook X Flip 14-fm0088TU - BZ7Q2PA</b>.</p><p>U5-226V, 16GB, 512GB, 1.3kg, 14 WUXGA. Gia 31.390.000d.</p>"
UpsertItem 26 "ProBook 4 G1i" 28000000 32490000 7 5 "resizer.png" "Ultra 7-255U / 16GB / 512GB / 14 WUXGA" "<p><b>HP ProBook 4 G1i - BQ5C7PT</b>.</p><p>Ultra 7-255U, 16GB, 512GB, 1.4kg, 14 WUXGA. Gia 32.490.000d.</p>"

$cmd = $c.CreateCommand()
$cmd.CommandText = "SELECT ID, Name, SellPrice FROM Item WHERE TypeID IN (5,6) ORDER BY ID"
$r = $cmd.ExecuteReader()
$sb = New-Object System.Text.StringBuilder
while ($r.Read()) { [void]$sb.AppendLine("$($r.GetInt64(0)) | $($r.GetString(1)) | $($r.GetDecimal(2))") }
$r.Close(); $c.Close()
[System.IO.File]::WriteAllText("$env:TEMP\hp_items.txt", $sb.ToString(), [System.Text.UTF8Encoding]::new($false))
Get-Content "$env:TEMP\hp_items.txt" -Encoding UTF8
