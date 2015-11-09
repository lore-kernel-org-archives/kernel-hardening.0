Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Tue, 10 Nov 2015 00:09:29 +0100
MIME-Version: 1.0
Message-ID: <564127A9.17122.2B0E8CF3@pageexec.freemail.hu>
In-reply-to: <CAGXu5jJpBD0=KeTztesOO2Smp+wSEnTpjvUjYWtgU_nF+TAL-Q@mail.gmail.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>, <563F4A78.21151.23C6852D@pageexec.freemail.hu>, <CAGXu5jJpBD0=KeTztesOO2Smp+wSEnTpjvUjYWtgU_nF+TAL-Q@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 9 Nov 2015 at 13:52, Kees Cook wrote:

> On Sun, Nov 8, 2015 at 5:13 AM, PaX Team <pageexec@freemail.hu> wrote:
> > as a general note, some gcc (and eventually clang/llvm) folks could
> > perhaps be involved in kernel/plugin related discussions. this would
> > not only help heal some of the rift that developed over the years
> 
> Do you have some people in mind from gcc? I'd love to get them on CC,
> but it's not a community I know very well (yet).

sorry, i have no idea which gcc developer would be interested in such
a cross-field cooperation, probably it's worth a shot on their list ;).

> >   - some static objects of the ops type are written to at runtime,
> >     typically once during initialization. handling this case is
> >     somewhat messy in the current plugin, it's either done via forcibly
> >     overriding the constness of the object or by using the no_const
> >     attribute and placing the object into a section that will be part
> >     of read-only kernel data after init (in either case open/close
> >     calls are needed). i have plans to move to the latter approach
> >     exclusively but that requires rewriting the core of the plugin
> >     to not rely on existing gcc infrastructure to detect const violations.
> 
> It sounds like we have 3 kinds of (non-heap) const targets:
> 1) those actually never written to (trivial)
> 2) those written to during init only (should be easy?)
> 3) those written to after init (hard)

yes, that roughly describes the situation. we've been doing work on
all three categories with the first one handled trivially from the
compiler (equivalent to patching in 'const' at the source level).

the other two require more finesse however so as to not 'cheat' too
much (a.k.a. inducing undefined behaviour) as that could result in
incorrect optimization decisions later. e.g., i once forcibly constified
an ops object that was being copied to during init (instead of setting
a ptr to the chosen object) and then the compiler would figure that
all the indirect calls through that object could be optimized into
direct calls since, well, the object was const. so tricking the compiler
has to be done carefully (and the current PaX code for these cases
may not always be the best example you want to follow ;).

> IIUC, mark_data_ro() is called after init finishes, shouldn't it be
> possible to mark those in some way (if they're not already?)

i mentioned two ways to handle this above, the best is not forced
constification but to simply place the object into a special section
that will be linked together with .rodata (in PaX it's called
".data..read_only"). this also works for the third case but then
you'll lose the compiler's already existing mechanism to warn/error
out on writes to const objects so this requires reimplementing that
logic in the plugin (that's the rewrite i alluded to above).

> For case 3, upstream would need KERNEXEC. 

you only need a way to temporarily make it possible to modify otherwise
read-only memory, much like how UDEREF (SMAP) needs temporary permissions
to access userland. the naive approach is simple enough (similar to how
the memory holding module code is made read-only on load then writable
again on unload) but doing it securely (not subject to races) and fast
enough (not having to flush TLB entries) is another matter, that will
require some (arch dependent) infrastructure first.
