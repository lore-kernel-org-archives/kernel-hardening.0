Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <3cd533c1-3f18-a84f-fbb2-264751ed3eeb@intel.com>
Date: Wed, 12 Jun 2019 13:41:50 -0700
MIME-Version: 1.0
In-Reply-To: <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Andy Lutomirski <luto@amacapital.net>
Cc: Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/12/19 1:27 PM, Andy Lutomirski wrote:
>> We've discussed having per-cpu page tables where a given PGD is
>> only in use from one CPU at a time.  I *think* this scheme still
>> works in such a case, it just adds one more PGD entry that would
>> have to context-switched.
> Fair warning: Linus is on record as absolutely hating this idea. He
> might change his mind, but it’s an uphill battle.

Just to be clear, are you referring to the per-cpu PGDs, or to this
patch set with a per-mm kernel area?
