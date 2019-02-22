From: Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH v3 03/20] x86/mm: Save DRs when loading a temporary mm
Date: Fri, 22 Feb 2019 00:17:24 +0000
Message-ID: <A8727670-F848-4BAD-BEFE-9C94329EA774@vmware.com>
References: <20190221234451.17632-1-rick.p.edgecombe@intel.com>
 <20190221234451.17632-4-rick.p.edgecombe@intel.com>
 <20190222000731.GE7224@linux.intel.com>
In-Reply-To: <20190222000731.GE7224@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D769DF7E6D82BE459723C84B195B28F4@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "deneen.t.dock@intel.com" <deneen.t.dock@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

> On Feb 21, 2019, at 4:07 PM, Sean Christopherson <sean.j.christopherson@i=
ntel.com> wrote:
>=20
> On Thu, Feb 21, 2019 at 03:44:34PM -0800, Rick Edgecombe wrote:
>> From: Nadav Amit <namit@vmware.com>
>>=20
>> Prevent user watchpoints from mistakenly firing while the temporary mm
>> is being used. As the addresses that of the temporary mm might overlap
>> those of the user-process, this is necessary to prevent wrong signals
>> or worse things from happening.
>>=20
>> Cc: Andy Lutomirski <luto@kernel.org>
>> Signed-off-by: Nadav Amit <namit@vmware.com>
>> ---
>> arch/x86/include/asm/mmu_context.h | 25 +++++++++++++++++++++++++
>> 1 file changed, 25 insertions(+)
>>=20
>> diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/m=
mu_context.h
>> index d684b954f3c0..0d6c72ece750 100644
>> --- a/arch/x86/include/asm/mmu_context.h
>> +++ b/arch/x86/include/asm/mmu_context.h
>> @@ -13,6 +13,7 @@
>> #include <asm/tlbflush.h>
>> #include <asm/paravirt.h>
>> #include <asm/mpx.h>
>> +#include <asm/debugreg.h>
>>=20
>> extern atomic64_t last_mm_ctx_id;
>>=20
>> @@ -358,6 +359,7 @@ static inline unsigned long __get_current_cr3_fast(v=
oid)
>>=20
>> typedef struct {
>> 	struct mm_struct *prev;
>> +	unsigned short bp_enabled : 1;
>> } temp_mm_state_t;
>>=20
>> /*
>> @@ -380,6 +382,22 @@ static inline temp_mm_state_t use_temporary_mm(stru=
ct mm_struct *mm)
>> 	lockdep_assert_irqs_disabled();
>> 	state.prev =3D this_cpu_read(cpu_tlbstate.loaded_mm);
>> 	switch_mm_irqs_off(NULL, mm, current);
>> +
>> +	/*
>> +	 * If breakpoints are enabled, disable them while the temporary mm is
>> +	 * used. Userspace might set up watchpoints on addresses that are used
>> +	 * in the temporary mm, which would lead to wrong signals being sent o=
r
>> +	 * crashes.
>> +	 *
>> +	 * Note that breakpoints are not disabled selectively, which also caus=
es
>> +	 * kernel breakpoints (e.g., perf's) to be disabled. This might be
>> +	 * undesirable, but still seems reasonable as the code that runs in th=
e
>> +	 * temporary mm should be short.
>> +	 */
>> +	state.bp_enabled =3D hw_breakpoint_active();
>=20
> Pretty sure caching hw_breakpoint_active() is unnecessary.  It queries a
> per-cpu value, not hardware's DR7 register, and that same value is
> consumed by hw_breakpoint_restore().  No idea if breakpoints can be
> disabled while using a temp mm, but even if that can happen, there's no
> need to restore breakpoints if they've all been disabled, i.e. if
> hw_breakpoint_active() returns false in unuse_temporary_mm().

Good point. I will fix it for next version.

Thanks,
Nadav
