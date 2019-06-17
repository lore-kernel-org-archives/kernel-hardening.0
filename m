Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com>
 <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
 <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com>
 <698ca264-123d-46ae-c165-ed62ea149896@intel.com>
 <CALCETrVt=X+FB2cM5hMN9okvbcROFfT4_KMwaKaN2YVvc7UQTw@mail.gmail.com>
 <5AA8BF10-8987-4FCB-870C-667A5228D97B@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <f6f352ed-750e-d735-a1c9-7ff133ca8aea@intel.com>
Date: Mon, 17 Jun 2019 11:07:45 -0700
MIME-Version: 1.0
In-Reply-To: <5AA8BF10-8987-4FCB-870C-667A5228D97B@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Nadav Amit <nadav.amit@gmail.com>, Andy Lutomirski <luto@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Thomas Gleixner <tglx@linutronix.de>, Marius Hillenbrand <mhillenb@amazon.de>, kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/17/19 9:53 AM, Nadav Amit wrote:
>>> For anyone following along at home, I'm going to go off into crazy
>>> per-cpu-pgds speculation mode now...  Feel free to stop reading now. :)
>>>
>>> But, I was thinking we could get away with not doing this on _every_
>>> context switch at least.  For instance, couldn't 'struct tlb_context'
>>> have PGD pointer (or two with PTI) in addition to the TLB info?  That
>>> way we only do the copying when we change the context.  Or does that tie
>>> the implementation up too much with PCIDs?
>> Hmm, that seems entirely reasonable.  I think the nasty bit would be
>> figuring out all the interactions with PV TLB flushing.  PV TLB
>> flushes already don't play so well with PCID tracking, and this will
>> make it worse.  We probably need to rewrite all that code regardless.
> How is PCID (as you implemented) related to TLB flushing of kernel (not
> user) PTEs? These kernel PTEs would be global, so they would be invalidated
> from all the address-spaces using INVLPG, I presume. No?

The idea is that you have a per-cpu address space.  Certain kernel
virtual addresses would map to different physical address based on where
you are running.  Each of the physical addresses would be "owned" by a
single CPU and would, by convention, never use a PGD that mapped an
address unless that CPU that "owned" it.

In that case, you never really invalidate those addresses.
