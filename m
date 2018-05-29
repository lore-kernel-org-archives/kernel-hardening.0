MIME-Version: 1.0
References: <20180529221625.33541-1-thgarnie@google.com> <20180529221625.33541-15-thgarnie@google.com>
 <01000163ae145cac-5ac07b51-8f08-4da5-bb93-0238d59756d3-000000@email.amazonses.com>
In-Reply-To: <01000163ae145cac-5ac07b51-8f08-4da5-bb93-0238d59756d3-000000@email.amazonses.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 29 May 2018 16:08:24 -0700
Message-ID: <CAJcbSZF_MUpG37e7rt67pfNOT+m3ed2L+jRgvQ2Enb0wVLdOcg@mail.gmail.com>
Subject: Re: [PATCH v4 14/27] x86/percpu: Adapt percpu for PIE support
Content-Type: text/plain; charset="UTF-8"
To: Christoph Lameter <cl@linux.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Dave Hansen <dave.hansen@linux.intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Skip Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Skip Frederic Weisbecker <frederic@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@suse.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, Francis Deslauriers <francis.deslauriers@efficios.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 29, 2018 at 3:46 PM Christopher Lameter <cl@linux.com> wrote:

> On Tue, 29 May 2018, Thomas Garnier wrote:

> > Perpcu uses a clever design where the .percu ELF section has a virtual
> > address of zero and the relocation code avoid relocating specific
> > symbols. It makes the code simple and easily adaptable with or without
> > SMP support.
> >
> > This design is incompatible with PIE because generated code always try
to
> > access the zero virtual address relative to the default mapping address.

> We always access relative to the "segment register".

> You can already change the segment register to relocate the per cpu
> sections arbitrarily since all per cpu "addresses" are offsets relative to
> the segment register. I am not sure what exactly you are trying to
> accomplish here?

When building with PIE, the compiler wants the code to be relocatable
anywhere in the 64-bit VA space. Instead of taking the segment register as
an immediate value, it takes it as VA that need to be relocated relative to
where the kernel is mapped. The per-cpu section VA is zero to create the
proper offset to the different variable. The kernel could be at the top of
the 64-bit VA space. PIE will try to create the delta between any VA and
zero and fail because segment register based operations do not have full
64-bit VA range. Does it make sense?

For PIE only, this change will remove the per-cpu section VA of zero. Now
the distance between the per-cpu symbol and the kernel base VA can fit in
the generated instructions.


> Maybe you need to explain it better?

I will try do explain it better on the next patch set.




-- 
Thomas
