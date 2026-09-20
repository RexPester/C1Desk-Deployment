# C1Desk-Deployment
C1Desk Deployment Client is a Rustdesk client with C1desk skin.
its easy to generate and removes the need to manually set configuration for every client.
## Client generation
to keep the C1Desk client updated a new one needs to be made every time that there is a new rustdesk release
Go to https://rdgen.crayoneater.org/ select the latest version of rustde-sk
#### General
- Name of the configuration: C1Desk
- Custom Application Name: C1Desk
- Connection Type: Bidirectional
- Disable Installation: YES
- Disable Settings: YES
#### Custom Server
- Host: rustdesk.c1tech.group
- Port:
- Key: *Ask Administrator!*
- API: rustdesk.c1tech.group:21114
- Custom URL for links: https://c1tech.co/
- Custom URL for downloading updates: https://c1tech.co/
- Company name for copyright: C1Tech
#### Security
- Password Approve mode: accepts both
- Set Permanent Password: *Password must be set! ask administrator*
- keep other setting off by default
#### Visual 
For logo use the C1desk logo located at Local-NAS\Public\logo and set the theme to DARK on override
#### Permissions and other 
- Keep the Default setting only turn on remote configuration modification
- ****Other default setting****:
- allow-hostname-as-id=Y
- disable-settings=Y
- disable-security-settings=Y
- ****Other Override settings****:
- pre-elevate-service=Y
- stop-service-when-user-logout=N
Put these codes into the other tab
## Customizing & Compiling the Installer

Follow these steps if you need to modify the deployment script (e.g., changing download URLs, process names, or cleanup paths) and recompile it into a standalone executable.
Step 1: Edit deploy.ps1

Open deploy.ps1 in VS Code or any text editor to customize the installer behavior:

    Update Release Link: Modify $DownloadUrl to point to your release binary:
    PowerShell

    $DownloadUrl = "https://github.com/YourOrg/C1Desk-Deployment/releases/latest/download/C1Desk.exe"

    Manage Target Services & Processes: Update $ServiceNames or $ProcessNames if your custom build uses different names.

    Add Config Cleanup Paths: Add any extra folder paths to $ConfigPaths if you want to wipe additional cache directories during upgrades.

Step 2: Install the Compiler

Compilation requires the ps2exe PowerShell module. Open PowerShell as Administrator and run:
PowerShell

- Install-Module -Name ps2exe -Scope CurrentUser -Force

Step 3: Compile deploy.ps1 into .exe

Open PowerShell in the folder containing deploy.ps1 and execute:
PowerShell

Invoke-PS2EXE -InputFile ".\deploy.ps1" -OutputFile ".\C1Desk-Setup.exe" -requireAdmin -noConsole

Flag Explanations:

    -requireAdmin: Embeds a manifest that forces Windows to automatically prompt for Administrator privileges when double-clicked.

    -noConsole: Hides the black PowerShell window during execution for a silent, professional install.

    -iconFile ".\icon.ico" (Optional): Pass a path to an .ico file to brand the generated installer binary with your logo.

Step 4: Test & Distribute

    Test Execution: Run C1Desk-Setup.exe on a clean test environment to verify that old clients are removed, services restart, and desktop shortcuts appear.

    Publish: Attach the compiled C1Desk-Setup.exe to your GitHub Releases page or software distribution point.
## C1Desk ID Changer 
the ID Changer is copied and slightly modified from the https://github.com/abdullah-erturk/RustDesk-ID-Server-Changer repository.
the functionality of id change as hostname and 9 random digit id is confirmed the rest must be tested.
