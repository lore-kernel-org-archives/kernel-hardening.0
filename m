Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1448492749.22705.1.camel@ellerman.id.au>
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Thu, 26 Nov 2015 10:05:49 +1100
In-Reply-To: <CAGXu5jKAeKDxpWMgZpvB-aHNdAqDEVtHOiDz3joC+bZns6FBJQ@mail.gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
	 <1448401114-24650-2-git-send-email-keescook@chromium.org>
	 <CALCETrXNe5Ow0cxLACzVpx3HdR_b_XCB3_VUtsAphVjCQpRZwA@mail.gmail.com>
	 <CAGXu5jKe5hZtrUJ7SJ2WTcJvKXftgkAkPjxmvoVjewbC3Kqg9Q@mail.gmail.com>
	 <1448412883.3762.1.camel@ellerman.id.au>
	 <CAGXu5jKAeKDxpWMgZpvB-aHNdAqDEVtHOiDz3joC+bZns6FBJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] x86: introduce post-init
 read-only memory
To: kernel-hardening@lists.openwall.com
Cc: Andy Lutomirski <luto@amacapital.net>, linux-arch <linux-arch@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2015-11-25 at 07:03 -0800, Kees Cook wrote:
> On Tue, Nov 24, 2015 at 4:54 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> > On Tue, 2015-11-24 at 16:44 -0800, Kees Cook wrote:
> > > On Tue, Nov 24, 2015 at 4:34 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > > > On Nov 24, 2015 1:38 PM, "Kees Cook" <keescook@chromium.org> wrote:
> > > > > 
> > > > > One of the easiest ways to protect the kernel from attack is to reduce
> > > > > the internal attack surface exposed when a "write" flaw is available. By
> > > > > making as much of the kernel read-only as possible, we reduce the
> > > > > attack surface.
> > > > > 
> > > > > Many things are written to only during __init, and never changed
> > > > > again. These cannot be made "const" since the compiler will do the wrong
> > > > > thing (we do actually need to write to them). Instead, move these items
> > > > > into a memory region that will be made read-only during mark_rodata_ro()
> > > > > which happens after all kernel __init code has finished.
> > > > > 
> > > > > This introduces __read_only as a way to mark such memory, and adds some
> > > > > documentation about the existing __read_mostly marking.
> > > > 
> > > > Obligatory bikeshed:  __ro_after_init, please.  It's barely longer,
> > > > and it directly explains what's going on.  __read_only makes me think
> > > > that it's really read-only and could, for example, actually be in ROM.
> > > 
> > > I'm fine with that. Anyone else want to chime in before I send a v2?
> > 
> > I'm not clear on why this is x86 only?
> 
> I was initially looking at how __read_mostly got implemented, and it
> seemed like section names were done on a per-arch basis. But it
> doesn't seem like that needs to be true.

Yeah I saw that too, but I couldn't see anything in the commit history that
explained why it was per-arch.

> > It looks like it would work on any arch, or is there some toolchain
> > requirement?
> 
> Given that the other sections are in the common linux.lds.h file, it
> seems unlikely to me. I'll try it in an arch-agnostic way and see what
> happens. :)

That'd be great, I can test on powerpc, and build test other arches too.

cheers
