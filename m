Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
 <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <63b1b249-6bc7-ffd9-99db-d36dd3f1a962@intel.com>
Date: Mon, 17 Jun 2019 08:50:35 -0700
MIME-Version: 1.0
In-Reply-To: <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Alexander Graf <graf@amazon.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>
Cc: Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/17/19 12:38 AM, Alexander Graf wrote:
>> Yes I know, but as a benefit we could get rid of all the GSBASE
>> horrors in
>> the entry code as we could just put the percpu space into the local PGD.
> 
> Would that mean that with Meltdown affected CPUs we open speculation
> attacks against the mmlocal memory from KVM user space?

Not necessarily.  There would likely be a _set_ of local PGDs.  We could
still have pair of PTI PGDs just like we do know, they'd just be a local
PGD pair.
