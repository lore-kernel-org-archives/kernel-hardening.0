Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 9 Apr 2013 00:42:49 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <CAGXu5j+fWeinnBr3JLkLt-M4N8uSXzP9MiRF20h37_WABQ1Rrw@mail.gmail.com>
Message-ID: <alpine.LFD.2.03.1304090042220.25182@linux-mips.org>
References: <20130408224328.GA17641@www.outflux.net>        <alpine.LFD.2.03.1304082350540.25182@linux-mips.org> <CAGXu5j+fWeinnBr3JLkLt-M4N8uSXzP9MiRF20h37_WABQ1Rrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] x86: make IDT read-only
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>, Borislav Petkov <borislav.petkov@amd.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Eric Northup <digitaleric@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 8 Apr 2013, Kees Cook wrote:

> >  FWIW the change looks reasonable to me, however given that that it makes
> > the arrangement unconditional and there is no longer a workaround to
> > enable I think it would make sense to remove the conditional block quoted
> > above altogether, along with the f00f_workaround_enabled variable itself
> > (alternatively "Intel Pentium with F0 0F bug" alone could be printed
> > instead and the name of the variable adjusted to make sense with the new
> > meaning -- up to you to decide).
> 
> Actually, I take it back. The other portion of the workaround is still
> active (in mm/fault.c), and this chunk announces it, so I'm going to
> leave it as-is.

 Ah, OK then.  Thanks for double-checking.

  Maciej
