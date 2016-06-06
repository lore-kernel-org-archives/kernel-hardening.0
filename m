Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Mon, 06 Jun 2016 21:30:12 +0200
MIME-Version: 1.0
Message-ID: <5755CF44.24670.9C7568D@pageexec.freemail.hu>
In-reply-to: <20160606133801.GA6136@davidb.org>
References: <20160531013029.4c5db8b570d86527b0b53fe4@gmail.com>, <20160603194252.91064b8e682ad988283fc569@gmail.com>, <20160606133801.GA6136@davidb.org>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/3] Add the latent_entropy gcc plugin
To: kernel-hardening@lists.openwall.com, David Brown <david.brown@linaro.org>, emese Revfy <re.emese@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, tytso@mit.edu, linux-mm@kvack.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com, mingo@redhat.com, tglx@linutronix.de, bart.vanassche@sandisk.com, davem@davemloft.net
List-ID: <kernel-hardening.lists.openwall.com>

On 6 Jun 2016 at 7:38, David Brown wrote:

> On Fri, Jun 03, 2016 at 07:42:52PM +0200, Emese Revfy wrote:
> >On Wed, 1 Jun 2016 12:42:27 -0700
> >Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >> I don't think I'm really understanding.  Won't this produce the same
> >> value on each and every boot?
> >
> >No, because of interrupts and intentional data races.
> 
> Wouldn't that result in the value having one of a small number of
> values, then?  Even if it was just one of thousands or millions of
> values, it would make the search space quite small.

what matters for latent entropy is not the actual values fed into the entropy
pool (they're effectively compile time constants save for runtime data dependent
computations) but the precise sequence of them. interrupts stir this sequence
and thus extract entropy. perhaps as a small example imagine that an uninterrupted
kernel boot sequence feeds these values into the entropy pool:
  A B C

now imagine that a single interrupt can occur around any one of these values:
  I A B C
  A I B C
  A B I C
  A B C I

this way we can obtain 4 different final pool states that translate into up
to 2 bits of latent entropy (depends on how probable each sequence is). note
that this works regardless whether the underlying hardware has a high resolution
timer whose values the interrupt handler would feed into the pool.

the kernel boot process executes many of the above sequences with each sequence
potentially having a different length (the number of __init functions and initcalls
depends on the kernel config, initcalls execute for different lengths of time,
interrupt windows have different lengths, etc). how all this translates into
something measurable is a good question as i said elsewhere in the thread, my
completely unscientific guess would be that the number of interrupts is somehow
proportional to the extracted latent entropy.

cheers,
 PaX Team
