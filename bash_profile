#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.  Environment Configuration
#  2.  Make Terminal Better (remapping defaults and adding functionality)
#  3.  File and Folder Management
#  4.  Searching
#  5.  Process Management
#  6.  Networking
#  7.  System Operations & Information
#  8.  Web Development
#  9.  Reminders & Notes
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1. ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Change Prompt

    git_branch() {
      echo $(git branch --no-color 2>/dev/null | sed -ne "s/^\* \(.*\)$/\1/p")
    }

    export PS1='\[\033[0;33m\]\W/ \[\033[1;30m\] \[\033[1;32m\]$(git_branch)\[\033[0m\] $ '

#   Set Paths

    export PATH="$PATH:/usr/local/bin/"
    export PATH="/usr/local/git/bin:/sw/bin/:/usr/local/bin:/usr/local/:/usr/local/sbin:/usr/local/mysql/bin:$PATH"
    export PATH="/Users/shin/dev/github/spark-tda/dev/scripts:$PATH"
    export PATH="/Users/shin/Library/Haskell/bin:$PATH"
    export PATH=~/.local/bin:$PATH
    export PATH="/Library/TeX/texbin:$PATH"

#   Set Default Editor (change 'Nano' to the editor of your choice)

    export EDITOR=/usr/bin/nano

#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491

    export BLOCKSIZE=1k

#   Set locale.

    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8

#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles)
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/

#   export CLICOLOR=1
#   export LSCOLORS=ExFxBxDxCxegedabagacad


#   -----------------------------
#   2. MAKE TERMINAL BETTER
#   -----------------------------

#   Custom commands

    alias emacs='/usr/local/Cellar/emacs/26.3/bin/emacs -nw'
    alias cp='cp -iv'                           # Preferred 'cp' implementation
    alias mv='mv -iv'                           # Preferred 'mv' implementation
    alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
    alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
    alias less='less -FSRXc'                    # Preferred 'less' implementation
    cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
    alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
    alias ..='cd ../'                           # Go back 1 directory level
    alias ...='cd ../../'                       # Go back 2 directory levels
    alias .3='cd ../../../'                     # Go back 3 directory levels
    alias .4='cd ../../../../'                  # Go back 4 directory levels
    alias .5='cd ../../../../../'               # Go back 5 directory levels
    alias .6='cd ../../../../../../'            # Go back 6 directory levels
    alias edit='subl'                           # edit:         Opens any file in sublime editor
    alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
    alias ~="cd ~"                              # ~:            Go Home
    alias c='clear'                             # c:            Clear terminal display
    alias which='type -all'                     # which:        Find executables
    alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
    alias show_options='shopt'                  # Show_options: display bash options settings
    alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
    alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
    mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
    trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
    ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
    alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop


#   -----------------------------
#   3. DEVELOPER
#   -----------------------------

#   Java

    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"

#   Scala

    export PATH="${HOME}/.scalaenv/bin:${PATH}"
    eval "$(scalaenv init -)"
#    export PATH=/usr/local/src/scala/bin:/usr/local:$PATH
#    export SCALA_HOME=/usr/local/src/scala

#   Spark

    export SPARK_HOME=/usr/local/Cellar/apache-spark/2.2.1/libexec
    export PYTHONPATH=/usr/local/Cellar/apache-spark/2.2.1/libexec/python/:$PYTHONPATH$

#   Rubyenv

    eval "$(rbenv init -)"

#   Pyenv

    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"

#   Plenv

    eval "$(plenv init -)"

#   Nodebrew

    export PATH=$HOME/.nodebrew/current/bin:$PATH
    NODEBREW_ROOT=/usr/local/var/nodebrew

#   CoreNLP

    export STANFORD_MODELS=/Library/Java/Extensions/stanford-parser
    export CLASSPATH=${STANFORD_MODELS}:$CLASSPATH
    export CLASSPATH=${CLASSPATH}:/Library/Java/Extensions/stanford-corenlp/javax.json-api-1.0-sources.jar:/Library/Java/Extensions/stanford-corenlp/jaxb-api-2.4.0-b180830.0359-sources.jar:/Library/Java/Extensions/stanford-corenlp/stanford-corenlp-3.9.2-models.jar:/Library/Java/Extensions/stanford-corenlp/javax.activation-api-1.2.0-sources.jar:/Library/Java/Extensions/stanford-corenlp/ejml-0.23.jar:/Library/Java/Extensions/stanford-corenlp/javax.activation-api-1.2.0.jar:/Library/Java/Extensions/stanford-corenlp/slf4j-api.jar:/Library/Java/Extensions/stanford-corenlp/protobuf.jar:/Library/Java/Extensions/stanford-corenlp/joda-time.jar:/Library/Java/Extensions/stanford-corenlp/joda-time-2.9-sources.jar:/Library/Java/Extensions/stanford-corenlp/jaxb-impl-2.4.0-b180830.0438.jar:/Library/Java/Extensions/stanford-corenlp/xom-1.2.10-src.jar:/Library/Java/Extensions/stanford-corenlp/stanford-corenlp-3.9.2.jar:/Library/Java/Extensions/stanford-corenlp/xom.jar:/Library/Java/Extensions/stanford-corenlp/stanford-corenlp-3.9.2-javadoc.jar:/Library/Java/Extensions/stanford-corenlp/stanford-corenlp-3.9.2-sources.jar:/Library/Java/Extensions/stanford-corenlp/javax.json.jar:/Library/Java/Extensions/stanford-corenlp/jaxb-api-2.4.0-b180830.0359.jar:/Library/Java/Extensions/stanford-corenlp/jollyday.jar:/Library/Java/Extensions/stanford-corenlp/slf4j-simple.jar:/Library/Java/Extensions/stanford-corenlp/jaxb-core-2.3.0.1-sources.jar:/Library/Java/Extensions/stanford-corenlp/jaxb-core-2.3.0.1.jar:/Library/Java/Extensions/stanford-corenlp/jollyday-0.4.9-sources.jar:/Library/Java/Extensions/stanford-corenlp/jaxb-impl-2.4.0-b180830.0438-sources.jar
