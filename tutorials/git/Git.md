#Git and Shell Tutorial

##What is Git?

Git is a version control system which we will be using in conjunction with GitHub. It is a way for developers to track files, track edits, securely record updates and collaborate on projects with other developers. In practical terms, Git is a set of commands which we will be learning to do this.

For the purpose of Ethereum development, we will be using Git and Github to collaborate. This is a guide to all the most common Git commands we will be using in this course. There are also more in depth tutorials available.

##A Note on Learning

According to neuroscience, the most effective ways to truly learn new information in a way that your brain will remember is to repeat each new skill about five times, followed by intermittent repetitions at increasing time intervals. 

Please don't just read this tutorial. If you want to read, I reccommend Dostoevsky. Dostoevsky wrote better novels than I do and will keep you entertained for many hours. If you want to truly learn and retain, the best approach is to follow along and practice.

##Shell

First, let's quickly run through navigating your way around your file system via the command line. This is a quick Shell tutorial for beginners without any assumptions- if you are already a wizard you can skip this section and go onto Git.

If you are on Linux or Mac, open the terminal. If you are on Windows open Powershell. If you don't have this, then download Git by following 
this link: https://git-scm.com/download/win and choose "64-bit Git for Windows Setup." Powershell should be included. Once this is downloaded Windows users should be able to see Powershell. While the terms "shell", "command line" and "terminal" are interchangeable, we'll use the generic term "shell" from now on regardless of operating system.

###Listing

Open the shell and type `ls` (“list”). `ls` is a command which displays all the files/folders contained in the current directory. “Directory” and “Folder” are interchangeable terms; folder is a more intuitive term used by File GUI's, but directory is the proper name.

If you are "Home", this should display a list of directories, for example, Desktop, Pictures, Documents. This is exactly what you see when you go into your File Explorer.

If you need to see more details, such as creation date, created by and permissions, you can use `ls -alt`. Try it! Here's what an average line-item output of `ls -alt` looks like for me:

`drwxrwxr-x 2 physes physes 4096 Jun 20 03:40 Git.md`

The first part `drwxrwxr -x` sets security permissions of whether the file is readable, writable or executable. `physes` is my username. `Jun 20 03:40` is the date, and `Git.md` is the file- which happens to be this one. We will look closer at permissions later in this tutorial.

Let's say you want to see what's in Documents. How to get there?

###Change Directory

`cd` is the command to change directory. Type `cd Documents`.

What if you want to display the content of the Documents directory?

Do `ls` in the Documents directory to list all of your files. Great, now you want to go home. If `cd` is how you move forward, how do you move back home?

Very simply- do `cd ..` This moves you back one step in the tree.

Bear in mind that, in the shell, two periods- `..` generally symbolises a single directory- one step in the three. If you wanted to go back two steps in the tree, you would do this: `cd ../../` Forward-slack `/` is a way of indicating the break-point. If you wanted to step back three
 steps it would be `cd ../../../` and so on. Although there are quicker ways of getting to other branches of the directory tree than manually cd-ing everywhere.

You can navigate fairly intuitively doing `ls` and `cd` forward `cd ..` back to look around. Do this about five times to get a sense of how it works.

###Print Working Directory

If at any time you get lost, don't panic! First of all, you can print your current location using `pwd` (print working directory.

Try this. `pwd` will show where you are in the file tree in relation to “root”- which is the beginning and represented by a forward-slash `/`. The home directory is usually one or two steps beyond root.

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

`rmdir: failed to remove ‘Downloads’: Directory not empty
`

To delete a directory which contains other contents, use `rm -r`. But be careful! There is no way of undoing this and many programmers have been burned by using this command.

Do `rm -r Old` to remove the Old directory you created earlier, along with its files.

###Moving and Copying Stuff

What if you want to make a copy of a file? Use the `cp [destination]` command, where `[destination]` stands for the path the file will be copied to. Note that you can't make an identical copy of the file in the current directory. Let's try it. `cd` into “Documents” and create a new file by doing `touch Reg.sol`. Then to make a copy, do `cp Reg.sol .`. 

(Note: double period `..` usually means one directory behind on the tree, whereas the single period `.` usually symbolizes the working directory. In the `cp Reg.sol .` command, `.` is a used as [destination]).

The result of this command is an error:

`cp: ‘Reg.sol’ and ‘./Reg.sol’ are the same file`

So instead, let's make a copy of Reg.sol back in the Home directory. You can use either `cp Reg.sol ..` with `..` as the destination, or you can use the tilde: `cp Reg.sol ~`.

What if you just want to move Reg.sol without making a copy? That's where the second use case of `mv` comes in handy. Delete the copy you just made in the home directory with `rm ~/Reg.sol`.

Now to move Reg.sol back home, do `mv Reg.sol ~/`. To check if successful `cd ..` back then do `ls` to list all the contents. If you can see it, congratulations! Now move it back to where it's supposed to be: `mv Reg.sol Documents`.

###Reading, Writing and Editing

The Shell is a bit like being in the cockpit of an aeroplane. There are many dials and things you can do which can greatly increase the speed and effectiveness of your work, but only if you know what you're doing.

One of the most useful skills is knowing how to read, write and edit files directly. Having to open a text editor every time you need to make a change is cumbersome. In shell, there are a number of options for editing directly. `cd` into your Documents directory and `touch read.txt` to create a new file called read.txt. To begin editing read.txt, use:

`nano read.txt`

`nano` is a convenient editor for writing to files. You could avoid having to create the file via `touch` by simply using `nano read.txt` which automatically creates the file as you are opening it. Now enter these two lines of text:

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
Using single `>` replaces the original two lines with one line. Now delete it: `rm littlelamb2.txt`. Now let's complete the verse by appending two lines to the end of littlelamb1.txt.

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
Using `>>` the lines have been appended to the end of the first two.

What if we wanted to edit a single word in the verse without having to do it manually? For this we will use a very powerful tool called Stream Editor (Sed). The scope of Sed is vast, and covering all of it is beyond the scope of this tutorial. You can learn more about it here if you're interested: http://www.grymoire.com/Unix/Sed.html.

We want to use `sed` to change the word `lamb` to `sheep` in littlelamb1.txt. The syntax using sed is this:

`sed 's/[old]/[new]/' [filename]`

The sed command is surrounded by single quotes (not necessary, but recommended), uses the keyword `s` meaning substitute, followed by three `/` demarcations with the old string and the string to replace it with. After the substitution command comes the filename we want to apply it to, which in our case is littlelamb.txt. So let's try it now:

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
