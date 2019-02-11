Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH v2 05/20] x86/alternative: initializing temporary mm for
 patching
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <00649AE8-69C0-4CD2-A916-B8C8F0F5DAC3@amacapital.net>
Date: Mon, 11 Feb 2019 10:04:59 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <6FE10C97-25FF-4E99-A96A-465CBACA935B@gmail.com>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-6-rick.p.edgecombe@intel.com>
 <162C6C29-CD81-46FE-9A54-6ED05A93A9CB@gmail.com>
 <00649AE8-69C0-4CD2-A916-B8C8F0F5DAC3@amacapital.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

> On Feb 10, 2019, at 9:18 PM, Andy Lutomirski <luto@amacapital.net> =
wrote:
>=20
>=20
>=20
> On Feb 10, 2019, at 4:39 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>>> On Jan 28, 2019, at 4:34 PM, Rick Edgecombe =
<rick.p.edgecombe@intel.com> wrote:
>>>=20
>>> From: Nadav Amit <namit@vmware.com>
>>>=20
>>> To prevent improper use of the PTEs that are used for text patching, =
we
>>> want to use a temporary mm struct. We initailize it by copying the =
init
>>> mm.
>>>=20
>>> The address that will be used for patching is taken from the lower =
area
>>> that is usually used for the task memory. Doing so prevents the need =
to
>>> frequently synchronize the temporary-mm (e.g., when BPF programs are
>>> installed), since different PGDs are used for the task memory.
>>>=20
>>> Finally, we randomize the address of the PTEs to harden against =
exploits
>>> that use these PTEs.
>>>=20
>>> Cc: Kees Cook <keescook@chromium.org>
>>> Cc: Dave Hansen <dave.hansen@intel.com>
>>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>>> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
>>> Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
>>> Suggested-by: Andy Lutomirski <luto@kernel.org>
>>> Signed-off-by: Nadav Amit <namit@vmware.com>
>>> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>>> ---
>>> arch/x86/include/asm/pgtable.h       |  3 +++
>>> arch/x86/include/asm/text-patching.h |  2 ++
>>> arch/x86/kernel/alternative.c        |  3 +++
>>> arch/x86/mm/init_64.c                | 36 =
++++++++++++++++++++++++++++
>>> init/main.c                          |  3 +++
>>> 5 files changed, 47 insertions(+)
>>>=20
>>> diff --git a/arch/x86/include/asm/pgtable.h =
b/arch/x86/include/asm/pgtable.h
>>> index 40616e805292..e8f630d9a2ed 100644
>>> --- a/arch/x86/include/asm/pgtable.h
>>> +++ b/arch/x86/include/asm/pgtable.h
>>> @@ -1021,6 +1021,9 @@ static inline void __meminit =
init_trampoline_default(void)
>>>   /* Default trampoline pgd value */
>>>   trampoline_pgd_entry =3D init_top_pgt[pgd_index(__PAGE_OFFSET)];
>>> }
>>> +
>>> +void __init poking_init(void);
>>> +
>>> # ifdef CONFIG_RANDOMIZE_MEMORY
>>> void __meminit init_trampoline(void);
>>> # else
>>> diff --git a/arch/x86/include/asm/text-patching.h =
b/arch/x86/include/asm/text-patching.h
>>> index f8fc8e86cf01..a75eed841eed 100644
>>> --- a/arch/x86/include/asm/text-patching.h
>>> +++ b/arch/x86/include/asm/text-patching.h
>>> @@ -39,5 +39,7 @@ extern void *text_poke_kgdb(void *addr, const void =
*opcode, size_t len);
>>> extern int poke_int3_handler(struct pt_regs *regs);
>>> extern void *text_poke_bp(void *addr, const void *opcode, size_t =
len, void *handler);
>>> extern int after_bootmem;
>>> +extern __ro_after_init struct mm_struct *poking_mm;
>>> +extern __ro_after_init unsigned long poking_addr;
>>>=20
>>> #endif /* _ASM_X86_TEXT_PATCHING_H */
>>> diff --git a/arch/x86/kernel/alternative.c =
b/arch/x86/kernel/alternative.c
>>> index 12fddbc8c55b..ae05fbb50171 100644
>>> --- a/arch/x86/kernel/alternative.c
>>> +++ b/arch/x86/kernel/alternative.c
>>> @@ -678,6 +678,9 @@ void *__init_or_module text_poke_early(void =
*addr, const void *opcode,
>>>   return addr;
>>> }
>>>=20
>>> +__ro_after_init struct mm_struct *poking_mm;
>>> +__ro_after_init unsigned long poking_addr;
>>> +
>>> static void *__text_poke(void *addr, const void *opcode, size_t len)
>>> {
>>>   unsigned long flags;
>>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>>> index bccff68e3267..125c8c48aa24 100644
>>> --- a/arch/x86/mm/init_64.c
>>> +++ b/arch/x86/mm/init_64.c
>>> @@ -53,6 +53,7 @@
>>> #include <asm/init.h>
>>> #include <asm/uv/uv.h>
>>> #include <asm/setup.h>
>>> +#include <asm/text-patching.h>
>>>=20
>>> #include "mm_internal.h"
>>>=20
>>> @@ -1383,6 +1384,41 @@ unsigned long memory_block_size_bytes(void)
>>>   return memory_block_size_probed;
>>> }
>>>=20
>>> +/*
>>> + * Initialize an mm_struct to be used during poking and a pointer =
to be used
>>> + * during patching.
>>> + */
>>> +void __init poking_init(void)
>>> +{
>>> +    spinlock_t *ptl;
>>> +    pte_t *ptep;
>>> +
>>> +    poking_mm =3D copy_init_mm();
>>> +    BUG_ON(!poking_mm);
>>> +
>>> +    /*
>>> +     * Randomize the poking address, but make sure that the =
following page
>>> +     * will be mapped at the same PMD. We need 2 pages, so find =
space for 3,
>>> +     * and adjust the address if the PMD ends after the first one.
>>> +     */
>>> +    poking_addr =3D TASK_UNMAPPED_BASE;
>>> +    if (IS_ENABLED(CONFIG_RANDOMIZE_BASE))
>>> +        poking_addr +=3D (kaslr_get_random_long("Poking") & =
PAGE_MASK) %
>>> +            (TASK_SIZE - TASK_UNMAPPED_BASE - 3 * PAGE_SIZE);
>>> +
>>> +    if (((poking_addr + PAGE_SIZE) & ~PMD_MASK) =3D=3D 0)
>>> +        poking_addr +=3D PAGE_SIZE;
>>=20
>> Further thinking about it, I think that allocating the virtual =
address for
>> poking from user address-range is problematic. The user can set =
watchpoints
>> on different addresses, cause some static-keys to be =
enabled/disabled, and
>> monitor the signals to derandomize the poking address.
>=20
> Hmm, I hadn=E2=80=99t thought about watchpoints. I=E2=80=99m not sure =
how much we care
> about possible derandomization like this, but we certainly don=E2=80=99t=
 want to
> send signals or otherwise malfunction.
>=20
>> Andy, I think you were pushing this change. Can I go back to use a =
vmalloc=E2=80=99d
>> address instead, or do you have a better solution?
>=20
> Hmm. If we use a vmalloc address, we have to make sure it=E2=80=99s =
not actually
> allocated. I suppose we could allocate one once at boot and use that. =
We
> also have the problem that the usual APIs for handling =E2=80=9Cuser=E2=80=
=9D addresses
> might assume they=E2=80=99re actually in the user range, although this =
seems
> unlikely to be a problem in practice. More seriously, though, the code
> that manipulates per-mm paging structures assumes that *all* of the
> structures up to the top level are per-mm, and, if we use anything =
less
> than a private pgd, this isn=E2=80=99t the case.

I forgot that I only had this conversation in my mind ;-)

Well, I did write some code that kept some vmalloc=E2=80=99d area =
private, and it
did require more synchronization between the pgd=E2=80=99s. It is still =
possible
to use another top-level PGD, but =E2=80=A6 (continued below)

>=20
>> I prefer not to
>> save/restore DR7, of course.
>=20
> I suspect we may want to use the temporary mm concept for EFI, too, so =
we
> may want to just suck it up and save/restore DR7. But only if a =
watchpoint
> is in use, of course. I have an old patch I could dust off that tracks =
DR7
> to make things like this efficient.

=E2=80=A6 but, if this is the case, then I will just make =
(un)use_temporary_mm() to
save/restore DR7. I guess you are ok with such a solution. I will
incorporate it into Rick=E2=80=99s v3.
