## Note
You could run these bash scripts from **anywhere** of the machine. Your current working directory does ***_not_** need to be the same directory where these scripts sit.

## config_win10.cmd
This NT shell script, or batch file, automates some configurations on a typical Windows 10 Virtual Machine, for the purpose of Windows debugging or testing automation, etc.
1. This script checks to see if it runs on a 64-bit CPU.
2. Set it to automatic login.
3. Stop Windows Defender.
4. Enable the developer mode, and disable both Cortana and OneDrive.
5. Install all the latest changes from Windows Update.
6. Stop Windows Update Service to keep it simple.

Please **BE SURE** to run this batch file as a **_local admin_**.
