#Superusers Part II: Git

##Introduction

In the previous tutorial we covered the basics of navigating the Shell. If you haven't done this or don't know how to use the Shell, you can find the tutorial [here](https://github.com/Physes/Exosphere/blob/master/tutorials/superusers/superuser-shell.md). 


Git is the most widely used version control system in the world. It was created in 2005 by Linus Torvalds, the founder of Linux. Git is mainly used via the shell and can keep a complete history of any project, organized into a repository. Repository “commits” (updates) are encrypted with the SHA1 algorithm and are traceable back to the beginning. Git is also flexible: in large collaborative projects, team members or other developers can `clone` the central repository and work on their own local copy, and then update the origin via `push`.

This tutorial is split into two basic themes: working with Git unilaterally and collaborating with Git.

###A Note on Learning

As I said in the first tutorial, by far the best way to learn is to repeat each new skill about five times, followed by intermittent repetitions at increasing time intervals.
In the beginning, some of the collaborative aspects of Git can be a little more difficult to conceptualize. It's worth committing the simpler stuff to automatic memory so you can give energy to the more complicated aspects.

##Table of Contents

1. [Getting Started](###Getting Started)
2. [Initializing Repositories](###Initializing Repositories)
3. [Check Status and Stage Files](###Adding and Staging Files)
4. [Line Insertions](###Line Insertions)
5. [Git Log and Git Config](###Git Log and Git Config)
6. [Introduction to Branching](###Introduction to Branching)
7. [Merging and Conflict Resolution](###Merging and Conflict Resolution)

###Getting Started

Open the shell type `git --version`. This will check if Git is installed. If it returns something like `git version 1.9.1` or any other version then great! If not, you'll need to install it.

If you're on Linux, you can use `apt-get`, followed by your password if set:

`sudo apt-get install git`

If you're on Mac, install it with `brew`:

`brew install git`

if you don't have Homebrew you can get it [here](http://brew.sh/).

If you find any other complications in installing Git you can check the [Official Install Guide](https://git-scm.com/book/en/v1/Getting-Started-Installing-Git).

The last piece of preparation you'll need is a [Github account](https://www.github.com), if you don't already have one. No need to create any repositories on the site itself; this tutorial will mostly be about working with your account from afar.

###Initializing Repositories

There are two ways to create a repository (repo for short). Either you can create a new directory using `mkdir [directory]` and create the new repository inside, or you can initialize an unnamed repository where you are. Let's try both ways. For fun, let's call our project `Zeus`.

`mkdir Zeus`

Now `cd Zeus` and create an empty Git repository using `git init`. When you `ls` you'll see that nothing seems to be there, but in fact the repository is hidden. Try `ls -alt` and you'll see that the directory contains a new directory called `.git`. Directories and files which begin with a period `.` are always hidden, usually because they contain background functionality which is not usually necessary to interact with directly. 

Now delete `.git` in the `Zeus` directory using `rm -rf .git`, then `cd ..` back to home and remove Zeus: `rmdir Zeus`.

`init` has the ability to create a completely new directory along with a Git repository by specifying the name of your project in the command. We can create a new Zeus directory initialized with its own Git repo with the following command:

`git init Zeus`

Now step into Zeus for the next step, and type `git status`.

###Check Status and Stage Files

In this section we will learn how to create and stage files as part of your project. There are three basic steps:
```
1. create/edit/delete files and directories
2. stage
3. commit
```
Creating is self-evident. Staging prepares certain files to be committed. `commit` then takes a permenent snapshot in your project history, which you will always be able to observe.

Here's a mnemonic device for the procedure: 

#####Change, stage and turn the page!

Why do we need this procedure is important in the first place? The answer is that simply saving your work locally in a text editor or IDE is restrictive for large and complex projects. We need a system to track and potentially reverse changes you make to your software.

In the `Zeus` directory, let's create three directories: `mkdir lib bin public`. Let's also create two generic files in the same directory: `touch README.md package.json`. `ls` and you should be able to see them all. The `README.md` file is found in most Git projects, as a way of explaining or introducing the software in question. If you've ever browsed Github, you'll have noticed that most respositories are followed by some kind of text explanation. This is the contents of the project's README file, written in markdown for styling (`.md` stands for “markdown” in case you're wondering)- then properly displayed by the Github site. I will include a glossary of markdown styling syntax at the end of this tutorial.

Quickly create a file in `lib` with contents: `echo Hello World >> lib/index.js`. This creates  a new file in the lib directory called `index.js` containing the words `Hello World`.

We have now done the “Change” bit. Next, let's do “stage”.

At any time, you can check the status of your project to see what files are staged and unstaged using `git status`. Do this now will display the following output:
```
On branch master
Initial commit
Untracked files:

  (use "git add <file>..." to include in what will be committed)
	README.md
	lib/
	package.json

nothing added to commit but untracked files present (use "git add" to track)
```
You'll notice only `lib/` (and all sub-content) appears, despite the fact that you also made two other directories called `bin` and `public`. This is because Git only tracks and records directories with contents, but it ignores empty directories.

To stage these files, do `git add *`. `*` means “all”. You can stage a file individually too, for example, `git add package.json`. But `git add *` is often more convenient.

Now re-run `git status` to see the new files staged. If you need to unstage a file for further edits, you can use `git rm --cached <file>`, but we don't need to worry about that for now.

The final step in this process is `git commit`. Commits are accompanied by the `-m` flag and a short message to describe what the change was about. To commit these files do: `git commit -m “initialized zeus repository”` or whatever messsage you like.

###Line Insertions and Deletions

When you make a commit, you will see a short summary of the changes you made, in a form that looks something like this:
```
2 files changed, 3 insertions(+), 11 deletions(-)
```
Changes are recorded on a line-by-line basis. If a particular line is modified it will count as an insertion, as obviously will new lines inserted into the file.

In preparation for the next stage, return to lib/index.js and add a few extra lines. When you're done, stage and commit with `git add` and `git commit -m “<message>”`.

###Git Log and Git Config

Now that we have made two commits in `Zeus`, you can check the changes you have made using the command `git log`. Do this now. The Git Log is a record of all the commits you made to the project. The rough format for each entry into the log is:
```
commit <sha1 hash>
Author: <user> <email>
Date:   <date>
    <commit message>
```
If you haven't used Git before, then `user` and `email` should not contain anything. On your system, you can have as many seperate Git respositories as you like, however you can set your identity on a global basis. To do this, you can use `git config`. Config lets you get and set configuration variables that control all aspects of how Git looks and operates.

Since we'll be working with Github in this tutorial, set your username and email to be the same as your GitHub account. You can do with with the `--global` tag.
```
git config --global user.name “John Doe”
git config --global user.email “johndoe@example.com”
```
If the email in your local `git config --global` is the same as your Github account, commits will be included in the history on the site.

Now recheck `git log` to see your log history with the updated details. Git Log has vast functionality for querying, which is beyond the scope of this course. You can read more about it by checking the official documentation or by doing `git log --help`. The `--help` flag can be used along with any command to find out more about it.

###Introduction to Branching

To see what branch you're on type `git branch` now. By default, you will be on the `master` branch, which is the default line of development.

Branching serves a number of useful purposes. Imagine you were writing a book, but had two conflicting ideas of where the plot would go. In one plot, the protagonist lives, and in the other, the protagonist dies. Obviously two very different stories. Git gives us a solution: develop each plot along alternating `branches`, each with their own unique `commit` histories. And if the alternative proves to be superior than what you had planned originally, you can `merge` back into the original.

You will use the `git branch` command to create, list, delete and rename branches.

To create a new branch, use the above command followed by the name of your new branch. Let's call our new branch `lives` for our alternate plot:

`git branch lives`

Now do `git branches` again to see the two branches listed. You'll notice that `master` is highlighted, which indicates that this is the branch you're currently on. To switch to the new branch, use the `checkout` command. Remember `checkout` as in taking a look to see what's going on. Do this now: `git checkout lives`. Now if you do `git branch` again you'll notice lives is highlighted.

Put some contents into this branch and stage and commit:
```
echo Zeus lives > public/plot.txt
echo Stuff goes here > bin/stuff.txt
```
This puts contents into the other two directories that were ignored before. You can add other things if you wish. Now `git add *` and `git commit -m “added zeus lives to plot”`.

So much for the `lives` branch. Let's switch back to master: `git checkout master`. This time we'll create a third plot: disappears.

`git branch disappears`

Since we're still on `master` for the time being, let's fill in the plot:

```
echo Zeus disappears > public/plot.txt
echo Stuff goes here > bin/stuff.txt
```
And of course, `git add *`, and `git commit -m “added zeus dies to plot”`. Now let's fill in the third plot on the new branch. To switch, do `git checkout dies`:
```
echo Zeus dies > public/plot.txt
echo Stuff goes here > bin/stuff.txt
```
Add whatever you want to Stuff. Incidentally, it's always worth checking `git status` to see the files that are untracked or staged. Earlier in this tutorial, only the `lib/` directory appeared in `git status`, because Git does not track empty directories, but now you'll that all directories are being tracked. So now commit on the third branch: `git add *` and `git commit -m “added zeus disappears to plot”`.

At times you may get lost, so just `ls` to see where you are or look at `git branch` and `git log` to reorient yourself.

We've decided that since Zeus is one of the gods, dying would be an improbable plot, so let's delete that one. You can do this using the `-d` flag:

`git branch -d dies`

Because this branch hasn't been merged, you will get a safety error. If you're sure, run this same command again, this time with the `-D` flag instead.

###Merging and Conflict Resolution










