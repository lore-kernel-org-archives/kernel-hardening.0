Date: Wed, 29 Nov 2017 10:58:16 -0500 (EST)
Message-Id: <20171129.105816.1108278026315471171.davem@davemloft.net>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20171129155406.i2lyclquj75lvtn4@thunk.org>
References: <20171129134612.72ccb53d@alans-desktop>
	<20171129.095014.1909386937628805919.davem@davemloft.net>
	<20171129155406.i2lyclquj75lvtn4@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 next 1/5] modules:capabilities: add
 request_module_cap()
To: tytso@mit.edu
Cc: gnomes@lxorguk.ukuu.org.uk, keescook@chromium.org, mcgrof@kernel.org, tixxdz@gmail.com, luto@kernel.org, akpm@linux-foundation.org, james.l.morris@oracle.com, ben.hutchings@codethink.co.uk, solar@openwall.com, serge@hallyn.com, jeyu@kernel.org, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, corbet@lwn.net, mingo@kernel.org, netdev@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Theodore Ts'o <tytso@mit.edu>
Date: Wed, 29 Nov 2017 10:54:06 -0500

> On Wed, Nov 29, 2017 at 09:50:14AM -0500, David Miller wrote:
>> From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
>> Date: Wed, 29 Nov 2017 13:46:12 +0000
>> 
>> > I really don't care what the module loading rules end up with and
>> > whether we add CAP_SYS_YET_ANOTHER_MEANINGLESS_FLAG but what is
>> > actually needed is to properly incorporate it into securiy ruiles
>> > for whatever LSM you are using.
>> 
>> I'm surprised we're not using the SHA1 hashes or whatever we compute
>> for the modules to make sure we are loading the foo.ko that we expect
>> to be.
> 
> We do have signed modules.  But this won't help us if the user is
> using a distro kernel which has compiled some module which is known to
> be unmaintained which everyone in the know *expects* to have 0-day
> bugs, such as DCCP.  That's because the DCCP module is signed.

That's not what we're talking about.

We're talking about making sure that loading "ppp.ko" really gets
ppp.ko rather than some_other_module.ko renamed to ppp.ko via some
other mechanism.

Both modules have legitimate signatures so the kernel will happily
load both.
