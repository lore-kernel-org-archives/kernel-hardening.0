Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 7 Jun 2016 09:58:57 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20160607135857.GF7057@thunk.org>
References: <20160531013029.4c5db8b570d86527b0b53fe4@gmail.com>
 <5755CF44.24670.9C7568D@pageexec.freemail.hu>
 <20160606231319.GC7057@thunk.org>
 <5756BBC2.3735.D63200E@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5756BBC2.3735.D63200E@pageexec.freemail.hu>
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/3] Add the latent_entropy gcc
 plugin
To: PaX Team <pageexec@freemail.hu>
Cc: kernel-hardening@lists.openwall.com, David Brown <david.brown@linaro.org>, emese Revfy <re.emese@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com, mingo@redhat.com, tglx@linutronix.de, bart.vanassche@sandisk.com, davem@davemloft.net
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 07, 2016 at 02:19:14PM +0200, PaX Team wrote:
> (i believe that) latent entropy is found in more than just interrupt timing, there're
> also data dependent computations that can have entropy, either on a single system or
> across a population of them.

It's not clear how much data dependent computations you would have in
kernel space that's not introduced by interrupts, but there would
some, I'm sure.

> > we're doing this already inside modern Linux kernels.  On every single
> > interrupt we are mixing into a per-CPU "fast mix" pool the IP from the
> > interrupt registers. 
> 
> i agree that sampling the kernel register state can have entropy (the plugin
> already extracts the current stack pointer) but i'm much less sure about
> userland (at least i see no dependence on !user_mode(...)) since an attacker
> could feed no entropy into the pool but still get it credited.

Well, the attacker can't control when the interrupts happen, but it
could try to burn power by simply having a thread spin in an infinite
loop ("0: jmp 0"), sure.  Of course, this would be rather noticeable,
and if there were any other jobs running, the attacker would be
degrading the amount of entropy that would be gathered, but not
eliminating it.

All of this goes into the question of how much entropy we can assume
can be gathered per interrupt (or in the case of basic block
instrumentation, per basic block).  IIRC, in the latent_entropy
patches, the assumption is that zero entropy should be credited,
correct?

In the case Linux's current get_interrupt_randomness(), there's a
reason I'm using a very conservative 1/64th of a bit per interrupt.
In practice, on most modern CPU where we have a cycle counter, even if
the bad guy was doing a "0: jmp 0" spinning loop, we would still get
entropy via the cycle counter interacting with what is hopefully a
certain amount of entropy from the interrupt timing.

On a crappy $50 Android phone/tablet from China, using an ancient ARM
chip that doesn't have any cycle counting facilities, we're kind of
screwed, but those devices have lousy batteries, so if you have an
attacker that has disabled the wakelocks and is spinning in an
infinite loop, the battery life won't last long, so the problem will
mostly solve itself when the phone dies.  :-)

       	     	    	     	   	  - Ted
