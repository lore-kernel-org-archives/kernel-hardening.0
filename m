Date: Thu, 31 Jan 2019 20:57:01 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH v6 14/27] x86/percpu: Adapt percpu for PIE support
In-Reply-To: <20190131192533.34130-15-thgarnie@chromium.org>
Message-ID: <01000168a5b35a86-b79bfe67-191e-43bc-a5c7-0e74eac06195-000000@email.amazonses.com>
References: <20190131192533.34130-1-thgarnie@chromium.org> <20190131192533.34130-15-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Cao jin <caoj.fnst@cn.fujitsu.com>, Brijesh Singh <brijesh.singh@amd.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Joerg Roedel <jroedel@suse.de>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 31 Jan 2019, Thomas Garnier wrote:

> Perpcu uses a clever design where the .percu ELF section has a virtual
> address of zero and the custom linux relocation code avoid relocating
> specific symbols. It makes the code simple and easily adaptable with or
> without SMP support.

We usually talk about this as offsets rather than addressess. The intend
here is to give every processor its own address that is unique for this
processor. Operations are always relative to a segment register and the
whole area can be relocated at will by simply changing the segment
register.

> This design is incompatible with PIE. While creating a PIE binary, the
> copmiler tries to make everything relative. The compiler will attempt to

This is very compatible with PIE because it is already relative.

> generate instructions with the distance between zero and any 64-bit
> virtual address. It will fail as the relocation range cannot fit within
> the possible instructions accessing a segment register.

Leave the offsets alone and just change the segment register if you need
to relocate the area of a specific processor?

> The assembly and PER_CPU macros are changed to use relative references
> when PIE is enabled.

They already use relative reference. What is the point here?

> --- a/arch/x86/include/asm/percpu.h
> +++ b/arch/x86/include/asm/percpu.h
> @@ -5,9 +5,11 @@
>  #ifdef CONFIG_X86_64
>  #define __percpu_seg		gs
>  #define __percpu_mov_op		movq
> +#define __percpu_rel		(%rip)

The percpu section cannot be IP relative since we need to have separate
address spaces per cpu.
