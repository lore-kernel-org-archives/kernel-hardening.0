Date: Wed, 29 Nov 2017 10:54:06 -0500
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20171129155406.i2lyclquj75lvtn4@thunk.org>
References: <20171128211659.GP729@wotan.suse.de>
 <CAGXu5j+JaFCo+pZKvet==Kh7GQgNXi30P50SMF4cpOGoUw-8ug@mail.gmail.com>
 <20171129134612.72ccb53d@alans-desktop>
 <20171129.095014.1909386937628805919.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171129.095014.1909386937628805919.davem@davemloft.net>
Subject: [kernel-hardening] Re: [PATCH v5 next 1/5] modules:capabilities: add
 request_module_cap()
To: David Miller <davem@davemloft.net>
Cc: gnomes@lxorguk.ukuu.org.uk, keescook@chromium.org, mcgrof@kernel.org, tixxdz@gmail.com, luto@kernel.org, akpm@linux-foundation.org, james.l.morris@oracle.com, ben.hutchings@codethink.co.uk, solar@openwall.com, serge@hallyn.com, jeyu@kernel.org, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, corbet@lwn.net, mingo@kernel.org, netdev@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 09:50:14AM -0500, David Miller wrote:
> From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> Date: Wed, 29 Nov 2017 13:46:12 +0000
> 
> > I really don't care what the module loading rules end up with and
> > whether we add CAP_SYS_YET_ANOTHER_MEANINGLESS_FLAG but what is
> > actually needed is to properly incorporate it into securiy ruiles
> > for whatever LSM you are using.
> 
> I'm surprised we're not using the SHA1 hashes or whatever we compute
> for the modules to make sure we are loading the foo.ko that we expect
> to be.

We do have signed modules.  But this won't help us if the user is
using a distro kernel which has compiled some module which is known to
be unmaintained which everyone in the know *expects* to have 0-day
bugs, such as DCCP.  That's because the DCCP module is signed.

We could fix this by adding to the signature used for module signing
to include the module name, so that the bad guy can't rename dccp.ko
to be ppp.ko, I suppose....

> All of this capability stuff seems to dance a circle around the
> problem rather than fix it.

Half the problem here is that with containers, people are changing the
security model, because they want to let untrusted users have "root",
without really having "root".  Part of the fundamental problem is that
there are some well-meaning, but fundamentally misguided people, who
have been asserting: "Containers are just as secure as VM's".

Well, they are not.  And the sooner people get past this, the better
off they'll be....

						- Ted
