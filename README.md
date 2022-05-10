#Gentoo overlay#

[![Master Build Status](https://github.com/no-hope/fw-overlay/actions/workflows/build-cache.yml/badge.svg)](https://github.com/no-hope/fw-overlay)

Yet another overlay full of very useful ebuilds :-)

##Developer guile##

Development allowed for `development` branch only. To avoid naming clash with existing `fw-overlay` instance you may follow next steps:

    # git clone git@github.com:no-hope/fw-overlay.git
    # cd fw-overlay
    # git checkout develop
    # echo 'fw-overlay-dev' > profiles/repo_name
    # sudo ln -s "$(pwd)" /usr/local/portage/fw-overlay-dev

and then

    # sudo echo 'PORTDIR_OVERLAY="${PORTDIR_OVERLAY} /usr/local/portage/fw-overlay-dev"' \
        >> /etc/portage/make.conf

or (preferred way)

    # cat << 'EOF' >> /etc/portage/repos.conf/dev.conf
    [fw-overlay-dev]
    priority = 50
    location = /usr/local/portage/fw-overlay-dev
    auto-sync = no
    EOF

To speed-up development tools like `eix-update` you need to periodically run `sudo scripts/generate_cache.sh`.
