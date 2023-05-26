$APPDATA_PATH = Get-ChildItem Env:APPDATA | Select-Object Value -ExpandProperty Value
$VSCODE_PATH = $APPDATA_PATH + '\Roaming\Code\User'

