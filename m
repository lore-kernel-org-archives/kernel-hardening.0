Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com>
 <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
 <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <698ca264-123d-46ae-c165-ed62ea149896@intel.com>
Date: Mon, 17 Jun 2019 09:03:39 -0700
MIME-Version: 1.0
In-Reply-To: <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Andy Lutomirski <luto@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Thomas Gleixner <tglx@linutronix.de>, Marius Hillenbrand <mhillenb@amazon.de>, kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/17/19 8:54 AM, Andy Lutomirski wrote:
>>> Would that mean that with Meltdown affected CPUs we open speculation
>>> attacks against the mmlocal memory from KVM user space?
>> Not necessarily.  There would likely be a _set_ of local PGDs.  We could
>> still have pair of PTI PGDs just like we do know, they'd just be a local
>> PGD pair.
>>
> Unfortunately, this would mean that we need to sync twice as many
> top-level entries when we context switch.

Yeah, PTI sucks. :)

For anyone following along at home, I'm going to go off into crazy
per-cpu-pgds speculation mode now...  Feel free to stop reading now. :)

But, I was thinking we could get away with not doing this on _every_
context switch at least.  For instance, couldn't 'struct tlb_context'
have PGD pointer (or two with PTI) in addition to the TLB info?  That
way we only do the copying when we change the context.  Or does that tie
the implementation up too much with PCIDs?
