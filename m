MIME-Version: 1.0
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
In-Reply-To: <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 12 Jun 2019 18:30:03 -0700
Message-ID: <CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Dave Hansen <dave.hansen@intel.com>, Nadav Amit <namit@vmware.com>
Cc: Marius Hillenbrand <mhillenb@amazon.de>, kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 12, 2019 at 1:27 PM Andy Lutomirski <luto@amacapital.net> wrote=
:
>
>
>
> > On Jun 12, 2019, at 12:55 PM, Dave Hansen <dave.hansen@intel.com> wrote=
:
> >
> >> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
> >> This patch series proposes to introduce a region for what we call
> >> process-local memory into the kernel's virtual address space.
> >
> > It might be fun to cc some x86 folks on this series.  They might have
> > some relevant opinions. ;)
> >
> > A few high-level questions:
> >
> > Why go to all this trouble to hide guest state like registers if all th=
e
> > guest data itself is still mapped?
> >
> > Where's the context-switching code?  Did I just miss it?
> >
> > We've discussed having per-cpu page tables where a given PGD is only in
> > use from one CPU at a time.  I *think* this scheme still works in such =
a
> > case, it just adds one more PGD entry that would have to context-switch=
ed.
>
> Fair warning: Linus is on record as absolutely hating this idea. He might=
 change his mind, but it=E2=80=99s an uphill battle.

I looked at the patch, and it (sensibly) has nothing to do with
per-cpu PGDs.  So it's in great shape!

Seriously, though, here are some very high-level review comments:

Please don't call it "process local", since "process" is meaningless.
Call it "mm local" or something like that.

We already have a per-mm kernel mapping: the LDT.  So please nix all
the code that adds a new VA region, etc, except to the extent that
some of it consists of valid cleanups in and of itself.  Instead,
please refactor the LDT code (arch/x86/kernel/ldt.c, mainly) to make
it use a more general "mm local" address range, and then reuse the
same infrastructure for other fancy things.  The code that makes it
KASLR-able should be in its very own patch that applies *after* the
code that makes it all work so that, when the KASLR part causes a
crash, we can bisect it.

+ /*
+ * Faults in process-local memory may be caused by process-local
+ * addresses leaking into other contexts.
+ * tbd: warn and handle gracefully.
+ */
+ if (unlikely(fault_in_process_local(address))) {
+ pr_err("page fault in PROCLOCAL at %lx", address);
+ force_sig_fault(SIGSEGV, SEGV_MAPERR, (void __user *)address, current);
+ }
+

Huh?  Either it's an OOPS or you shouldn't print any special
debugging.  As it is, you're just blatantly leaking the address of the
mm-local range to malicious user programs.

Also, you should IMO consider using this mechanism for kmap_atomic().
Hi, Nadav!
