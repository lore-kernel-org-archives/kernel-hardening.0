Date: Tue, 7 Feb 2017 18:30:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170207173036.GS6515@twins.programming.kicks-ass.net>
References: <20170205154046.GF6515@twins.programming.kicks-ass.net>
 <CAGXu5jLvpq6B80aN44JCOfHrov5LKX1_9r4aWb7LNM7pAW_SEQ@mail.gmail.com>
 <20170206085739.GH6515@twins.programming.kicks-ass.net>
 <CAGXu5j+VrKBrU7op8wD1Ry4nzR0cN7Vvke8W6_KOzp3wsoEF1g@mail.gmail.com>
 <20170207083405.GV6500@twins.programming.kicks-ass.net>
 <20170207111011.GB28790@leverpostej>
 <20170207123630.GR6515@twins.programming.kicks-ass.net>
 <20170207135020.GA26173@leverpostej>
 <20170207150737.GM25813@worktop.programming.kicks-ass.net>
 <20170207160300.GB26173@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207160300.GB26173@leverpostej>
Subject: Re: [kernel-hardening] Re: [PATCH 4/4] refcount: Report failures
 through CHECK_DATA_CORRUPTION
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 07, 2017 at 04:03:01PM +0000, Mark Rutland wrote:
> For x86 it's a little painful due to '%' in the register names, but it looks
> possible. The below appears to do the mangling correctly (then screams due to
> the mangled result being nonexistent).

> asm(
> "	.macro	reg_to_offset	r\n"
> "	.irp rs,eax,ebx,ecx,edx\n"
> "	.ifc \\r, %\\rs\n"
> "	__offset_of_\\rs\n"
> "	.endif\n"
> "	.endr\n"
> "	.endm\n"
> );
> 
> #define asm_sym(var)		asm volatile("reg_to_offset %0\n" : : "r" (var))

Oh gawd that's a most gnarly hack.

Do we want to go do that for all archs or somehow cook a generic
fallback that ends up doing a full function call or something?
