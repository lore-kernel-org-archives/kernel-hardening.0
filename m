MIME-Version: 1.0
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-6-rick.p.edgecombe@intel.com> <162C6C29-CD81-46FE-9A54-6ED05A93A9CB@gmail.com>
 <00649AE8-69C0-4CD2-A916-B8C8F0F5DAC3@amacapital.net> <6FE10C97-25FF-4E99-A96A-465CBACA935B@gmail.com>
 <CALCETrVaBaorbOA8QE=Pk=C+PfXZAz0-aX_3O8Y=nJV4QKELbw@mail.gmail.com> <3EA322C6-5645-4900-AEC6-97FC05716F75@gmail.com>
In-Reply-To: <3EA322C6-5645-4900-AEC6-97FC05716F75@gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Feb 2019 14:47:39 -0800
Message-ID: <CALCETrXE0n4BrkX2ZLDJjdLqD-N_WwSZHt=S2KKBrTV6Zt5Teg@mail.gmail.com>
Subject: Re: [PATCH v2 05/20] x86/alternative: initializing temporary mm for patching
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 11, 2019 at 11:18 AM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Feb 11, 2019, at 11:07 AM, Andy Lutomirski <luto@kernel.org> wrote:
> >
> > I'm certainly amenable to other solutions, but this one does seem the
> > least messy.  I looked at my old patch, and it doesn't do what you
> > want.  I'd suggest you just add a percpu variable like cpu_dr7 and rig
> > up some accessors so that it stays up to date.  Then you can skip the
> > dr7 writes if there are no watchpoints set.
> >
> > Also, EFI is probably a less interesting example than rare_write.
> > With rare_write, especially the dynamically allocated variants that
> > people keep coming up with, we'll need a swath of address space fully
> > as large as the vmalloc area. and getting *that* right while still
> > using the kernel address range might be more of a mess than we really
> > want to deal with.
>
> As long as you feel comfortable with this solution, I=E2=80=99m fine with=
 it.
>
> Here is what I have (untested). I prefer to save/restore all the DRs,
> because IIRC DR6 indications are updated even if breakpoints are disabled
> (in DR7). And anyhow, that is the standard interface.

Seems reasonable, but:

>
>
> -- >8 --
>
> From: Nadav Amit <namit@vmware.com>
> Date: Mon, 11 Feb 2019 03:07:08 -0800
> Subject: [PATCH] mm: save DRs when loading temporary mm
>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  arch/x86/include/asm/mmu_context.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mm=
u_context.h
> index d684b954f3c0..4f92ec3df149 100644
> --- a/arch/x86/include/asm/mmu_context.h
> +++ b/arch/x86/include/asm/mmu_context.h
> @@ -13,6 +13,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/paravirt.h>
>  #include <asm/mpx.h>
> +#include <asm/debugreg.h>
>
>  extern atomic64_t last_mm_ctx_id;
>
> @@ -358,6 +359,7 @@ static inline unsigned long __get_current_cr3_fast(vo=
id)
>
>  typedef struct {
>         struct mm_struct *prev;
> +       unsigned short bp_enabled : 1;
>  } temp_mm_state_t;
>
>  /*
> @@ -380,6 +382,15 @@ static inline temp_mm_state_t use_temporary_mm(struc=
t mm_struct *mm)
>         lockdep_assert_irqs_disabled();
>         state.prev =3D this_cpu_read(cpu_tlbstate.loaded_mm);
>         switch_mm_irqs_off(NULL, mm, current);
> +
> +       /*
> +        * If breakpoints are enabled, disable them while the temporary m=
m is
> +        * used - they do not belong and might cause wrong signals or cra=
shes.
> +        */

Maybe clarify this?  Add some mention that the specific problem is
that user code could set a watchpoint on an address that is also used
in the temporary mm.

Arguably we should not disable *kernel* breakpoints a la perf, but
that seems like quite a minor issue, at least as long as
use_temporary_mm() doesn't get wider use.  But a comment that this
also disables perf breakpoints and that this could be undesirable
might be in order as well.
