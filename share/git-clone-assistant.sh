#!/bin/sh

# Instructions:
# In the terminal, run
#
#   sh <(curl -L https://raw.githubusercontent.com/abstrnoah/dotfiles/main/share/git-clone-assistant.sh) REPOSITORY_NAME

{ # Prevent run on incomplete fetch.

key_path=~/.ssh/id_rsa
remote="server02.brumal.net:${1}"

[ -n "${1}" ] || { echo "usage: ${0} REMOTE_DIRECTORY"; exit 1; }

gen_key() {
    mkdir -p ~/.ssh
    ssh-keygen -t rsa-sha2-512 -N "" -f "${key_path}" -q
}

get_key() {
    [ -f "${key_path}.pub" ] || gen_key
    cat "${key_path}.pub"
}

echo "Please email the following public key to the admin and await a"
echo "response..."
echo
get_key

echo
echo "Press Enter to continue when you get a response or Ctrl-C to exit now"
echo "(you can safely run the script again later)."
read _

echo "Cloning \"${USER}@${remote}\" in current directory..."
export GIT_SSH_COMMAND="ssh -p 2202 -o 'ProxyCommand /bin/nc -X connect -x %h:443 %h %p' -i ${key_path} -l ${USER}"
if git clone "${remote}"; then
    echo
    echo "All done :)"
else
    echo
    echo "An error occured, contact the admin."
fi

}
