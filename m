Date: Thu, 07 Mar 2019 08:43:50 -0800
In-Reply-To: <20190307151036.GD26566@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com> <20190129003422.9328-11-rick.p.edgecombe@intel.com> <20190211182956.GN19618@zn.tnic> <1533F2BB-2284-499B-9912-6D74D0B87BC1@gmail.com> <20190211190108.GP19618@zn.tnic> <A671F14F-3E03-4A97-9F54-426533077E0C@gmail.com> <20190211191059.GR19618@zn.tnic> <3996E3F9-92D2-4561-84E9-68B43AC60F43@gmail.com> <20190211194251.GS19618@zn.tnic> <A55214F3-CDC0-44C4-AFB6-7E8E23CC6F85@gmail.com> <20190307151036.GD26566@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] x86/cpufeature: Remove __pure attribute to _static_cpu_has()
From: hpa@zytor.com
Message-ID: <D683E00D-845E-4970-80DE-AD1DED3AE609@zytor.com>
To: Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On March 7, 2019 7:10:36 AM PST, Borislav Petkov <bp@alien8=2Ede> wrote:
>On Mon, Feb 11, 2019 at 12:32:41PM -0800, Nadav Amit wrote:
>> BTW: the =E2=80=9C__pure=E2=80=9D attribute is useless when =E2=80=9C__=
always_inline=E2=80=9D is
>used=2E
>> Unless it is intended to be some sort of comment, of course=2E
>
>---
>From: Borislav Petkov <bp@suse=2Ede>
>Date: Thu, 7 Mar 2019 15:54:51 +0100
>
>__pure is used to make gcc do Common Subexpression Elimination (CSE)
>and thus save subsequent invocations of a function which does a complex
>computation (without side effects)=2E As a simple example:
>
>  bool a =3D _static_cpu_has(x);
>  bool b =3D _static_cpu_has(x);
>
>gets turned into
>
>  bool a =3D _static_cpu_has(x);
>  bool b =3D a;
>
>However, gcc doesn't do CSE with asm()s when those get inlined - like
>it
>is done with _static_cpu_has() - because, for example, the t_yes/t_no
>labels are different for each inlined function body and thus cannot be
>detected as equivalent anymore for the CSE heuristic to hit=2E
>
>However, this all is beside the point because best it should be avoided
>to have more than one call to _static_cpu_has(X) in the same function
>due to the fact that each such call is an alternatives patch site and
>it
>is simply pointless=2E
>
>Therefore, drop the __pure attribute as it is not doing anything=2E
>
>Reported-by: Nadav Amit <nadav=2Eamit@gmail=2Ecom>
>Signed-off-by: Borislav Petkov <bp@suse=2Ede>
>Cc: Peter Zijlstra <peterz@infradead=2Eorg>
>Cc: x86@kernel=2Eorg
>---
> arch/x86/include/asm/cpufeature=2Eh | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/x86/include/asm/cpufeature=2Eh
>b/arch/x86/include/asm/cpufeature=2Eh
>index e25d11ad7a88=2E=2E6d6d5cc4302b 100644
>--- a/arch/x86/include/asm/cpufeature=2Eh
>+++ b/arch/x86/include/asm/cpufeature=2Eh
>@@ -162,7 +162,7 @@ extern void clear_cpu_cap(struct cpuinfo_x86 *c,
>unsigned int bit);
>* majority of cases and you should stick to using it as it is generally
>  * only two instructions: a RIP-relative MOV and a TEST=2E
>  */
>-static __always_inline __pure bool _static_cpu_has(u16 bit)
>+static __always_inline bool _static_cpu_has(u16 bit)
> {
> 	asm_volatile_goto("1: jmp 6f\n"
> 		 "2:\n"

Uhm=2E=2E=2E (a) it is correct, even if the compiler doesn't use it now, i=
t allows the compiler to CSE it in the future; (b) it is documentation; (c)=
 there is an actual bug here: the "volatile" implies a side effect, which i=
n reality is not present, inhibiting CSE=2E

So the correct fix is to remove "volatile", not remove "__pure"=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
