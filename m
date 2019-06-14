Date: Fri, 14 Jun 2019 16:21:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
In-Reply-To: <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
Message-ID: <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com> <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1104140577-1560522104=:1722"
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Hansen <dave.hansen@intel.com>, Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1104140577-1560522104=:1722
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 12 Jun 2019, Andy Lutomirski wrote:
> > On Jun 12, 2019, at 12:55 PM, Dave Hansen <dave.hansen@intel.com> wrote:
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
> > Why go to all this trouble to hide guest state like registers if all the
> > guest data itself is still mapped?
> > 
> > Where's the context-switching code?  Did I just miss it?
> > 
> > We've discussed having per-cpu page tables where a given PGD is only in
> > use from one CPU at a time.  I *think* this scheme still works in such a
> > case, it just adds one more PGD entry that would have to context-switched.
>
> Fair warning: Linus is on record as absolutely hating this idea. He might
> change his mind, but it’s an uphill battle.

Yes I know, but as a benefit we could get rid of all the GSBASE horrors in
the entry code as we could just put the percpu space into the local PGD.

Thanks,

	tglx
--8323329-1104140577-1560522104=:1722--
