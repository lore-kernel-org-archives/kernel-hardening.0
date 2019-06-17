MIME-Version: 1.0
References: <20190612170834.14855-1-mhillenb@amazon.de> <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net> <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com> <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
In-Reply-To: <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 17 Jun 2019 08:54:36 -0700
Message-ID: <CALCETrXph3Zg907kWTn6gAsZVsPbCB3A2XuNf0hy5Ez2jm2aNQ@mail.gmail.com>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM secrets
Content-Type: text/plain; charset="UTF-8"
To: Dave Hansen <dave.hansen@intel.com>
Cc: Alexander Graf <graf@amazon.com>, Thomas Gleixner <tglx@linutronix.de>, Marius Hillenbrand <mhillenb@amazon.de>, kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 17, 2019 at 8:50 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 6/17/19 12:38 AM, Alexander Graf wrote:
> >> Yes I know, but as a benefit we could get rid of all the GSBASE
> >> horrors in
> >> the entry code as we could just put the percpu space into the local PGD.
> >
> > Would that mean that with Meltdown affected CPUs we open speculation
> > attacks against the mmlocal memory from KVM user space?
>
> Not necessarily.  There would likely be a _set_ of local PGDs.  We could
> still have pair of PTI PGDs just like we do know, they'd just be a local
> PGD pair.
>

Unfortunately, this would mean that we need to sync twice as many
top-level entries when we context switch.
