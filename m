Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com>
 <459e2273-bc27-f422-601b-2d6cdaf06f84@amazon.com>
 <CALCETrVRuQb-P7auHCgxzs5L=qA2_qHzVGTtRMAqoMAut0ETFw@mail.gmail.com>
 <f1dfbfb4-d2d5-bf30-600f-9e756a352860@intel.com>
 <70BEF143-00BA-4E4B-ACD7-41AD2E6250BE@vmware.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <f7f08704-dc4b-c5f8-3889-0fb5957c9c86@intel.com>
Date: Thu, 13 Jun 2019 10:49:42 -0700
MIME-Version: 1.0
In-Reply-To: <70BEF143-00BA-4E4B-ACD7-41AD2E6250BE@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Nadav Amit <namit@vmware.com>, Andy Lutomirski <luto@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Marius Hillenbrand <mhillenb@amazon.de>, kvm list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/13/19 10:29 AM, Nadav Amit wrote:
> Having said that, I am not too excited to deal with this issue. Do
> people still care about x86/32-bit?
No, not really.  It's just fun to try to give history lessons about the
good old days. ;)
