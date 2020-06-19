FROM nginx:1.19-alpine

RUN apk add --no-cache bash less vim
ADD nginx.conf /etc/nginx
RUN echo $'alias ll="ls -lh"\n\
alias la="ls -lah"\n\
alias h="history"\n\
alias grep="grep --color=auto"\n\
HISTSIZE=50000\n\
HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S "\n\
PS1="[\w]\\$ "\n\
export CLICOLOR=1\n\
export LSCOLORS=DxGxcxdxCxegedabagacad\n\
export LESS="-g -M -R -S -W -z-4 -x4"' > /root/.bashrc
