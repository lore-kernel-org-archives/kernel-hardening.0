Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 26 Nov 2015 11:42:29 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20151126104229.GA8530@gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
 <565595F5.32536.DB9FE75@pageexec.freemail.hu>
 <20151126085425.GA29848@gmail.com>
 <5656D779.17137.12A1EA53@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5656D779.17137.12A1EA53@pageexec.freemail.hu>
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only
 memory
To: PaX Team <pageexec@freemail.hu>
Cc: kernel-hardening@lists.openwall.com, Mathias Krause <minipli@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch@vger.kernel.org, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


* PaX Team <pageexec@freemail.hu> wrote:

> On 26 Nov 2015 at 9:54, Ingo Molnar wrote:
> 
> > * PaX Team <pageexec@freemail.hu> wrote:
> > 
> > > actually the kernel could silently recover from this given how the page fault 
> > > handler could easily determine that the fault address fell into the 
> > > data..read_only section and just silently undo the read-only property, log the 
> > > event to dmesg and retry the faulting access.
> > 
> > So a safer method would be to decode the faulting instruction, to skip it by 
> > fixing up the return RIP and to log the event. It would be mostly equivalent 
> > to trying to write to ROM (which get ignored as well), so it's a recoverable 
> > (and debuggable) event.
> 
> if by skipping you mean ignoring the write attempt then it's not a good idea as 
> it has a good chance to cause unexpected behaviour down the line.
> 
> e.g., imagine that the write was to a function pointer (even an entire ops 
> structure) or a boolean that controls some important feature for after-init 
> code. ignoring/dropping such writes could cause all kinds of logic bugs (if not 
> worse).

Well, the typical case is that it's a logic bug to _do_ the write: the structure 
was marked readonly for a reason but some init code re-runs during suspend or so.

But yes, logic bugs might trigger - but that is true in the opposite case as well, 
if we do the write despite it being marked readonly:

> my somewhat related war story is that i once tried to constify machine_ops (both 
> the struct and the variable of the same name) directly and just forced the 
> writes in kvm/xen/etc via type casts. now i knew it was all undefined behaviour 
> but i didn't expect gcc to take advantage of it but it did (const propagated the 
> *initial* fptr values into the indirect calls by turning them into direct calls) 
> and which in turn prevented proper reboots for guests (an event which obviously 
> happens much later after init/boot to the great puzzlement of end users and 
> myself).
> 
> misusing __read_only and ignoring write attempts would effectively produce the 
> same misbehaviour as above so i strongly advise against it.

No, the difference to the GCC related aliasing bug is that with my technique the 
kernel would immediately produce a very visible kernel warning, which is a very 
clear sign that is wrong - and with a very clear backtrace in the warning that 
points right to the problematic code - which signature shows us (and users) what 
is wrong.

So your example is not comparable at all.

Plus the truly paranoid might panic/halt the system on such warnings, so for 
highly secure systems there's a way to not even allow the possibility of logic 
bugs. (at the cost of stopping the system when a bug triggers.)

Thanks,

	Ingo
