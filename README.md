Initial Set-up
--------------

Right now this is more of a "log of how I set this up" rather than a 
proper "readme" for users who check this module out to play with.

First, build vim 7.4 with python3 support. Then, after that I created a new repository 
on GitHub and checked in vimrc and the supporting shell scripts, then I added pathogen.vim. 
It is included from:

* https://github.com/tpope/vim-pathogen

I created a `vim/autoload` directory at the top-level and added a script to check out 
pathogen. Then I added these to the Git repository.

Next I manually created `vim/bundle` and added submodules. In the top level:

* git submodule add git://github.com/klen/python-mode.git vim/bundle/python-mode
* git submodule add git://github.com/scrooloose/syntastic.git vim/bundle/syntastic
* git submodule add git://github.com/tomtom/tlib_vim.git vim/bundle/tlib_vim
* git submodule add git://github.com/MarcWeber/vim-addon-mw-utils.git vim/bundle/vim-addon-mw-utils
* git submodule add git://github.com/gnperdue/vim-asciidoc.git vim/bundle/vim-asciidoc
* git submodule add git://github.com/tpope/vim-commentary.git vim/bundle/vim-commentary
* git submodule add git://github.com/garbas/vim-snipmate.git vim/bundle/vim-snipmate
* git submodule add git://github.com/gnperdue/vim-snippets.git vim/bundle/vim-snippets

Note, when checking this module out, the submodules will initially be empty (the 
directories will be present, but they will hold no content). To fill them, go to the 
top level:

* git submodule init
* git submodule update

Attempt to change a submodule url: First, clean out the submodule. Then, edit the .gitmodules
file to use the new url. Then run `git submodule sync`. Then run `git submodule init`. 
Then, run `git submodule sync`. But, `git remote -v` still points to the old submodule... 
If I push those changes and then re-check out the enitre VimConfig module, the remote 
repository is correct. But this is sort of a painful way to swap a submodule.

Python Update
-------------

I recently changed to Python 2 for my primary Python (Py 3 support is too spotty for 
machines I work and colleagues I work with). In order to get this to work, I made 
several attempts, and what ended up working involved two simultaneous changes. First,
I built vim with `--enable-pythoninter=yes` rather than `=dynamic` and I also re-checked
out `python-mode` with Python 2 first in my `$PATH`. The second step was definitely 
needed but it isn't clear the first step was. The first step by itself was not sufficient,
but it isn't clear if both were required.

Dealing with Changes to Submodules
----------------------------------

Example: I updated vim-snippets. When checking `git status` in the vim-snippets repository 
there is a detached HEAD, as expected. Therefore, I created a new branch with:

    git checkout -b work`date -u +%s`

This branch was committed. Note, in order to push this commit to the remote server 
for the first time, we have to change the remote url. The first time (after a 
`git submodule init` and `git submodule update`) we will get an error when trying to
push like:

    $ git push origin work1385047577
    fatal: remote error: 
      You can't push to git://github.com/blah.blah
      Use https://github.com/blah.blah

We fix this with:

    git remote set-url origin https://github.com/blah.blah

(Just use the URL Git tells you to use.) Then we can run:

    git push origin work1385047577

Now, the top-level repository, VimConfig, needs to point at 
that new commit for the submodule. This turns out to be very easy. `git status` in the 
supermodule reveals a change at `vim/bundle/vim-snippets` - all that needs to be done is this
needs to have `git add vim/bundle/vim-snippets` and then `git commit` to change the pointer
to the correct commit in the submodule.

As we keep making changes to submodules, we keep committing in the submodule first,
and then running `add` and `commit` in the supermodule to keep the pointers correct.

When updating a package we don't control, the appropriate method appears to be to 
simply run `git pull origin master`, then `git checkout master`. Following up with 
one more `git checkout master` is sometimes useful (?). Then, we simply run (in 
the toplevel VimConfig) `git add <submodule>` and `git commit` to point at the new 
chnageset.

Actually, a better way to update appears to be to do `git checkout SHA1` for the commit
you want to move to, then commit that from the top level.

Later, we may freely `git checkout master`, then `git merge new_branch`, and 
`git push origin master`. Then, to clean up (if it was just a temp branch), use
`git branch -D <branch name>` and `git push origin --delete <branchname>`.

Other Usage Notes
-----------------

Syntastic:

* Add the file `.syntastic_cpp_config` to the GENIE project directory.
* Add lines like `-I/path/to/include/dirs` to get syntastic to find esoteric headers.

