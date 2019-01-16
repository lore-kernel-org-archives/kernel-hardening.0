Date: Wed, 16 Jan 2019 10:59:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v1 01/06]: Extending objtool for PIC modules
In-Reply-To: <CAGXu5jK1UgWQkzs0dm9qeJhfHA5rCfAqKdwv7CPnS5hDApTAdg@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1901161031250.1655@nanos.tec.linutronix.de>
References: <a562f9f5-79c1-8a10-8c1e-91fec7ee6614@yahoo.com> <CAGXu5jK1UgWQkzs0dm9qeJhfHA5rCfAqKdwv7CPnS5hDApTAdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: Ruslan Nikolaev <nruslan_devel@yahoo.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Garnier <thgarnie@google.com>, X86 ML <x86@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 15 Jan 2019, Kees Cook wrote:

> On Tue, Jan 15, 2019 at 10:56 AM Ruslan Nikolaev
> <nruslan_devel@yahoo.com> wrote:
> >
> > Extending objtool for PIC modules
> >
> > The patch is by Hassan Nadeem and Ruslan Nikolaev. This extends
> > the prior PIE kernel patch (by Thomas Garnier) to also support
> > position-independent modules that can be placed anywhere in the
> > 48/64-bit address space (for better KASLR).
> >
> > Signed-off-by: Ruslan Nikolaev <nruslan_devel@yahoo.com>
> 
> Thanks for working on this!
> 
> In the next version, you probably want to add the "Co-developed-by:"
> and "Signed-off-by:" tags from Hassan Nadeem, as appropriate. Also,
> I'd CC Josh Poimboeuf <jpoimboe@redhat.com> too, since he will likely
> have comments on these improvements. :)

Aside of that, please add a cover letter and ensure that the patches
contain a In-Reply-To header referencing the cover letter.

Thanks,

	tglx
