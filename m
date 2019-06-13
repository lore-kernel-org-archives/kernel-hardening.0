Date: Thu, 13 Jun 2019 13:05:35 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
Message-ID: <20190613200535.GC18385@linux.intel.com>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com>
 <459e2273-bc27-f422-601b-2d6cdaf06f84@amazon.com>
 <CALCETrVRuQb-P7auHCgxzs5L=qA2_qHzVGTtRMAqoMAut0ETFw@mail.gmail.com>
 <f1dfbfb4-d2d5-bf30-600f-9e756a352860@intel.com>
 <70BEF143-00BA-4E4B-ACD7-41AD2E6250BE@vmware.com>
 <f7f08704-dc4b-c5f8-3889-0fb5957c9c86@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7f08704-dc4b-c5f8-3889-0fb5957c9c86@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Nadav Amit <namit@vmware.com>, Andy Lutomirski <luto@kernel.org>, Alexander Graf <graf@amazon.com>, Marius Hillenbrand <mhillenb@amazon.de>, kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 13, 2019 at 10:49:42AM -0700, Dave Hansen wrote:
> On 6/13/19 10:29 AM, Nadav Amit wrote:
> > Having said that, I am not too excited to deal with this issue. Do
> > people still care about x86/32-bit?
> No, not really.

Especially not for KVM, given the number of times 32-bit KVM has been
broken recently without anyone noticing for several kernel releases.
