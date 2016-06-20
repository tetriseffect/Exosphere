#Git Tutorial

##What is Git?


Git is a version control system which we will be using in conjunction with GitHub. It is a way for developers to track files, track edits, securely record updates and collaborate on projects with other developers. In practical terms, Git is a set of commands which we will be learning to do this.

For the purpose of Ethereum development, we will be using Git and Github to collaborate. This is a guide to all the most common Git commands we will be using in this course. There are also more in depth tutorials available.


##A Note on Learning

It takes about 5 repetitions to learn something in a way that you will remember. As well as intermittent “half-life” repetitions after the initial learning. One of the problems programmers come across when learning new skills is forgetting something they previously learned. This is also true when learning mathematics- it is often an additative process that relies on previous knowledge to get to higher levels. And if you miss a lower step it can be a problem. From now on, get into the habit of practicing or integrating a new skill item about 5 times. It may be slightly slower, but you'll likely remember it for much longer than just reading.


##Navigation


First, let's quickly run through navigating your way around your file system via the command line. This is a quick Shell tutorial for beginners without any assumptions- if you are already a shell wizard you can skip this section.

If you are on Linux or Mac, open the terminal. If you are on Windows open Powershell. If you don't have this, then download Git by following this link: https://git-scm.com/download/win and choose "64-bit Git for Windows Setup." Powershell should be included. Once this is downloaded Windows users should be able to see Powershell. While the terms "shell", "command line" and "terminal" are interchangeable, we'll use the generic term "shell" from now on regardless of OS.


###Listing


Open the shell and type `ls` (think “list”). `ls` is a command which displays all the files/folders contained in the current directory. “Directory” and “Folder” are interchangeable terms; folder is a more intuitive term used by File GUI's, but directory is the proper name.

If you are "Home", this should display a list of directories, for example, Desktop, Pictures, Documents. This is exactly what you see when you go into your File Explorer.

Let's say you want to see what's in Documents. How to get there?


###Change Directory

`cd` is the command to change directory. Type `cd Documents`.

What if you want to display the content of the Documents directory?

Do `ls` in the Documents directory to list all of your files. Great, now you want to go home. If `cd` is how you move forward, how do you move back home?

Very simply- do `cd ..` This moves you back one step in the tree.

Bear in mind that, in the shell, two periods- `..` generally symbolises a single directory- one step in the three. If you wanted to go back two steps in the tree, you would do this: **cd ../../` Forward-slack `/` is a way of indicating the break-point. If you wanted to step back three steps it would be `cd ../../../` and so on. Although there are quicker ways of getting to other branches of the directory tree than manually cd-ing everywhere.

You can navigate fairly intuitively doing `ls` and `cd` forward `cd ..` back to look around. Do this about five times to get a sense of how it works.


###Print Working Directory

If at any time you get lost, don't panic! First of all, you can print your current location using `pwd` (print working directory.

Try this. `pwd` will show where you are in the file tree in relation to “root”- which is the beginning and represented by a forward-slash `/`. The home directory is usually one or two steps beyond root.


###Home ~ and Root/

You can return to your Home directory from any location by doing `cd ~` (in all of these commands, don't forget the space). The tilda `~` is a general way to refer to the home directory in shell-speak. So anytime you are lost, just do `cd ~` and you will return to where you started. Similarly, if you want to jump all the way back to root, just do `cd /`.

Let's try it. Go back to root (`cd /`), then `ls` to see the files. It probably won't be immediately obvious how to get back to the home directory, so you can do `cd ~` to get back to where you started.

What you want to skip sideways across directories?


###Make Files and Directories

Before we can skip across directories, we first have to create a new directory with a new folder (since I don't know exactly what other folders you have). You can create a new directory in Home by typing `mkdir New` (or any name you like). **mkdir** as you can probably guess means “make directory”. Now `ls` to see the New directory displayed alongside all the other contents of Home.

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

Now `cd ..` back Home. What if you want to rename New to Old?

Use the `mv` (move) command. `mv` does a number of things- you can use the syntax `mv [oldname] [newname]` to rename files or directories. Naturally, `mv` can also be used to move objects to another location, using the syntax `mv [filename] [newlocation]`. For now let's focus on the first usage.

`mv New Old`

“New” stands for the previous name, which has now been changed to “Old”.


###Deleting Full Directories

`rmdir` only works if the directory is empty. Trying it on `Documents` with result in 

`rmdir: failed to remove ‘Downloads’: Directory not empty
`

To delete a directory which contains other contents, use `rm -r`. But be careful! There is no way of undoing this and many programmers have been burned by using this command.

Do `rm -r Old` to remove the Old directory you created earlier, along with its files.

###Moving and Copying


