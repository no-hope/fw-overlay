#Gentoo overlay#

[![Master Build Status](https://travis-ci.org/no-hope/fw-overlay.svg?branch=master)](https://travis-ci.org/no-hope/fw-overlay)

Yet another overlay full of very useful ebuilds :-)

##Developer guile##

To avoid naming clash with existing `fw-overlay` instance you may follow next steps:

    # git clone git@github.com:no-hope/fw-overlay.git
    # cd fw-overlay
    # git checkout develop
    # echo 'fw-overlay-dev' > profiles/repo_name
    # sudo ln -s "$(pwd)" /usr/local/portage/fw-overlay-dev
    # sudo echo 'PORTDIR_OVERLAY="${PORTDIR_OVERLAY} /usr/local/portage/fw-overlay-dev"' >> /etc/portage/make.conf

To speed-up developer `eix-update` you need to periodically run `sudo scripts/generate_cache.sh`
