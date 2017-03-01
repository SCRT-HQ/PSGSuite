function Start-PSGSuiteConfigWizard {
$inputXML = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="PSGSuite - Configuration Wizard" Height="398" Width="589" Background="White" WindowStartupLocation="CenterScreen" ResizeMode='NoResize'>
    <Grid>
        <TabControl x:Name="tabControl" HorizontalAlignment="Left" Height="373" VerticalAlignment="Top" Width="589" Margin="0,0,0,0">
            <TabItem Header="page0" FontFamily="Roboto" Visibility="Collapsed">
                <Grid Background="#FF424242" Margin="0,-1.333,-10,1.333">
                    <Label x:Name="label0" HorizontalAlignment="Left" Margin="30,20,0,0" VerticalAlignment="Top" FontSize="18.667" Height="209" Width="520" FontFamily="Roboto" Foreground="White"/>
                    <Label x:Name="label05" HorizontalAlignment="Left" Margin="351,234,0,0" VerticalAlignment="Top" FontSize="18.667" Height="40" Width="171" FontFamily="Roboto" Foreground="White"/>
                    <Button x:Name="startButton0" Margin="201,293,201,0" VerticalAlignment="Top" Height="30" Background="#FF2196F3" Foreground="White" FontSize="13.333"/>
                </Grid>
            </TabItem>
            <TabItem Header="page1" FontFamily="Roboto" Visibility="Collapsed">
                <Grid Background="#FF424242" Margin="0,-1.333,-10,1.333">
                    <Label x:Name="label1" HorizontalAlignment="Left" Margin="30,37,0,0" VerticalAlignment="Top" FontSize="18.667" Height="62" Width="520" FontFamily="Roboto" Foreground="White"/>
                    <Label x:Name="label15" HorizontalAlignment="Left" Margin="98,106,0,0" VerticalAlignment="Top" Width="396" Height="132" FontStyle="Italic" FontSize="16" FontFamily="Roboto" Foreground="White"/>
                    <TextBox x:Name="primaryDomainTextBox1" Height="23" Margin="98,252,89,0" TextWrapping="Wrap" VerticalAlignment="Top" FontFamily="Roboto" TextAlignment="Center" VerticalContentAlignment="Center"/>
                    <Button x:Name="prevButton1" HorizontalAlignment="Left" Margin="150,293,0,0" VerticalAlignment="Top" Width="110" Height="30" Foreground="White" FontSize="13.333"/>
                    <Button x:Name="nextButton1" HorizontalAlignment="Left" Margin="307,293,0,0" VerticalAlignment="Top" Width="110" Height="30" Background="#FF9E9E9E" Foreground="White" FontSize="13.333"/>
                </Grid>
            </TabItem>
            <TabItem Header="page2" FontFamily="Roboto" Visibility="Collapsed">
                <Grid Background="#FF424242" Margin="0,-1.333,-10,1.333">
                    <Label x:Name="projectLabel2" Margin="48,24,55,0" VerticalAlignment="Top" FontSize="18.667" Height="59" Foreground="White"/>
                    <Button x:Name="createProjectButton2" Margin="208,292,210,0" VerticalAlignment="Top" Height="30" Background="#FF2196F3" Foreground="White" FontSize="13.333"/>
                    <Button x:Name="prevButton2" HorizontalAlignment="Left" Margin="54,293,0,0" VerticalAlignment="Top" Width="110" Height="30" Foreground="White" FontSize="13.333"/>
                    <Button x:Name="nextButton2" Margin="419,293,54,0" VerticalAlignment="Top" Height="29" Background="#FF9E9E9E" Foreground="White" FontSize="13.333"/>
                    <Label x:Name="reqLabel2" HorizontalAlignment="Left" Margin="66,97,0,0" VerticalAlignment="Top" FontSize="16" Foreground="White" Width="414" Height="71"/>
                    <Label x:Name="infoLabel2" HorizontalAlignment="Left" Margin="48,189,0,0" VerticalAlignment="Top" FontSize="16" Foreground="White" Height="77" Width="481" FontStyle="Italic"/>
                </Grid>
            </TabItem>
            <TabItem Header="page3" FontFamily="Roboto" Visibility="Collapsed">
                <Grid Background="#FF424242" Margin="0,-1.333,-10,1.333">
                    <Label x:Name="projectLabel3" Margin="67,133,66,155" FontSize="18.667" Foreground="White"/>
                    <Button x:Name="openAdminButton3" Margin="208,292,210,0" VerticalAlignment="Top" Height="30" Background="#FF2196F3" Foreground="White" FontSize="13.333"/>
                    <Button x:Name="prevButton3" HorizontalAlignment="Left" Margin="54,293,0,0" VerticalAlignment="Top" Width="110" Height="30" Foreground="White" FontSize="13.333"/>
                    <Button x:Name="nextButton3" Margin="419,293,54,0" VerticalAlignment="Top" Height="29" Background="#FF9E9E9E" Foreground="White" FontSize="13.333"/>
                </Grid>
            </TabItem>
            <TabItem Header="page4" FontFamily="Roboto" Visibility="Collapsed">
                <Grid Background="#FF424242" Margin="0,-1.333,-10,1.333">
                    <Label x:Name="projectLabel4" Margin="54,23,54,265" FontSize="18.667" Foreground="White"/>
                    <Button x:Name="createConfigButton4" Margin="180,292,220,0" VerticalAlignment="Top" Height="30" Background="#FF2196F3" Foreground="White" FontSize="13.333"/>
                    <Button x:Name="prevButton4" HorizontalAlignment="Left" Margin="49,293,0,0" VerticalAlignment="Top" Width="110" Height="30" Foreground="White" FontSize="13.333"/>
                    <Button x:Name="nextButton4" Margin="377,293,53,0" VerticalAlignment="Top" Height="29" Background="#FF9E9E9E" Foreground="White" FontSize="13.333"/>
                    <TextBox x:Name="p12TextBox4" HorizontalAlignment="Left" Height="30" Margin="191,87,0,0" VerticalAlignment="Top" Width="338" AllowDrop="True" TextAlignment="Center" VerticalContentAlignment="Center"/>
                    <Button x:Name="p12BrowseButton4" Margin="56,87,406,0" VerticalAlignment="Top" Height="30" Background="#FF2196F3" Foreground="White" FontSize="13.333"/>
                    <Label x:Name="appEmaillabel4" HorizontalAlignment="Left" Margin="78,129,0,0" VerticalAlignment="Top" Height="30" Width="87" Foreground="White" FontSize="13.333"/>
                    <TextBox x:Name="appEmailTextBox4" HorizontalAlignment="Left" Height="30" Margin="191,128,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="338" TextAlignment="Center" VerticalContentAlignment="Center"/>
                    <Label x:Name="adminEmaillabel4" HorizontalAlignment="Left" Margin="70,170,0,0" VerticalAlignment="Top" Height="30" Width="104" Foreground="White" FontSize="13.333"/>
                    <TextBox x:Name="adminEmailTextBox4" HorizontalAlignment="Left" Height="30" Margin="191,169,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="338" TextAlignment="Center" VerticalContentAlignment="Center"/>
                    <Label x:Name="customerIdlabel4" HorizontalAlignment="Left" Margin="70,211,0,0" VerticalAlignment="Top" Height="30" Width="104" Foreground="White" FontSize="13.333"/>
                    <TextBox x:Name="customerIdTextBox4" HorizontalAlignment="Left" Height="30" Margin="191,209,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="338" TextAlignment="Center" VerticalContentAlignment="Center"/>
                    <Label x:Name="svcAcctClientIdlabel4" HorizontalAlignment="Left" Margin="55,246,0,0" VerticalAlignment="Top" Height="41" Width="136" Foreground="White" FontSize="13.333"/>
                    <TextBox x:Name="svcAcctClientIdTextBox4" HorizontalAlignment="Left" Height="30" Margin="191,251,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="338" TextAlignment="Center" VerticalContentAlignment="Center"/>
                </Grid>
            </TabItem>
            <TabItem Header="page5" FontFamily="Roboto" Visibility="Collapsed">
                <Grid Background="#FF424242" Margin="0,-1.333,-10,1.333">
                    <Button x:Name="createConfigButton5" Margin="265,293,135,0" VerticalAlignment="Top" Height="30" Background="#FF2196F3" Foreground="White" FontSize="13.333"/>
                    <Button x:Name="prevButton5" HorizontalAlignment="Left" Margin="135,293,0,0" VerticalAlignment="Top" Width="110" Height="30" Foreground="White"/>
                </Grid>
            </TabItem>
        </TabControl>
    </Grid>
</Window>
"@

$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
 
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
    $reader=(New-Object System.Xml.XmlNodeReader $XAML) 
  try{$Form=[Windows.Markup.XamlReader]::Load($reader)}
catch{$Error[0]; return}
 
#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================
 
$xaml.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}

function Get-File {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "P12 Key files (*.p12)| *.p12"
    $OpenFileDialog.ShowDialog() | Out-Null

    if($file = $OpenFileDialog.filename)
        {
        return $file
        }
    else
        {
        return
        }
}

function Save-FileLocation {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.rootfolder = "Desktop"

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder = $foldername.SelectedPath
    }
    return $folder
}

function Initialize-Form {
$WPFlabel0.Content = "Hi there, thanks for trying out PSGSuite! This wizard will `nassist in creating your first configuration file.`n`nYou will have the option to create a new project directly from `nthis wizard if needed. You are free to use an existing`nDeveloper Console project as well, if preferred.`n`nTo get started, please click the blue 'START CONFIGURATION' `nbutton below."
$WPFlabel05.Content = "- Nate @ SCRT HQ"
$WPFstartButton0.Content = "START CONFIGURATION"

$WPFlabel1.Content = "Enter the primary domain that you will be managing with this `nmodule below:"
$WPFlabel15.Content = "e.g. 'domain.com' or 'company.net' or 'example.org'`n`nYou may switch between domains mid-script with `nSwitch-PSGSuiteDomain and set a new primary using `nSet-PSGSuitePrimaryDomain"
$WPFprevButton1.Content = "PREVIOUS"
$WPFprevButton1.Background = $null
$WPFprevButton1.BorderBrush = $null
$WPFnextButton1.Content = "NEXT"

$WPFprojectLabel2.Content = "Do you have a project created in the Google Developer `nConsole with all of the following?"
$WPFreqLabel2.Content = "• Service Account with Domain-wide Delegation enabled`n• P12 key file downloaded`n• The recommended API's enabled (see GitHub for list)`n`n"
$WPFinfoLabel2.Content = "If you do not have a project (or would like to create `none fresh for this), please click the blue 'NO - CREATE PROJECT' `nbutton below then continue once done creating the project."
$WPFcreateProjectButton2.Content = "NO - CREATE PROJECT"
$WPFprevButton2.Content = "PREVIOUS"
$WPFprevButton2.Background = $null
$WPFprevButton2.BorderBrush = $null
$WPFnextButton2.Content = "YES - NEXT"

$WPFprojectLabel3.Content = "Has the Service Account Client been provided API `nClient access in the Admin Console [Security]?"
$WPFopenAdminButton3.Content = "NO - OPEN ADMIN"
$WPFprevButton3.Content = "PREVIOUS"
$WPFprevButton3.Background = $null
$WPFprevButton3.BorderBrush = $null
$WPFnextButton3.Content = "YES - NEXT"

$WPFprojectLabel4.Content = "Please provide the following information to create the`nconfiguration file:"
$WPFcreateConfigButton4.Content = "SAVE CONFIGURATION"
$WPFprevButton4.Content = "PREVIOUS"
$WPFprevButton4.Background = $null
$WPFprevButton4.BorderBrush = $null
$WPFnextButton4.Content = "ADVANCED SETTINGS"
$WPFnextButton4.ToolTip = "Coming soon!"
$WPFp12BrowseButton4.Content = "P12 KEY PATH"
$WPFappEmaillabel4.Content="APP EMAIL"
$WPFadminEmaillabel4.Content="ADMIN EMAIL"
$WPFcustomerIdlabel4.Content="CUSTOMER ID"
$WPFsvcAcctClientIdlabel4.Content="SERVICE ACCOUNT`n         CLIENT ID"
$WPFp12TextBox4.ToolTip="Click the button on the left to browse for the P12 file or enter the full path here (e.g. C:\Modules\PSGSuite\PSGS_kindred-spirit.p12)"
$WPFp12BrowseButton4.ToolTip="Click here to browse for the P12 file"
$WPFappEmailTextBox4.ToolTip="Enter the email address for the Service Account in the Google Developer Console's credentials page (e.g. psgs@psgsuite-testing.iam.gserviceaccount.com)"
$WPFadminEmailTextBox4.ToolTip="Enter the SuperAdmin email that created the project and Service Account (e.g. Google.Admin@company.com)"
$WPFcustomerIdTextBox4.ToolTip="Enter the immutable Customer ID (e.g. C00j3291f)"
$WPFsvcAcctClientIdTextBox4.ToolTip="Enter the service account client ID for the Service Account in the Google Developer Console's credentials page (e.g. 1282899239239203005176)"

$WPFcreateConfigButton5.Content = "SAVE CONFIGURATION"
$WPFprevButton5.Content = "PREVIOUS"
$WPFprevButton5.Background = $null
$WPFprevButton5.BorderBrush = $null

$WPFnextButton4.IsEnabled = $false
}

$WPFp12TextBox4.Add_Drop({ 
$WPFp12TextBox4.Text = $_.Data.GetFileDropList() 
})

$WPFstartButton0.Add_Click({
    $WPFtabControl.SelectedIndex = 1
    })

$WPFprevButton1.Add_Click({
    $WPFtabControl.SelectedIndex = 0
    })
$WPFnextButton1.Add_Click({
    Set-PSGSuiteDefaultDomain -Domain $($WPFprimaryDomainTextBox1.Text)
    $Script:PSGSuite = [pscustomobject]@{
        P12KeyPath = $null
        AppEmail = $null
        AdminEmail = $null
        CustomerID = $null
        Domain = $null
        Preference = $null
        ServiceAccountClientID = $null
        }
    $Script:PSGSuite | Export-Clixml -Path "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml" -Force -ErrorAction Stop
    $WPFtabControl.SelectedIndex = 2
    })
$WPFprimaryDomainTextBox1.Add_KeyDown({
    if ($args[1].key -eq 'Return' -and $WPFprimaryDomainTextBox1.Text.Length -ne 0)
        {
        Set-PSGSuiteDefaultDomain -Domain $($WPFprimaryDomainTextBox1.Text)
        $Script:PSGSuite = [pscustomobject][ordered]@{
            P12KeyPath = $null
            AppEmail = $null
            AdminEmail = $null
            CustomerID = $null
            Domain = $null
            Preference = $null
            ServiceAccountClientID = $null
            }
        $Script:PSGSuite | Export-Clixml -Path "$ModuleRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml" -Force -ErrorAction Stop
        $WPFtabControl.SelectedIndex = 2
        }
    })

$WPFprevButton2.Add_Click({
    $WPFtabControl.SelectedIndex = 1
    })
$WPFnextButton2.Add_Click({
    $WPFtabControl.SelectedIndex = 3
    })
$WPFprevButton3.Add_Click({
    $WPFtabControl.SelectedIndex = 2
    })
$WPFnextButton3.Add_Click({
    $WPFtabControl.SelectedIndex = 4
    })
$WPFprevButton4.Add_Click({
    $WPFtabControl.SelectedIndex = 3
    })
$WPFnextButton4.Add_Click({
    $WPFtabControl.SelectedIndex = 5
    })
$WPFprevButton5.Add_Click({
    $WPFtabControl.SelectedIndex = 4
    })

$WPFcreateProjectButton2.Add_Click({
    Start-Process "https://console.developers.google.com/flows/enableapi?apiid=admin,appsactivity,calendar,drive,gmail,groupssettings,licensing,plus,contacts,urlshortener,sheets.googleapis.com"
    })

$WPFopenAdminButton3.Add_Click({
    Start-Process "https://admin.google.com/$env:PSGSuiteDefaultDomain/ManageOauthClients"
    })

$WPFp12BrowseButton4.Add_Click({
    if ($file = Get-File)
        {
        $WPFp12TextBox4.Text = $file
        }
    })

$WPFcreateConfigButton4.Add_Click({
    try
        {
        if (![string]::IsNullOrEmpty($WPFcustomerIdTextBox4.Text))
            {
            Set-PSGSuiteConfig -P12KeyPath $($WPFp12TextBox4.Text) -AppEmail $($WPFappEmailTextBox4.Text) -AdminEmail $($WPFadminEmailTextBox4.Text) -CustomerID $($WPFcustomerIdTextBox4.Text) -Domain $env:PSGSuiteDefaultDomain -Preference CustomerID -ServiceAccountClientID $($WPFsvcAcctClientIdTextBox4.Text) -Verbose
            }
        else
            {
            Set-PSGSuiteConfig -P12KeyPath $($WPFp12TextBox4.Text) -AppEmail $($WPFappEmailTextBox4.Text) -AdminEmail $($WPFadminEmailTextBox4.Text) -Domain $env:PSGSuiteDefaultDomain -Preference CustomerID -ServiceAccountClientID $($WPFsvcAcctClientIdTextBox4.Text) -Verbose
            $CustomerID = $(Get-GSUser | Select -ExpandProperty CustomerID)
            Set-PSGSuiteConfig -CustomerID $CustomerID -Verbose
            }
        $Form.Close()
        }
    catch
        {
        $_
        }
    })
$WPFcreateConfigButton5.Add_Click({
    try
        {
        if (![string]::IsNullOrEmpty($WPFcustomerIdTextBox4.Text))
            {
            Set-PSGSuiteConfig -P12KeyPath $($WPFp12TextBox4.Text) -AppEmail $($WPFappEmailTextBox4.Text) -AdminEmail $($WPFadminEmailTextBox4.Text) -CustomerID $($WPFcustomerIdTextBox4.Text) -Domain $env:PSGSuiteDefaultDomain -Preference CustomerID -ServiceAccountClientID $($WPFsvcAcctClientIdTextBox4.Text) -Verbose
            }
        else
            {
            Set-PSGSuiteConfig -P12KeyPath $($WPFp12TextBox4.Text) -AppEmail $($WPFappEmailTextBox4.Text) -AdminEmail $($WPFadminEmailTextBox4.Text) -Domain $env:PSGSuiteDefaultDomain -Preference CustomerID -ServiceAccountClientID $($WPFsvcAcctClientIdTextBox4.Text) -Verbose
            $CustomerID = $(Get-GSUser | Select -ExpandProperty CustomerID)
            Set-PSGSuiteConfig -CustomerID $CustomerID -Verbose
            }
        $Form.Close()
        }
    catch
        {
        $_
        }
    })

$Form.Add_Loaded({
Initialize-Form
})

$Form.ShowDialog() | Out-Null
}