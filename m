Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 31 Aug 2016 11:08:48 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160831100848.GB4783@leverpostej>
References: <alpine.DEB.2.10.1608272058090.3363@hadrien>
 <1472325098.26978.14.camel@perches.com>
 <alpine.DEB.2.10.1608281509480.3321@hadrien>
 <CAGXu5jKZrHEZqyby-Gjrx=wjjCPw-kmkYBcW--+J5Y3w5QwNbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKZrHEZqyby-Gjrx=wjjCPw-kmkYBcW--+J5Y3w5QwNbg@mail.gmail.com>
Subject: [kernel-hardening] Re: constification and cocci / kernel build test robot ?
To: Kees Cook <keescook@chromium.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>, Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Glenn Wurster <gwurster@blackberry.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 30, 2016 at 02:50:36PM -0400, Kees Cook wrote:
> The structures that should get the greatest level of attention are
> those that contain function pointers. The "constify" gcc plugin from
> PaX/Grsecurity does this, but it uses a big hammer: it moves all of
> them const even if they receive assignment. To handle this, there is
> the concept of an open/close method to gain temporary access to the
> structure. For example:
> 
> drivers/cdrom/cdrom.c:
> 
> int register_cdrom(...) {
>         ...
>         if (!cdo->generic_packet) {
>                 pax_open_kernel();
>                 const_cast(cdo->generic_packet) = cdrom_dummy_generic_packet;
>                 pax_close_kernel();
>         }
> 
> (The "const_cast" here is just a macro to convince gcc it's only to
> write to a const value, so really it should maybe be called
> "unconst_cast", but whatever...)

Just to check, are they actually marked as const, or some pseudo-const
like __ro_after_init?

I can imagine a number of issues with casting a real const away (e.g. if
the compiler decides to cache the value in a register and decides since
it is const it need not hazard with a memory clobber).

> This allows all of struct cdrom_device_ops to be const, even if they
> need to be updated once during registration.
> 
> (This is a stronger version of __ro_after_init, which is for things
> that are only written during __init.)
> 
> AUIU, the goals of the open/close_kernel idea are:
> - always inline
> - make sure the CPU cannot be interrupted

I guess s/be interrupted/take an exception/, to cover stuff like debug
breakpoints and such.

That might not always be possible, and might not strictly be a
requirement, if you can guarantee that taking an exception will cause
the mapping to become non-writeable during the handler.

That's one approach I plan to look into for arm64, assuming that we
create a temporarily RW alias in TTBR0.

> - BUG if memory is already writable
> - make the memory writable only by the current CPU
> - update the value
> - restore memory permissions
> - allow CPU interruption again
> 
> This makes sure there aren't races with other CPUs to write things,
> and that it's harder to use for an attack since with the "make
> writable" code is always followed by a "make read-only" action (i.e.
> not separate functions that could be used as a trivial ROP gadget).

FWIW, on that front we may want to look into reworking the fixmap code.
For at least arm, arm64, microblaze, and powerpc, __set_fixmap is a C
function that might offer a trivial ROP gadget for creating a RW
mapping.

Other architectures have that as a static inline in a header, which
ensures that it's folded into callers, making it less trivial to reuse.

Thanks,
Mark.
