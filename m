MIME-Version: 1.0
References: <20181128000754.18056-1-rick.p.edgecombe@intel.com>
 <20181128000754.18056-2-rick.p.edgecombe@intel.com> <4883FED1-D0EC-41B0-A90F-1A697756D41D@gmail.com>
In-Reply-To: <4883FED1-D0EC-41B0-A90F-1A697756D41D@gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 4 Dec 2018 10:56:03 -0800
Message-ID: <CALCETrXvddt148fncMJqpjK98uatiK-44knYFWU0-ytf8X+iog@mail.gmail.com>
Subject: Re: [PATCH 1/2] vmalloc: New flag for flush before releasing pages
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, Will Deacon <will.deacon@arm.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, jeyu@kernel.org, Network Development <netdev@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 3, 2018 at 5:43 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Nov 27, 2018, at 4:07 PM, Rick Edgecombe <rick.p.edgecombe@intel.com=
> wrote:
> >
> > Since vfree will lazily flush the TLB, but not lazily free the underlyi=
ng pages,
> > it often leaves stale TLB entries to freed pages that could get re-used=
. This is
> > undesirable for cases where the memory being freed has special permissi=
ons such
> > as executable.
>
> So I am trying to finish my patch-set for preventing transient W+X mappin=
gs
> from taking space, by handling kprobes & ftrace that I missed (thanks aga=
in for
> pointing it out).
>
> But all of the sudden, I don=E2=80=99t understand why we have the problem=
 that this
> (your) patch-set deals with at all. We already change the mappings to mak=
e
> the memory writable before freeing the memory, so why can=E2=80=99t we ma=
ke it
> non-executable at the same time? Actually, why do we make the module memo=
ry,
> including its data executable before freeing it???
>

All the code you're looking at is IMO a very awkward and possibly
incorrect of doing what's actually necessary: putting the direct map
the way it wants to be.

Can't we shove this entirely mess into vunmap?  Have a flag (as part
of vmalloc like in Rick's patch or as a flag passed to a vfree variant
directly) that makes the vunmap code that frees the underlying pages
also reset their permissions?

Right now, we muck with set_memory_rw() and set_memory_nx(), which
both have very awkward (and inconsistent with each other!) semantics
when called on vmalloc memory.  And they have their own flushes, which
is inefficient.  Maybe the right solution is for vunmap to remove the
vmap area PTEs, call into a function like set_memory_rw() that resets
the direct maps to their default permissions *without* flushing, and
then to do a single flush for everything.  Or, even better, to cause
the change_page_attr code to do the flush and also to flush the vmap
area all at once so that very small free operations can flush single
pages instead of flushing globally.
