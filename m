MIME-Version: 1.0
References: <20181011185458.10186-1-kristen@linux.intel.com>
 <CALCETrW5sNz-TO8w8e+7d1oD_CmnUX_txnBuKe2+wM7qFaK64A@mail.gmail.com> <20181011212504.012c3ece@alans-desktop>
In-Reply-To: <20181011212504.012c3ece@alans-desktop>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 11 Oct 2018 13:47:49 -0700
Message-ID: <CALCETrW29qzigJY99GSFg4EVabbh6VnUmfPvtwO+BtPKfKWj-Q@mail.gmail.com>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
Content-Type: text/plain; charset="UTF-8"
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andrew Lutomirski <luto@kernel.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 11, 2018 at 1:25 PM Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
>
> > Ugh.
> >
> > What exactly is this trying to protect against?  And how many cycles
>
> Most attacks by speculation rely upon leaving footprints in the L1 cache.
> They also almost inevitably resolve non speculatively to errors. If you
> look through all the 'yet another potential spectre case' patches people
> have found they would have been rendered close to useless by this change.

Can you give an example?  AFAIK the interesting Meltdown-like attacks
are unaffected because Meltdown doesn't actually need the target data
to be in L1D.  And most of the Spectre-style attacks would have been
blocked by doing LFENCE on the error cases (and somehow making sure
that the CPU doesn't speculate around the LFENCE without noticing it).
But this patch is doing an L1D flush, which, as far as I've heard,
isn't actually relevant.

>
> It's a way to deal with the ones we don't know about, all the ones theion
> tools won't find and it has pretty much zero cost
>
> (If you are bored strace an entire days desktop session, bang it through
> a script or two to extract the number of triggerig error returns and do
> the maths...)
>
> > should we expect L1D_FLUSH to take?
>
> More to the point you pretty much never trigger it. Errors are not the
> normal path in real code. The original version of this code emptied the
> L1 the hard way - and even then it was in the noise for real workloads we
> tried.
>
> You can argue that the other thread could be some evil task that
> deliberately triggers flushes, but it can already thrash the L1 on
> processors that share L1 between threads using perfectly normal memory
> instructions.
>

That's not what I meant.  I meant that, if an attacker can run code on
*both* logical threads on the same CPU, then they can run their attack
code on the other logical thread before the L1D_FLUSH command takes
effect.

I care about the performance of single-threaded workloads, though.
How slow is this thing?  No one cares about syscall performance on
regular desktop sessions except for gaming.   But people do care about
syscall performance on all kinds of crazy server, database, etc
workloads.  And compilation.  And HPC stuff, although that mostly
doesn't involve syscalls.  So: benchmarks, please.  And estimated
cycle counts, please, on at least a couple of relevant CPU
generations.

On Meltdown-affected CPUs, we're doing a CR3 write anyway, which is
fully serializing, so it's slow.  But AFAIK that *already* blocks most
of these attacks except L1TF, and L1TF has (hopefully!) been fixed
anyway on Linux.
