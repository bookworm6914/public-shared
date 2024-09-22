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


## update_k8s_tools.sh
This bash script downloads the typical CLI executable files for Kubernetes.
- kind
- kubectl
- helm
- istioctl

This bash script will download these tools in the **same directory** that this shell script resides.

It checks to see if these tools exist in your `${PATH}` first. If one tool already exists, it will not be downloaded.
If you intend to download one tool anyway, please set the corresponding variable to empty, that is
```
KIND_BINARY=
KUBECTL_BINARY=
HELM_BINARY=
ISTIOCTL_BINARY=
```

This script works on
- Apple's Mac with either Intel CPUs (X64 based) or M1/M2/M3/Mx CPUs (ARM64 based)
- Linux that runs on either Intel CPUs or ARM ones.
- Windows 10 and later, in the WSL2 environment.

Some of these tools are archived in compressed packages on the corresponding web sites. This script will decompress the archive and get the tool out of it accordingly.  

If you want to download other tools, you could follow the similar logic to get it done.
