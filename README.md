# dotfiles-deploy

## What this script does
This script deploys my special [dotfiles](https://github.com/0xBooper/dotfiles)
It also installs all the things needed for the dotfiles.

## A few warnings
This script ***WILL*** overwrite your existing dotfiles.

## Things needed 
This script needs a ideally fresh install of Arch Linux.
The user must have superuser permissions.

## What about Debian?
This script currently won't work on Debian and Debian based distros.
However, Debian (and Debian based distros) are planned to be supported.

## Actually using it
First, grab the script and run it.. Make sure your internet works, and run:
`curl https://raw.githubusercontent.com/0xBooper/dotfiles-deploy/main/deploydotfiles.sh | bash`

If you're feeling nervous about the script, you can `wget` the script and check & edit it.

After the script has finished, your system now has my dotfiles!
