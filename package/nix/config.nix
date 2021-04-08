{
    pulseaudio = true;
    packageOverrides = pkgs: with pkgs; {
        desktopPackages = pkgs.buildEnv {
            name = "desktopPackages";
            paths = [
                maven
                ctags
                git
                glibc
                htop
                jabref
                jq
                nodejs
                okular
                jdk
                pfetch
                php
                python3
                ranger
                rlwrap
                tectonic
                textql
                tmux
                tmuxinator
                toilet
                vimHugeX
                visidata
                xrandr-invert-colors
                zsh
            ];
            pathsToLink = [ "/share/man" "/share/doc" "/bin" ];
            extraOutputsToInstall = [ "man" "doc" ];
        };
    };
}
