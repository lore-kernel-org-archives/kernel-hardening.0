Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 12 Aug 2011 12:20:24 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110812082024.GA8785@albatros>
References: <20110723162251.GA11485@openwall.com>
 <20110724084200.GB3659@albatros>
 <20110724142710.GB18345@openwall.com>
 <20110725192048.GA21675@albatros>
 <20110811083259.GA5429@albatros>
 <20110812035729.GB4964@openwall.com>
 <20110812042135.GA5149@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812042135.GA5149@openwall.com>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Fri, Aug 12, 2011 at 08:21 +0400, Solar Designer wrote:
[...]
> I think this should be configurable in the 0 to 19 bits range.
[...]

Yes, I agree this is a trade-off and depends on program needs (address
space size) and security threads.

However, some upstream guys don't agree it should be configurable:

https://lkml.org/lkml/2006/5/19/219

https://lkml.org/lkml/2006/5/22/207:

"Because if it is configurable, someone _will_ configure it wrong, and
then ask us why it does not work."

And similar.


Probably it worth trying to bring up the discussion of configurable ASLR
entropy again - the code to configure it is simple anyway.  However, I
expect one nasty answer: "everybody should use x86-64 for good ASLR and
other things, for x86-32 it is bad anyway, so don't bother to fix things
broken by design."


So, to summarize:

For upstream we want to start mmap addresses allocation from 0x1100000,
bottom up.  Probably, make entropy configurable.

For Owl we want to make entropy size configurable.  Depending on the
entropy, use ASCII-armor or fallback to the default allocator
instantly.

Correct?

-- 
Vasiliy
