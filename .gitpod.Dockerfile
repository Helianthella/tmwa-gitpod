FROM gitpod/workspace-full-vnc

USER gitpod

# use apt mirrors for faster fetching
RUN sudo sed -i -e 's%https\?://\(us.\)\?archive.ubuntu.com/ubuntu/%mirror://mirrors.ubuntu.com/mirrors.txt%' /etc/apt/sources.list

RUN wget http://repo.evolonline.org/manaplus/ubuntu/manaplus-addrepo_1.3_all.deb \
 && sudo apt install -yy -qq ./manaplus-addrepo_1.3_all.deb \
 && rm manaplus-addrepo_1.3_all.deb \
 && sudo sed -i "s/manaplus \w\+ /manaplus disco /" /etc/apt/sources.list.d/mana* \
 && sudo apt-get update \
 && sudo apt-get install -yy \
    manaplus valgrind gdb \
    make autoconf automake autopoint libtool libz-dev \
    libmysqlclient-dev zlib1g-dev libpcre3-dev \
    wget tmux ripgrep zsh \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

RUN sudo ln -s /usr/games/manaplus /usr/bin/manaplus
