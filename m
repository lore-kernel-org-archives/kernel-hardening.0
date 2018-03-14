Date: Wed, 14 Mar 2018 10:54:58 -0500 (CDT)
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH v2 06/27] x86/entry/64: Adapt assembly for PIE support
In-Reply-To: <20180314102951.GQ4043@hirez.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.20.1803141051210.14471@nuc-kabylake>
References: <20180313205945.245105-1-thgarnie@google.com> <20180313205945.245105-7-thgarnie@google.com> <20180314102951.GQ4043@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Garnier <thgarnie@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Philippe Ombredanne <pombredanne@nexb.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Ashish Kalra <ashish@bluestacks.com>, Kyle McMartin <kyle@redhat.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Lukas Wunner <lukas@wunner.de>, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ingo Molnar <mingo@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Jiri Slaby <jslaby@suse.cz>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, =?ISO-8859-15?Q?Jan_H_=2E_Sch=F6nherr?= <jschoenh@amazon.de>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On Wed, 14 Mar 2018, Peter Zijlstra wrote:

> On Tue, Mar 13, 2018 at 01:59:24PM -0700, Thomas Garnier wrote:
> > @@ -1576,7 +1578,9 @@ first_nmi:
> >  	addq	$8, (%rsp)	/* Fix up RSP */
> >  	pushfq			/* RFLAGS */
> >  	pushq	$__KERNEL_CS	/* CS */
> > -	pushq	$1f		/* RIP */
> > +	pushq	%rax		/* Support Position Independent Code */
> > +	leaq	1f(%rip), %rax	/* RIP */
> > +	xchgq	%rax, (%rsp)	/* Restore RAX, put 1f */
> >  	iretq			/* continues at repeat_nmi below */
> >  	UNWIND_HINT_IRET_REGS
> >  1:
>
> Urgh, xchg with a memop has an implicit LOCK prefix.

this_cpu_xchg uses no lock cmpxchg as a replacement to reduce latency.

>From linux/arch/x86/include/asm/percpu.h

/*
 * xchg is implemented using cmpxchg without a lock prefix. xchg is
 * expensive due to the implied lock prefix.  The processor cannot prefetch
 * cachelines if xchg is used.
 */
#define percpu_xchg_op(var, nval)                                       \
({                                                                      \
        typeof(var) pxo_ret__;                                          \
        typeof(var) pxo_new__ = (nval);                                 \
        switch (sizeof(var)) {                                          \
        case 1:                                                         \
                asm("\n\tmov "__percpu_arg(1)",%%al"                    \
                    "\n1:\tcmpxchgb %2, "__percpu_arg(1)                \
                    "\n\tjnz 1b"                                        \
                            : "=&a" (pxo_ret__), "+m" (var)             \
                            : "q" (pxo_new__)                           \
                            : "memory");                                \
                break;                                                  \
        case 2:                                                         \
                asm("\n\tmov "__percpu_arg(1)",%%ax"                    \
                    "\n1:\tcmpxchgw %2, "__percpu_arg(1)                \
                    "\n\tjnz 1b"                                        \
                            : "=&a" (pxo_ret__), "+m" (var)             \
                            : "r" (pxo_new__)                           \
                            : "memory");                                \
                break;                                                  \
        case 4:                                                         \
                asm("\n\tmov "__percpu_arg(1)",%%eax"                   \
                    "\n1:\tcmpxchgl %2, "__percpu_arg(1)                \
                    "\n\tjnz 1b"                                        \
                            : "=&a" (pxo_ret__), "+m" (var)             \
                            : "r" (pxo_new__)                           \
                            : "memory");                                \
                break;                                                  \
        case 8:                                                         \
                asm("\n\tmov "__percpu_arg(1)",%%rax"                   \
                    "\n1:\tcmpxchgq %2, "__percpu_arg(1)                \
                    "\n\tjnz 1b"                                        \
                            : "=&a" (pxo_ret__), "+m" (var)             \
                            : "r" (pxo_new__)                           \
                            : "memory");                                \
                break;                                                  \
        default: __bad_percpu_size();                                   \
        }                                                               \
        pxo_ret__;                                                      \
