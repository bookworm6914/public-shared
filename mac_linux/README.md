## Note
You could run these bash scripts from **anywhere** of the machine. Your current working directory does ***_not_** need to be the same directory where these scripts sit.

## update_machine.sh
This bash script updates the machine with the latest released packages via `apt`, and cleanup those obsolete ones. Be sure to run it with the admin's rights, for example
`sudo ./update_machine.sh`


## github_auto_sync.sh
This bash script will search and update all the GitHub repositories under one directory to the latest, as long as those repositories are in `main` or `master` branch. 

For example, we have the GitHub repositories structured like this:
```
└── home
    └── my_login_name
        └── code
            └── github.com
                └── public-shared
                └── another_repository1
                └── another_repository2
```
Then in the bash script, we could set the array variable **pathSet** to include the path of `home/my_login_name/code/github.com/`. If we have multiple root directories that host the GitHub repositories, we could add these root directories to the array of **pathSet**, then save the changes and run the script.

