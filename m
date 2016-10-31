Reply-To: kernel-hardening@lists.openwall.com
From: Florian Weimer <fw@deneb.enyo.de>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
	<CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
	<20161031162918.GA2994@pc.thejh.net>
	<87mvhks0vs.fsf@mid.deneb.enyo.de> <1477947388.8761.3.camel@gmail.com>
	<1477947674.8761.4.camel@gmail.com>
Date: Mon, 31 Oct 2016 22:10:41 +0100
In-Reply-To: <1477947674.8761.4.camel@gmail.com> (Daniel Micay's message of
	"Mon, 31 Oct 2016 17:01:14 -0400")
Message-ID: <87ins8rzqm.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary random
To: Daniel Micay <danielmicay@gmail.com>
Cc: Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

* Daniel Micay:

>> It makes a lot of sense on x86_64 where it means the canary is
>> still 56 bits. Also, you want -fstack-check for protecting again
>> stack overflows rather than stack *buffer* overflow. SSP won't
>> really help you in that regard. Sadly, while -fstack-check now
>> works well in GCC 6 with little performance cost, it's not really a

I think GCC still does not treat the return address push on
architectures which have such a CALL instruction as an implicit stack
probe.

>> complete feature (and Clang impls it as a no-op!).

How many guard pages at the end of the stack does the kernel
guarantee?  I saw some -fstack-check-generated code which seemed to
jump over a single guard page.

The other thing I've seen which could impact the effectiveness of
-fstack-check: mmap *without* MAP_FIXED and a hint within stack
allocation can create a mapping inside the stack.  That's rather
surprising, and I'm not sure if the net result is that there actually
is a guard page in all cases.

> Note: talking about userspace after the entropy bit. The kernel doesn't
> really -fstack-check, at least in even slightly sane code...

There used to be lots of discussions about kernel stack sizes ...
