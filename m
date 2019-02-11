Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH v2 10/20] x86: avoid W^X being broken during modules
 loading
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190211182956.GN19618@zn.tnic>
Date: Mon, 11 Feb 2019 10:45:26 -0800
Content-Transfer-Encoding: 7bit
Message-Id: <1533F2BB-2284-499B-9912-6D74D0B87BC1@gmail.com>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-11-rick.p.edgecombe@intel.com>
 <20190211182956.GN19618@zn.tnic>
To: Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> On Feb 11, 2019, at 10:29 AM, Borislav Petkov <bp@alien8.de> wrote:
> 
>> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
>> index 76d482a2b716..69f3e650ada8 100644
>> --- a/arch/x86/kernel/alternative.c
>> +++ b/arch/x86/kernel/alternative.c
>> @@ -667,15 +667,29 @@ void __init alternative_instructions(void)
>>  * handlers seeing an inconsistent instruction while you patch.
>>  */
>> void *__init_or_module text_poke_early(void *addr, const void *opcode,
>> -					      size_t len)
>> +				       size_t len)
>> {
>> 	unsigned long flags;
>> -	local_irq_save(flags);
>> -	memcpy(addr, opcode, len);
>> -	local_irq_restore(flags);
>> -	sync_core();
>> -	/* Could also do a CLFLUSH here to speed up CPU recovery; but
>> -	   that causes hangs on some VIA CPUs. */
>> +
>> +	if (static_cpu_has(X86_FEATURE_NX) &&
> 
> Not a fast path - boot_cpu_has() is fine here.

Are you sure about that? This path is still used when modules are loaded.
