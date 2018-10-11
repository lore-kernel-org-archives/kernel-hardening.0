Date: Thu, 11 Oct 2018 21:25:04 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
Message-ID: <20181011212504.012c3ece@alans-desktop>
In-Reply-To: <CALCETrW5sNz-TO8w8e+7d1oD_CmnUX_txnBuKe2+wM7qFaK64A@mail.gmail.com>
References: <20181011185458.10186-1-kristen@linux.intel.com>
	<CALCETrW5sNz-TO8w8e+7d1oD_CmnUX_txnBuKe2+wM7qFaK64A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Andy Lutomirski <luto@kernel.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> Ugh.
> 
> What exactly is this trying to protect against?  And how many cycles

Most attacks by speculation rely upon leaving footprints in the L1 cache.
They also almost inevitably resolve non speculatively to errors. If you
look through all the 'yet another potential spectre case' patches people
have found they would have been rendered close to useless by this change.

It's a way to deal with the ones we don't know about, all the ones the
tools won't find and it has pretty much zero cost

(If you are bored strace an entire days desktop session, bang it through
a script or two to extract the number of triggerig error returns and do
the maths...)

> should we expect L1D_FLUSH to take?

More to the point you pretty much never trigger it. Errors are not the
normal path in real code. The original version of this code emptied the
L1 the hard way - and even then it was in the noise for real workloads we
tried.

You can argue that the other thread could be some evil task that
deliberately triggers flushes, but it can already thrash the L1 on
processors that share L1 between threads using perfectly normal memory
instructions.

Alan
