Date: Wed, 29 Nov 2017 09:50:14 -0500 (EST)
Message-Id: <20171129.095014.1909386937628805919.davem@davemloft.net>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20171129134612.72ccb53d@alans-desktop>
References: <20171128211659.GP729@wotan.suse.de>
	<CAGXu5j+JaFCo+pZKvet==Kh7GQgNXi30P50SMF4cpOGoUw-8ug@mail.gmail.com>
	<20171129134612.72ccb53d@alans-desktop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 next 1/5] modules:capabilities: add
 request_module_cap()
To: gnomes@lxorguk.ukuu.org.uk
Cc: keescook@chromium.org, mcgrof@kernel.org, tixxdz@gmail.com, luto@kernel.org, akpm@linux-foundation.org, james.l.morris@oracle.com, ben.hutchings@codethink.co.uk, solar@openwall.com, serge@hallyn.com, jeyu@kernel.org, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, corbet@lwn.net, mingo@kernel.org, netdev@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Date: Wed, 29 Nov 2017 13:46:12 +0000

> I really don't care what the module loading rules end up with and
> whether we add CAP_SYS_YET_ANOTHER_MEANINGLESS_FLAG but what is
> actually needed is to properly incorporate it into securiy ruiles
> for whatever LSM you are using.

I'm surprised we're not using the SHA1 hashes or whatever we compute
for the modules to make sure we are loading the foo.ko that we expect
to be.

Then even if someone can rename every file on the system they cannot
force a rogue module to load unless they build one with a proper hash
collision.

Ie. transform module load strings at build time:

	ppp.ko	--> ppp.ko:SHA1

Or something like that.  And the kernel refuses to load a ppp.ko
with a mismatching SHA1.

All of this capability stuff seems to dance a circle around the
problem rather than fix it.
