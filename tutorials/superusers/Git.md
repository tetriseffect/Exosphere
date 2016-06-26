#Superuser Tutorial

##Introduction

This is a two part tutorial, which will introduce two basic skills which are necessary the Ethereum Stream and programming in general: Shell and Git. The Bourne Shell (“Bash”) is a command line interpreter unique to all Unix-based systems. Git is a version control system which we will be using in conjunction with GitHub. It is a way for developers to track files, track edits, securely record updates and collaborate on projects with other developers. 

###A Note on Learning

According to neuroscience, the most effective ways to learn new information in a way that your brain will remember is to repeat each new skill about five times, followed by intermittent repetitions at increasing time intervals. 

Please don't just read these tutorials. If you want to read, I reccommend Dostoevsky. Dostoevsky wrote better novels than I do and will keep you entertained for many hours. If you truly want to learn and retain, the best approach is to follow along and practice.

##Table of Contents

1. [Get Started](#Get Started)
2. [Listing](#Listing)
3. [Change Directory](#Change Directory)
4. [Print Working Directory](#Print Working Directory)
5. [Home ~ and Root /](#Home `~` and Root `/`)
6. [Make Files and Directories](#Make Files and Directories)
8. [Remove Files and Directories](#Remove Files and Directories)
9. [Deleting Full Directories](#Deleting Full Directories)
10. [Moving and Copying Stuff](#Moving and Copying Stuff)
11. [Danger](#Danger)
12. [Reading, Writing and Editing](#Reading, Writing and Editing)
13. [Permission Management](#Permission Management)
14. [Adapting the Environment](#Adapting the Environment)
15. [Bash Profile](#Bash Profile)
16. [Summary](#Summary)
17. [Conclusion](#Conclusion)

###Get Started

First, let's quickly run through navigating your way around your file system via the command line.

If you are on Linux or Mac, open the terminal. If you are on Windows open Powershell. If you don't have this, then download Git by following this link: https://git-scm.com/download/win and choose "64-bit Git for Windows Setup." Powershell should be included. Once this is downloaded Windows users should be able to see Powershell. While the terms "shell", "command line" and "terminal" are interchangeable, we'll use the generic term "shell" from now on regardless of operating system. “Bash” is also used to refer to the specific implementation of the Bourne Shell, but there are also many others available.

###Listing

Open the shell and type `ls` (“list”). `ls` is a command which displays all the files/folders contained in the current directory. “Directory” and “Folder” are interchangeable terms; folder is a more intuitive term used by File GUI's, but directory is the proper name. 

If you are "Home", this should display a list of directories, for example, Desktop, Pictures, Documents. This is exactly what you see when you go into your File Explorer. 

If you need to see more details, such as creation date, created by and permissions, you can use `ls -alt`. Try it! Here's what an average line-item output of `ls -alt` looks like for me:

`drwxrwxr-x 2 physes physes 4096 Jun 20 03:40 Git.md`

The first part `drwxrwxr -x` sets security permissions of whether the file is readable, writable or executable. `physes` is my username. 	`Jun 20 03:40` is the date, and `Git.md` is the file- which happens to be this one.

Let's say you want to see what's in Documents. How to get there? 

###Change Directory

`cd` is the command to change directory. Type `cd Documents`. 

What if you want to display the content of the Documents directory? 

Do `ls` in the Documents directory to list all of your files. Great, now you want to go home. If `cd` is how you move forward, how do you move back home? 

Very simply- do `cd ..` This moves you back one step in the tree. 

Bear in mind that, in the shell, two periods- `..` generally symbolises a single directory- one step in the three. If you wanted to go back two steps in the tree, you would do this: `cd ../../` Forward-slack `/` is a way of indicating the break-point. If you wanted to step back three steps it would be `cd ../../../` and so on. Although there are quicker ways of getting to other branches of the directory tree than manually cd-ing everywhere. 

You can navigate fairly intuitively doing `ls` and `cd` forward `cd ..` back to look around. Do this about five times to get a sense of how it works. 

###Print Working Directory

If at any time you get lost, don't panic! First of all, you can print your current location using `pwd` (print working directory.

Try this. `pwd` will show where you are in the file tree in relation to “root”- which is the beginning and represented by a forward-slash `/`. The home directory is usually one or two steps beyond root.

At any time you can clear the shell screen using the keyword `clear`, which will remove the mess (although you can still scroll up if you need to).

###Home `~` and Root`/`

You can return to your Home directory from any location by doing `cd ~` (in all of these commands, don't forget the space). The tilde `~` is a general way to refer to the home directory in shell-speak. So anytime you are lost, just do `cd ~` and you will return to where you started. Similarly, if you want to jump all the way back to root, just do `cd /`.

Let's try it. Go back to root (`cd /`), then `ls` to see the files. It probably won't be immediately obvious how to get back to the home directory, so you can do `cd ~` to get back to where you started.

What you want to skip sideways across directories?

###Make Files and Directories

Before we skip across directories, let's create a new directory. You can create a new directory in Home by typing `mkdir New` (or any name you like). `mkdir` as you can probably guess means “make directory”. Now `ls` to see the New directory displayed alongside all the other contents of Home.

`cd` into “New” and do `ls`. As you can see, it's an empty directory. What if you wanted to create a new file?

There are several ways of doing this, but the quickest way to create an empty file without editing it is to use the command `touch [filename]`. We want to create a file called “Hello.txt”.

So do `touch Hello.txt`. You can use the `touch` command to create any kind of file, of any format. If you wanted to create an Index.js or Contract.sol you would do `touch Index.js` or `touch Contract.sol`. If you want to create multiple files at the same time this is also possible: `touch Index.js Contract.sol Hello.txt`. Try this a few times to create as many files as you like.

###Remove Files and Directories

Since we only need Hello.txt for our purposes, if you want to delete the other files in the New directory, use the `rm [filename]` command. `rm` work similar to touch in that you can remove many at the same time.

`rm Index.js Contract.sol`.

Now, we were wanting to skip across directories. `cd ..` to get back to Home and then `cd Documents`. What if you want to skip across to the New directory without having to manually step back and forward all the time? Easy. To Skip from Documents to New takes two steps: back one and forward one, which is:

`cd ../New`

In this chained together command, `..` brings us back a step and `/New` steps forward into New. But this only works if you one step ahead of the Home directory. If you are completely elsewhere in the file tree and still want to quickly navigate to New, you can use the Home shortcut `~`. This would be `cd ~/New`.

Now that you're back in the New directory, create another empty directory within New called Newest: `mkdir Newest`.

You can delete empty directories with the `rmdir` (remove directory) command. Since Newest is empty, use `rmdir Newest` to delete it.

Now 	`cd ..` back Home. What if you want to rename New to Old?

Use the `mv` (move) command. `mv` does a number of things- you can use the syntax `mv [oldname] [newname]` to rename files or directories. Naturally, `mv` can also be used to move objects to another location, using the syntax `mv [filename] [newlocation]`. For now let's focus on the first usage.

`mv New Old`

“New” stands for the previous name, which has now been changed to “Old”.

###Deleting Full Directories

`rmdir` only works if the directory is empty. Trying it on `Documents` with result in 

`rmdir: failed to remove ‘Downloads’: Directory not empty `

To delete a directory which contains other contents, use `rm -r`. But be careful! There is no way of undoing this and many programmers have been burned by using this command.

Do `rm -r Old` to remove the Old directory you created earlier, along with its files.

###Moving and Copying Stuff

What if you want to make a copy of a file? Use the `cp [destination]` command, where `[destination]` stands for the path the file will be copied to. Note that you can't make an identical copy of the file in the current directory. Let's try it. `cd` into “Documents” and create a new file by doing `touch Reg.sol`. Then to make a copy, do `cp Reg.sol .`. 

(Note: double period `..` usually means one directory behind on the tree, whereas the single period `.` usually symbolizes the working directory. In the `cp Reg.sol .` command, `.` is a used as [destination]).

The result of this command is an error:

`cp: ‘Reg.sol’ and ‘./Reg.sol’ are the same file`

So instead, let's make a copy of Reg.sol back in the Home directory. You can use either `cp Reg.sol ..` with `..` as the destination, or you can use the tilda: `cp Reg.sol ~`. 

What if you just want to move Reg.sol without making a copy? That's where the second use case of `mv` comes in handy. Delete the copy you just made in the home directory with `rm ~/Reg.sol`.

Now to move Reg.sol back home, do `mv Reg.sol ~/`. To check if successful `cd ..` back then do `ls` to list all the contents. If you can see it, congratulations! Now move it back to where it's supposed to be: `mv Reg.sol Documents`.

###Danger

The Shell is a bit like being in the cockpit of an aeroplane. There are many dials and things you can do which can greatly increase the speed and effectiveness of your work if you know what you're doing. But if you don't know what you're doing, then things could go badly wrong.

Here is an article which lists dangerous commands that [you should never use](http://www.howtogeek.com/125157/8-deadly-commands-you-should-never-run-on-linux/).

Earlier, we used a command, `rm -r [directory]` to recursively delete directories with full contents. Another possibility is `rm -rf [directory]`. Both of these are safe (as long as you are happy with removing everything in the chosen directory).

NEVER use the command `rm -rf /` or `rm -rf *`. This will irreversibly wipe your computer clean. It implements a recursive deleting process starting at the root of the file tree, which is designated by `/`. It's important to know about `rm -rf /` so that you can be sure to avoid it.

###Reading, Writing and Editing

One of the best skills to know is how to read and write from files. `cd` into your Documents directory and `touch read.txt` to create a new file called read.txt. There a couple of options for adding text, but to edit from the command line you can use:

`nano read.txt`

`nano` is a convenient editor for writing to files. You could avoid having to create the file via `touch`  If this is unavailable in your Shell version, you can also try another shell editor, `vi`, but the controls are less intuitive than nano. Enter these two lines of text:

```
Mary had a little lamb
His fleece was white as snow
```

When you are finished press `ctrl-o` to save. It will give you an option to write to this file and change the name. Change it to littlelamb1.txt. Now press `ctrl-x` to exit back into the Documents directory.

To read the contents of file without having to go back into the editor, use the `cat` command. `cat` is a useful feature which takes an input and displays it on the shell.

`cat littlelamb1.txt`

To see the first two lines of the rhyme displayed on the screen. This is a handy way to easily inspect files. Now what if we want to write to a file without having to go through the hassle of opening it via `nano`?

This is where the `echo` command is used. `echo` is used in a number of contexts in shell scripting, but for our purposes, we will contrast it with `cat` for reading and `echo` for writing files.

The syntax to write to a file is `echo [input] >> [file]`. (you can quote the text but it's not necessary). Using `>>` appends the text input to the END of the file, without deleting the previous lines. `>` on the other hand deletes what is already there and replaces all of it is your text input. Unless you are sure (or have committed your work to Git) it's better to stick with `>>`. 

To test this out, let's make a copy of `littlelamb1.txt` to play around with: `cp littlelamb1.txt littlelamb.txt2` and check. Now try:

```
echo Mary had a little fox > littlelamb2.txt

cat littlelamb2.txt 

```
As you can see, using single `>` replaces the original two lines with one line. Now delete it: `rm littlelamb2.txt`. Now let's complete the verse by appending two lines to the end of littlelamb1.txt.

So far we have used the `echo` command to enter text on one line, but what if we want to use multiple lines? There are a couple of factors that go into this. First we attach the `-e` flag to `echo`: `echo -e`. Second use the backslash to go to a new line in the shell: `\`. Make sure you encircle the lines in quotes. At the end, write it into `littlelamb1.txt` using the `>>` symbol.

All together, this looks like:

```
#to go to the next line, just hit enter

echo -e \
“And everywhere that Mary went
The lamb was sure to go.” >> littlelamb1.txt

#Now print:

cat littlelamb1.txt

Mary had a little lamb
His fleece was white as snow
And everywhere that Mary went
The lamb was sure to go.

``` 
As you can see, using `>>` the lines have been appended to the end of the first two.

What if we wanted to edit a single word in the verse without having to do it manually? For this we will use a very powerful tool called Stream Editor (Sed). The scope of Sed is vast, and covering all of it is beyond the scope of this tutorial. If you are interested, you can learn more about it here: http://www.grymoire.com/Unix/Sed.html.

We want to use `sed` to change the word `lamb` to `sheep` in littlelamb1.txt. The syntax using sed is this:

`sed 's/[old]/[new]/' [filename]`

As you can see, the sed command is surrounded by single quotes (not necessary, but recommended), uses the keyword `s` meaning substitute, followed by three `/` demarcations with the old string and the string to replace it with. After the substitution command comes the filename we want to apply it to, which in our case is littlelamb.txt. So let's try it now:

```
sed 's/lamb/sheep/' littlelamb1.txt
```
Which should give the corrected output. Try this with a few files to substitute new words in place of old to get a sense of how it works.


###Permission Management

The most useful thing to learn into Permission Management is `su` and `sudo`, which is a program which allows the user to run programs with the security priveleges of another user. `su` stands for `superuser` and `sudo` stands for `superuser do`.

To try this out in practice, navigate to the root of your computer with `cd /`. Now attempt to create a file: `touch file.txt`, which will recieve a response: `touch: cannot touch ‘file.txt’: Permission denied`.

Now prefix the command with `sudo`: 

`sudo touch file.txt`

Now `ls` to see the newly created file with the other root directories. To delete, do `sudo rm file.txt` and return home- `cd ~`.

`chmod` (change mode) is a UNIX tool for managing permissions for files: whether files are readable, writable or executable. Earlier in this tutorial, we listed the contents of a directory in detail using `ls -l`, which displays not only the name of the files but also their creation date, user and permission structure. For example: 

`drwxrwxr-x 2 physes physes 4096 Jun 20 03:40 Git.md`

The first part, `drwxrwxr -x` defines the set of rules for the file and who can access/modify it. `chmod` is how you change these rules. In general, chmod commands take the form:

`chmod options permissions filename`

Each of the relevant letters stand for an option:

```
r = read
w = write
x = execute
```
There are three permission groups:

```
u = user
g = members of your group 
o = others
a = all
```
Let's create a file and play around with permissions: `touch permissions.txt`. Now `ls -l` and find this newly created file in the list. For me it is:

`-rw-rw-r--   1 physes physes     0 Jun 26 21:31 permissions.txt
`

Look at the left: `-rw-rw-r--`. You can see three seperate statements, in order of user, group and others. The user is set to `rw (read/write)` (naturally since it's a text file, there is no `x` option. The group is also set to `rw`, whereas “others” is set just to `r`- read only.

In one `chmod` command, you can define how all three groups get to access `permissions.txt`. Note that it is not compulsory to define rules for all three. 

Let's say you can to give full read/write (`rw`) permissions to the other group:

`chmod o=rw permissions.txt`

-Where “o” is others.

There are three operators you can use to assign permissions to an owner (u/g/o/a). They are:
```
=  //sets permissions to the owner
+  //causes a selected mode bit to be added to an existing file mode
-  //causes the selected mode bit to be removed

chmod u-w permissions.txt  //write permission is removed from “user”
chmod o+w permissions.txt  //add write permission to “other”
chmod u=wr permissions.txt //give both write and read perms to user 
```
Incidentally, it's worth testing. After removing write permissions for the user with `chmod u-w permisssions.txt`, do `nano permissions.txt` and change the file to anything you like and try to save with `ctrl-o`. You will not be allowed. Try it. Also try removing read permission and doing `cat` on the file.

After trying it out a couple of times, do `ls -l` and you will see that the line has been changed. `x` only works for programs, not files.

You can change two in one go or even all three. To change all groups to give only read-only access, you can do the following:

`chmod u=wr, u+w, o-w permissions.txt`

Like other Shell tools like `sed`, `awk`, and others, `chmod` has extensive functionality which is worth looking into.

###Adapting the Environment

One of the things that you will need to know about as a programmer is how to set environmental variables. Environmental variables are settings which assign locations to important files or programs which affect how your computer works.

To see the full list of environmental variables, do `env`. This will show a long list. At any time you can check a specific one using a command of the general form `echo $VAR` where VAR is the name of whichever variable you want to check.

The environmental variable of most interest for general purposes is PATH. The PATH variable is used by the shell to search for the source file when executing a program. To display the contents, use `echo $PATH`. This should display something like:

`/bin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games`

Each seperation, designated by `:`, is an individual path which the Shell checks to execute a program. Often downloading a program will involve adding the location to the path variable. To add to PATH, takes the form of:

`export PATH=$PATH:/path/to/file`

There are a number of ways of doing it, and `export` is one of them. In the above command, “PATH” is a kind of handle which can be replaced by anything. Another example example, to add Solidity to the PATH,you would do `solc=$PATH:/usr/bin/solc`.

This will set the path in UNIX.

###Bash Profile

There are a number of things you can do with the profile. Do `nano ~/.profile` to check the profile. You'll see a shell script which configures HOME and PATH. 

Now `ctrl-x` to exit and look at `~/.bash_profile`.

In `~/.bash_profile` you can edit the shell prompt.

To do this, open `nano ~/.bash_profile` now. The prompt is designated by `PS2`. To change it, type `export PS2= “[prompt]”` where [prompt] is whatever you like. Press `ctrl-o` to save (don't change the filename). My prompt is a minimal “ >> “ at the beginning of every line, which is done with `export PS2= “ >> “`. But you can make it whatever you want. Save `ctrx-o` and exit `ctrl-x`.

An alias is a kind of shortcut which lives in `~/.bashrc`. Aliases can refer to both particular paths, shell commands and even chained-together statements and commands. An alias takes the form of `[alias]='[command/s]'`. For example, if you want to replace `ls` with `list`, the command would be `list='ls'`.

You can add the alias command to the end of `~/.bashrc` by opening it, but also by using `echo`.

To create a keyword `change` instead of `cd`, do: 

`echo alias change=\”cd\” >> ~/.bashrc` 

Caution: this new alias won't be usable until you close and restart the shell. Also: if you to type the alias directly into bashrc there is no need to prefix the quotes with `\`. This is only for the purpose of echoing.

What if we can to create a shortcut to a particular file? Let's say we want to create a short “docs” for Documents and “pics” for Pictures. You can find the full path using `pwd` then take note. The commands are:
```
echo alias docs=\”cd /path/to/Documents\” >> ~/.bashrc
echo alias pics=\”cd /path/to/Pictures\” >> ~/.bashrc
```
Now exit the shell and restart, and try out the `docs` and `pics` shortcuts. Try create your own!

###Summary
```
#This is a list of everything we've learned in this tutorial. Follow along any #time you need to refresh your memory.

ls
ls -alt
ls -l
cd Documents
ls
cd ..
pwd
clear
cd /
ls
cd ~
ls
mkdir New
cd New
touch Index.js Contract.sol Hello.txt
rm Index.js Contract.sol
cd ..
cd Documents
cd ../New
ls
mkdir Newest
rmdir Newest
cd ..
mv New Old
rmdir Documents (fails)
rm -r Old
cd Documents 
touch Reg.sol 
cp Reg.sol . (fails)
cp Reg.sol ~ 
rm ~/Reg.sol
ls
mv Reg.sol ~/ 
cd .. 
ls
cd Documents 
touch read.txt 
nano read.txt 
Mary had a little lamb 
His fleece was white as snow 
ctrl-o 
littlelamb1.txt 
ctrl-x 
cat littlelamb1.txt
cp littlelamb1.txt littlelamb2.txt 
ls 
echo Mary had a little fox > littlelamb2.txt 
cat littlelamb2.txt 
rm littlelamb2.txt 

echo -e \ 
“And everywhere that Mary went 
The lamb was sure to go.” >> littlelamb1.txt

cat littlelamb1.txt 
sed 's/lamb/sheep/' littlelamb1.txt
cat littlelamb1.txt
cd / 
touch file.txt(fails) 
sudo touch file.txt 
ls 
sudo rm file.txt 
cd ~
ls -l 
touch permissions.txt 
ls -l 
chmod o=wr permissions.txt 
chmod u-w permissions.txt 
chmod o+w permissions.txt 
nano permissions.txt
write anything to file
ctrl-o (fails)
ctrl-x
chmod u-r permissions.txt
cat permissions.txt (fails)
ls -l
env
echo $HOME
echo $PATH
solc=$PATH:/usr/bin/solc
echo $PATH
nano ~/.profile 
ctrl-x 
nano ~/.bash_profile 
export PS2=” >> “ 
ctrl-o 
ctrl-x
echo alias change=\”cd\” >> ~/.bashrc
echo alias docs=\”cd /path/to/Documents\” >> ~/.bashrc
echo alias pics=\”cd /path/to/Pictures\” >> ~/.bashrc
```

###Conclusion

This has been a brief introduction to using the shell. If you recieved value from this tutorial, I accept Ether donations: 0x6c96ade1ddad3511cbe5682beff034d990b5b22a.

The next tutorial will cover Git. 
