From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Date: Fri, 8 Feb 2019 13:20:09 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net>
In-Reply-To: <20190208130544.GI32511@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "luto@kernel.org" <luto@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "keescook@chromium.org" <keescook@chromium.org>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

> On Fri, Feb 08, 2019 at 02:15:49PM +0200, Elena Reshetova wrote:
> > 1) hackbench -s 4096 -l 2000 -g 15 -f 25 -P
> >     base:           Time: 12.243
> >     random_offset:  Time: 13.411
>=20
> >     base:
> >      8.46%  time     [kernel.kallsyms]  [k] crc32c_pcl_intel_update
> >      4.77%  time     [kernel.kallsyms]  [k] ext4_mark_iloc_dirty
> >      4.14%  time     [kernel.kallsyms]  [k] fsnotify
> >
> >     random_offset:
> >      8.35%  time     [kernel.kallsyms]  [k] crc32c_pcl_intel_update
> >      5.61%  time     [kernel.kallsyms]  [k] get_random_u64
> >      4.88%  time     [kernel.kallsyms]  [k] ext4_mark_iloc_dirty
>=20
> *ouch*
>=20
> >   Notable differences from RANDKSTACK:
>=20
> >   - random bits are taken from get_random_long() instead of
> >     rdtsc() for a better randomness. This however has a big
> >     performance impact (see above the numbers) and additionally
> >     if we happen to hit a point when a generator needs to be
> >     reseeded, we might have an issue. Alternatives can be to
> >     make this feature dependent on CONFIG_RANDOM_TRUST_CPU,
> >     which can solve some issues, but I doubt that all of them.
> >     Of course rdtsc() can be a fallback if there is no way to
> >     make calls for a proper randomness from the trampoline stack.
>=20
> http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html

Oh, this seems to be a great write up, I will read this carefully,
thank you for the pointer!=20

Yes, I believe RANDKSTACK was using rdtsc() exactly because of
many issues get_random_* brings in addition to horrid performance.=20
This patch works with rdtsc() as well just fine, just wanted to show
the *full* randomness option first with the impact it brings.=20

>=20
> That would seem to suggest that the low bits of rdtsc would in fact be a
> fairly good source of random.
>=20
> Still, doing this on sysexit seems painful at best, syscall performance
> matters (and hopefully we'll get rid of meltdown 'soon').

I can measure the impact with rdtsc(), I think it is *very* small.=20
Btw, what should be the good measurement test?
I am not that happy with just looping on fopen-fclose, too
much noise.=20

>=20
> Why can't we change the stack offset periodically from an interrupt or
> so, and then have every later entry use that.

Hm... This sounds more complex conceptually - we cannot touch
stack when it is in use, so we have to periodically probe for a=20
good time (when process is in userspace I guess) to change it from an inter=
rupt?
IMO trampoline stack provides such a good clean place for doing it and we
have stackleak there doing stack cleanup, so would make sense to keep
these features operating together.

Best Regards,
Elena.
