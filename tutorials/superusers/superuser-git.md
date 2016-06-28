#Superusers Part II: Git

##Introduction

In the previous tutorial we covered the basics of navigating the Shell. If you haven't done this or don't know how to use the Shell, you can find the tutorial [here](https://github.com/Physes/Exosphere/blob/master/tutorials/superusers/superuser-shell.md). 


Git is the most widely used version control system in the world. It was created in 2005 by Linus Torvalds, the founder of Linux. Git is mainly used via the shell and can keep a complete history of any project, organized into a `repository`. Repository `commits` (updates) are encrypted with the SHA1 algorithm and are traceable back to the beginning. Git is also flexible: in large collaborative projects, team members or other developers can `clone` the central repository and work on their own local copy, and then update the origin via `push`.

This tutorial is split into to basic themes: working with Git unilaterally and collaborating with Git.

###A Note on Learning

As I said in the first tutorial, by far the best way to learn is to repeat each new skill about five times, followed by intermittent repetitions at increasing time intervals.
In the beginning, some of the collaborative aspects of Git can be a little more difficult to conceptualize. It's worth committing the simpler stuff to memory so you can give energy to the more complicated aspects.
##Table of Contents

1. [Getting Started](###Getting Started)
2. [Initializing Repositories](###Initializing Repositories)

###Getting Started

Open the shell and check if Git is installed with `git --version`. If this returns something like `git version 1.9.1` then great! If not, you'll need to install it.

If you're on Linux, you can install it with `apt-get`, followed by your password if set:

`sudo apt-get install git`

If you're on Mac, install it with `brew`:

`brew install git`

if you don't have Homebrew you can get it [here](http://brew.sh/).

If you find any other complications in installing Git you can check the [Official Install Guide](https://git-scm.com/book/en/v1/Getting-Started-Installing-Git).

###Initializing Repositories

There are two ways to create a repository (repo for short). Either you can create a new directory using `mkdir [directory]` and create the new repository inside, or you can initialize an unnamed repository where you are. Let's try both ways. For fun, let's call our project `Zeus`.

`mkdir Zeus`

Now `cd Zeus` and create an empty Git repository using `git init`. When you `ls` you'll see that nothing seems to be there, but in fact the repository is hidden. Try `ls -alt` and you'll see that the directory contains a new directory called `.git`. Directories and files which begin with a period `.` are always hidden, usually because they contain background functionality which is usually not directly necessary to interact with directly. 

Now delete `.git` in the `Zeus` directory using `rm -rf .git`, then `cd ..` back to home and remove Zeus: `rmdir Zeus`.

`init` has the ability to create a completely new directory along with a Git repository by specifying the name of your project in the command. We can create a new Zeus directory initialized with its own Git repo with the following command:

`git init Zeus`

Now step into Zeus for the next step.

###Adding Files


##Collaborating in Git

###Push and Pull

###Glossary


