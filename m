References: <c6603960-c155-8f9f-6458-38e9ba6d4bdd@marcan.st>
 <CALCETrXhUdMNfC0yBah39Z=xWVe3Fix-qF922gJjqzTO1B7TSA@mail.gmail.com>
From: Hector Martin 'marcan' <marcan@marcan.st>
Message-ID: <06a4b0b4-4b36-91b6-d146-9fc1300b785f@marcan.st>
Date: Sat, 11 Nov 2017 01:02:53 +0900
MIME-Version: 1.0
In-Reply-To: <CALCETrXhUdMNfC0yBah39Z=xWVe3Fix-qF922gJjqzTO1B7TSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: vDSO maximum stack usage, stack probes,
 and -fstack-check
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-11-10 23:57, Andy Lutomirski wrote:
> This code is so wrong I don't even no where to start.  Seriously, sub,
> orq, add?  How about just orq with an offset?  How about a *load*
> instead of a store?

Stores should be cheaper than loads (since they don't stall), but
apparently the rationale for using orq is:

gcc/config/i386/i386.md: ;; Use IOR for stack probes, this is shorter.

Saves bytes I guess? Though being read-modify-write it probably hurts
performance; I don't know what real CPUs would do with it.

I suspect the sub, add is there to guarantee that the stack pointer is
actually below the probed location. IIRC the x86-64 ABI specifies a
128-byte redzone that you can freely mess with; going beyond that would
require actually changing the stack pointer.

> But stepping back even further, an offset > 4096 is just bogus.
> That's big enough to skip right over the guard page.

The code (gcc/config/i386/i386.c) says:

  /* We skip the probe for the first interval + a small dope of 4 words
     and probe that many bytes past the specified size to maintain a
     protection area at the botton of the stack.  */

Not entirely sure what's going on here.

OTOH I'm not sure why it's probing at all, since AIUI it only needs to
probe for stack frames >4k to begin with.

> Anyway, my recollection is that GCC's stack check code is busted until
> much newer gcc versions.  I suppose we could try to make the kernel
> fail to build at all on a broken configuration like this.

Well, the original point still stands. Even if what GCC is doing is
stupid here, it's not illegal (it's just eating stack space), and the
kernel still currently makes no guarantees about that. So I think the
conversation regarding vDSO stack usage guarantees is still worth having.

-- 
Hector Martin "marcan" (marcan@marcan.st)
Public Key: https://mrcn.st/pub
