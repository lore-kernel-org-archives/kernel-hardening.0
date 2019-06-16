MIME-Version: 1.0
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net> <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 16 Jun 2019 15:18:00 -0700
Message-ID: <CALCETrWZ4qUW+A+YqE36ZJHqJAzxwDgq77bL99BEKQx-=JYAtA@mail.gmail.com>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@intel.com>, Marius Hillenbrand <mhillenb@amazon.de>, kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 14, 2019 at 7:21 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Wed, 12 Jun 2019, Andy Lutomirski wrote:
> > > On Jun 12, 2019, at 12:55 PM, Dave Hansen <dave.hansen@intel.com> wro=
te:
> > >
> > >> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
> > >> This patch series proposes to introduce a region for what we call
> > >> process-local memory into the kernel's virtual address space.
> > >
> > > It might be fun to cc some x86 folks on this series.  They might have
> > > some relevant opinions. ;)
> > >
> > > A few high-level questions:
> > >
> > > Why go to all this trouble to hide guest state like registers if all =
the
> > > guest data itself is still mapped?
> > >
> > > Where's the context-switching code?  Did I just miss it?
> > >
> > > We've discussed having per-cpu page tables where a given PGD is only =
in
> > > use from one CPU at a time.  I *think* this scheme still works in suc=
h a
> > > case, it just adds one more PGD entry that would have to context-swit=
ched.
> >
> > Fair warning: Linus is on record as absolutely hating this idea. He mig=
ht
> > change his mind, but it=E2=80=99s an uphill battle.
>
> Yes I know, but as a benefit we could get rid of all the GSBASE horrors i=
n
> the entry code as we could just put the percpu space into the local PGD.
>

I have personally suggested this to Linus on a couple of occasions,
and he seemed quite skeptical.
