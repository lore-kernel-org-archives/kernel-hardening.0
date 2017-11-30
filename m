Date: Thu, 30 Nov 2017 11:17:51 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20171130171751.GA5521@mail.hallyn.com>
References: <20171128211659.GP729@wotan.suse.de>
 <CAGXu5j+JaFCo+pZKvet==Kh7GQgNXi30P50SMF4cpOGoUw-8ug@mail.gmail.com>
 <20171129134612.72ccb53d@alans-desktop>
 <20171129.095014.1909386937628805919.davem@davemloft.net>
 <20171129155406.i2lyclquj75lvtn4@thunk.org>
 <20171129172852.GA14545@mail.hallyn.com>
 <20171130003531.gwpl22bxmweifjz2@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130003531.gwpl22bxmweifjz2@thunk.org>
Subject: [kernel-hardening] Re: [PATCH v5 next 1/5] modules:capabilities: add
 request_module_cap()
To: Theodore Ts'o <tytso@mit.edu>, "Serge E. Hallyn" <serge@hallyn.com>, David Miller <davem@davemloft.net>, gnomes@lxorguk.ukuu.org.uk, keescook@chromium.org, mcgrof@kernel.org, tixxdz@gmail.com, luto@kernel.org, akpm@linux-foundation.org, james.l.morris@oracle.com, ben.hutchings@codethink.co.uk, solar@openwall.com, jeyu@kernel.org, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, corbet@lwn.net, mingo@kernel.org, netdev@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 07:35:31PM -0500, Theodore Ts'o wrote:
> On Wed, Nov 29, 2017 at 11:28:52AM -0600, Serge E. Hallyn wrote:
> > 
> > Just to be clear, module loading requires - and must always continue to
> > require - CAP_SYS_MODULE against the initial user namespace.  Containers
> > in user namespaces do not have that.
> > 
> > I don't believe anyone has ever claimed that containers which are not in
> > a user namespace are in any way secure.
> 
> Unless the container performs some action which causes the kernel to
> call request_module(), which then loads some kernel module,

A local unprivileged user can do the same thing.  I reject the popular
notion that linux is a single user operating system.  More interesting
are the (very real) cases where root in a container can do something
which a local unprivileged user could not do.  Since a local unprivileged
user can always create a new namespace, *those* constitute a real and
interesting problem.

> potentially containing cr*p unmaintained code which was included when
> the distro compiled the world, into the host kernel.

> This is an attack vector that doesn't exist if you are using VM's.

Until the vm tenant uses a trivial vm escape.

> And in general, the attack surface of the entire Linux
> kernel<->userspace API is far larger than that which is exposed by the
> guest<->host interface.
> 
> For that reason, containers are *far* more insecure than VM's, since
> once the attacker gets root on the guest VM, they then have to attack
> the hypervisor interface.  And if you compare the attack surface of
> the two, it's pretty clear which is larger, and it's not the
> hypervisor interface.

Any time anyone spends a day looking at either the black hole that is
the hardware emulators or the xen and kvm code itself they walk away
with a set of cve's.  It *should* be more secure, it's not.  You're
telling me your house is safe because you put up a no tresspassing
sign.

-serge
