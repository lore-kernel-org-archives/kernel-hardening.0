Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH 08/17] x86/ftrace: set trampoline pages as executable
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190206112213.2ec9dd5c@gandalf.local.home>
Date: Wed, 6 Feb 2019 09:33:35 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <5DFA1E3C-A335-4C4B-A86F-904A6CF6D871@gmail.com>
References: <20190117003259.23141-1-rick.p.edgecombe@intel.com>
 <20190117003259.23141-9-rick.p.edgecombe@intel.com>
 <20190206112213.2ec9dd5c@gandalf.local.home>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, deneen.t.dock@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

> On Feb 6, 2019, at 8:22 AM, Steven Rostedt <rostedt@goodmis.org> =
wrote:
>=20
> On Wed, 16 Jan 2019 16:32:50 -0800
> Rick Edgecombe <rick.p.edgecombe@intel.com> wrote:
>=20
>> From: Nadav Amit <namit@vmware.com>
>>=20
>> Since alloc_module() will not set the pages as executable soon, we =
need
>> to do so for ftrace trampoline pages after they are allocated.
>>=20
>> For the time being, we do not change ftrace to use the text_poke()
>> interface. As a result, ftrace breaks still breaks W^X.
>>=20
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Signed-off-by: Nadav Amit <namit@vmware.com>
>> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> ---
>> arch/x86/kernel/ftrace.c | 9 +++++++++
>> 1 file changed, 9 insertions(+)
>>=20
>> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
>> index 8257a59704ae..eb4a1937e72c 100644
>> --- a/arch/x86/kernel/ftrace.c
>> +++ b/arch/x86/kernel/ftrace.c
>> @@ -742,6 +742,7 @@ create_trampoline(struct ftrace_ops *ops, =
unsigned int *tramp_size)
>> 	unsigned long end_offset;
>> 	unsigned long op_offset;
>> 	unsigned long offset;
>> +	unsigned long npages;
>> 	unsigned long size;
>> 	unsigned long retq;
>> 	unsigned long *ptr;
>> @@ -774,6 +775,7 @@ create_trampoline(struct ftrace_ops *ops, =
unsigned int *tramp_size)
>> 		return 0;
>>=20
>> 	*tramp_size =3D size + RET_SIZE + sizeof(void *);
>> +	npages =3D DIV_ROUND_UP(*tramp_size, PAGE_SIZE);
>>=20
>> 	/* Copy ftrace_caller onto the trampoline memory */
>> 	ret =3D probe_kernel_read(trampoline, (void *)start_offset, =
size);
>> @@ -818,6 +820,13 @@ create_trampoline(struct ftrace_ops *ops, =
unsigned int *tramp_size)
>> 	/* ALLOC_TRAMP flags lets us know we created it */
>> 	ops->flags |=3D FTRACE_OPS_FL_ALLOC_TRAMP;
>>=20
>> +	/*
>> +	 * Module allocation needs to be completed by making the page
>> +	 * executable. The page is still writable, which is a security =
hazard,
>> +	 * but anyhow ftrace breaks W^X completely.
>> +	 */
>=20
> Perhaps we should set the page to non writable after the page is
> updated? And set it to writable only when we need to update it.

You remember that I sent you a patch that changed all these writes into
text_poke() and you said that I should defer it until this series is =
merged?

> As for this patch:
>=20
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Thanks!
