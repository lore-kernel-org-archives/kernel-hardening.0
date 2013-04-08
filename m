Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 8 Apr 2013 23:56:29 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <20130408224328.GA17641@www.outflux.net>
Message-ID: <alpine.LFD.2.03.1304082350540.25182@linux-mips.org>
References: <20130408224328.GA17641@www.outflux.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] x86: make IDT read-only
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>, Borislav Petkov <borislav.petkov@amd.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org, kernel-hardening@lists.openwall.com, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Eric Northup <digitaleric@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 8 Apr 2013, Kees Cook wrote:

> This makes the IDT unconditionally read-only. This primarily removes
> the IDT from being a target for arbitrary memory write attacks. It has
> an added benefit of also not leaking (via the "sidt" instruction) the
> kernel base offset, if it has been relocated.
[...]
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -215,7 +201,6 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  
>  		c->f00f_bug = 1;
>  		if (!f00f_workaround_enabled) {
> -			trap_init_f00f_bug();
>  			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
>  			f00f_workaround_enabled = 1;
>  		}

 FWIW the change looks reasonable to me, however given that that it makes 
the arrangement unconditional and there is no longer a workaround to 
enable I think it would make sense to remove the conditional block quoted 
above altogether, along with the f00f_workaround_enabled variable itself 
(alternatively "Intel Pentium with F0 0F bug" alone could be printed 
instead and the name of the variable adjusted to make sense with the new 
meaning -- up to you to decide).

  Maciej
