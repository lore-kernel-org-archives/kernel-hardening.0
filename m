Date: Thu, 25 May 2017 11:48:18 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170525154818.2mj5xp7dywty4nje@thunk.org>
References: <CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
 <85inkpie9o.fsf@boum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85inkpie9o.fsf@boum.org>
Subject: Re: [kernel-hardening] Patch for random mac address
To: intrigeri <intrigeri@boum.org>, HacKurx <hackurx@gmail.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 25, 2017 at 09:31:15AM +0200, intrigeri wrote:
> 
> HacKurx:
> > Because this would be useful for distributions like Tails, Subgraph
> > OS, Kali Linux and other ...
> 
> For what it's worth, it's unlikely that Tails ever uses this unless it
> can be controlled at runtime from userspace: we need to give users an
> option to disable MAC address randomization, because it breaks network
> connectivity in some cases.

BTW, in case people aren't aware ---- you can set the MAC address from
userspace already:

Package: macchanger
Source: macchanger (1.7.0-5.3)
Version: 1.7.0-5.3+b1
Installed-Size: 636
Maintainer: David Paleino <dapal@debian.org>
Architecture: amd64
Depends: libc6 (>= 2.4), debconf (>= 0.5) | debconf-2.0, dpkg (>= 1.15.4) | install-info
Description-en: utility for manipulating the MAC address of network interfaces
 GNU MAC Changer is an utility that makes the maniputation of MAC addresses of
 network interfaces easier.  MAC addresses are unique identifiers on networks,
 they only need to be unique, they can be changed on most network hardware.
 MAC addresses have started to be abused by unscrupulous marketing firms,
 government agencies, and others to provide an easy way to track a computer
 across multiple networks.  By changing the MAC address regularly, this kind
 of tracking can be thwarted, or at least made a lot more difficult.
 .
 Features:
 .
   * set specific MAC address of a network interface
   * set the MAC randomly
   * set a MAC of another vendor
   * set another MAC of the same vendor
   * set a MAC of the same kind (eg: wireless card)
   * display a vendor MAC list (today, 6200 items) to choose from
Description-md5: b3958cf2d904ea6ecdbefc5cd46ec519
Homepage: https://github.com/alobbs/macchanger
Tag: network::configuration, role::program, scope::utility, suite::gnu,
 use::configuring
Section: net
Priority: extra
Filename: pool/main/m/macchanger/macchanger_1.7.0-5.3+b1_amd64.deb
Size: 192768
MD5sum: 35c51e01c0d778961eeda48faf4d884f
SHA256: 00cc5c1e6f2af37023315e5bb1473d3293acfdbf61fb4515c0cb094789d44147
