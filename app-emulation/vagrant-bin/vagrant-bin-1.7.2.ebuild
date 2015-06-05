EAPI="5"

inherit rpm 

DESCRIPTION="Vagrant is a tool for building complete development environments."
HOMEPAGE="http://www.vagrantup.com"
SRC_URI="
    x86?   ( https://dl.bintray.com/mitchellh/vagrant/vagrant_${PV}_i686.rpm )
    amd64? ( https://dl.bintray.com/mitchellh/vagrant/vagrant_${PV}_x86_64.rpm )
    "

SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="
    sys-libs/zlib
    "
RDEPEND="${DEPEND}"

RESTRICT="mirror"

S=${WORKDIR}/opt/vagrant
INSTALL_DIR="/opt/${PN}-${PV}"


src_unpack() {
    rpm_src_unpack "${A}"
    #cd "${S}/opt/vagrant"
}

src_install() {
    insinto "${INSTALL_DIR}"
    doins -r *

    fperms 755 ${INSTALL_DIR}/bin/vagrant
    fperms 755 ${INSTALL_DIR}/embedded/bin/*
    make_wrapper "vagrant" "${INSTALL_DIR}/bin/vagrant"
}

