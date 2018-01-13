MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 13 Jan 2018 11:05:54 -0800
Message-ID: <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jan 13, 2018 at 10:18 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
> index c97d935a29e8..85f400b8ee7c 100644
> --- a/arch/x86/lib/getuser.S
> +++ b/arch/x86/lib/getuser.S
> @@ -41,6 +41,7 @@ ENTRY(__get_user_1)
>         cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
>         jae bad_get_user
>         ASM_STAC
> +       ASM_IFENCE
>  1:     movzbl (%_ASM_AX),%edx
>         xor %eax,%eax
>         ASM_CLAC

So I really would like to know from somebody (preferably somebody with
real microarchitectural knowledge) just how expensive that "lfence"
ends up being.

Because since we could just generate the masking of the address from
the exact same condition code that we already generate, the "lfence"
really can be replaced by just two ALU instructions instead:

   diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
   index c97d935a29e8..4c378b485399 100644
   --- a/arch/x86/lib/getuser.S
   +++ b/arch/x86/lib/getuser.S
   @@ -40,6 +40,8 @@ ENTRY(__get_user_1)
           mov PER_CPU_VAR(current_task), %_ASM_DX
           cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
           jae bad_get_user
   +       sbb %_ASM_DX,%_ASM_DX
   +       and %_ASM_DX,%_ASM_AX
           ASM_STAC
    1:     movzbl (%_ASM_AX),%edx
           xor %eax,%eax

which looks like it should have a fairly low maximum overhead (ok, the
above is totally untested, maybe I got the condition the wrong way
around _again_).

I _know_ that lfence is expensive as hell on P4, for example.

Yes, yes, "sbb" is often more expensive than most ALU instructions,
and Agner Fog says it has a 10-cycle latency on Prescott (which is
outrageous, but being one or two cycles more due to the flags
generation is normal). So the sbb/and may certainly add a few cycles
to the critical path, but on Prescott "lfence" is *50* cycles
according to those same tables by Agner Fog.

Is there anybody who is willing to say one way or another wrt the
"sbb/and" sequence vs "lfence".

                       Linus
