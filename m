Date: Wed, 29 Nov 2017 11:29:45 -0500
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20171129162945.u2zjcoe4gsanhmkc@thunk.org>
References: <20171129134612.72ccb53d@alans-desktop>
 <20171129.095014.1909386937628805919.davem@davemloft.net>
 <20171129155406.i2lyclquj75lvtn4@thunk.org>
 <20171129.105816.1108278026315471171.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171129.105816.1108278026315471171.davem@davemloft.net>
Subject: [kernel-hardening] Re: [PATCH v5 next 1/5] modules:capabilities: add
 request_module_cap()
To: David Miller <davem@davemloft.net>
Cc: gnomes@lxorguk.ukuu.org.uk, keescook@chromium.org, mcgrof@kernel.org, tixxdz@gmail.com, luto@kernel.org, akpm@linux-foundation.org, james.l.morris@oracle.com, ben.hutchings@codethink.co.uk, solar@openwall.com, serge@hallyn.com, jeyu@kernel.org, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, corbet@lwn.net, mingo@kernel.org, netdev@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 10:58:16AM -0500, David Miller wrote:
> That's not what we're talking about.
> 
> We're talking about making sure that loading "ppp.ko" really gets
> ppp.ko rather than some_other_module.ko renamed to ppp.ko via some
> other mechanism.

Right, and the best solution to this problem is to include in the
signature the name of the module.  (One way of doing this is adding
the module name into the cryptographic checksum which is then
digitally signed by the kernel module key; we would have to bump the
version number of the signature format, obviously.)  This binds the
name of the module into the digital signature so that it can't be
renamed.

						- Ted
