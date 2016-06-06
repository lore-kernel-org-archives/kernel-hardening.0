Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 6 Jun 2016 19:13:19 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20160606231319.GC7057@thunk.org>
References: <20160531013029.4c5db8b570d86527b0b53fe4@gmail.com>
 <20160603194252.91064b8e682ad988283fc569@gmail.com>
 <20160606133801.GA6136@davidb.org>
 <5755CF44.24670.9C7568D@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5755CF44.24670.9C7568D@pageexec.freemail.hu>
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/3] Add the latent_entropy gcc
 plugin
To: PaX Team <pageexec@freemail.hu>
Cc: kernel-hardening@lists.openwall.com, David Brown <david.brown@linaro.org>, emese Revfy <re.emese@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com, mingo@redhat.com, tglx@linutronix.de, bart.vanassche@sandisk.com, davem@davemloft.net
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 06, 2016 at 09:30:12PM +0200, PaX Team wrote:
> 
> what matters for latent entropy is not the actual values fed into the entropy
> pool (they're effectively compile time constants save for runtime data dependent
> computations) but the precise sequence of them. interrupts stir this sequence
> and thus extract entropy. perhaps as a small example imagine that an uninterrupted
> kernel boot sequence feeds these values into the entropy pool:
>   A B C
> 
> now imagine that a single interrupt can occur around any one of these values:
>   I A B C
>   A I B C
>   A B I C
>   A B C I
> 
> this way we can obtain 4 different final pool states that translate into up
> to 2 bits of latent entropy (depends on how probable each sequence is). note
> that this works regardless whether the underlying hardware has a high resolution
> timer whose values the interrupt handler would feed into the pool.

Right, but if it's only about interrupts, we're doing this already
inside modern Linux kernels.  On every single interrupt we are mixing
into a per-CPU "fast mix" pool the IP from the interrupt registers.

Since we're not claiming any additional entropy, I suppose it won't
hurt to do it twice, two different ways, but I'm not sure how much it
will actually help, and by doing the instrumentation in every single
basic block, instead of in the interrupt handler, I would think it
would be cheaper to do it in the interrupt handler.

      	 	       	     - Ted
