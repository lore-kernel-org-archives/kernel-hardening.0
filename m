MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFw-GgR7DmXsD1dmYWbxuVhg+u0oKwuwNEM4RnuVyA0NDw@mail.gmail.com>
References: <1509945567-11801-1-git-send-email-me@tobin.cc>
 <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
 <CAGXu5j+o6cf0PrnxD+W+09F7UY6JL+h7Bn5_4T2C0Z_fTZAx-w@mail.gmail.com> <CA+55aFw-GgR7DmXsD1dmYWbxuVhg+u0oKwuwNEM4RnuVyA0NDw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 7 Nov 2017 14:08:58 -0800
Message-ID: <CAGXu5jLpCsT2_WimevwbMzJPv5w0YyUkTtqEW32eLCDzBYN3VQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3] scripts: add leaking_addresses.pl
To: Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>, Joe Perches <joe@perches.com>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 7, 2017 at 1:44 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Nov 7, 2017 at 1:22 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> Linus, what do you have in mind for the root-only "yes we really need
>> the actual address output" exceptions?
>
> I am convinced that absolutely none of them should use '%pK'.
>
> So far we have actually never seen a valid case wher %pK was really
> the right thing to do.

One case to keep in mind (likely for the future, once we stabilize
this current plan), is to consider the situation of "untrusted root
users", in the case of locked down systems where modules are disabled,
etc, etc. In those cases, there's a brighter line between kernel
memory and uid 0. (And when we do start looking at that class of info
leaks, we'll be faced with a possible mess from %x-but-root-only
usage.)

>> For example, right now /sys/kernel/debug/kernel_page_tables
>> (CONFIG_X86_PTDUMP=y) needs actual address and currently uses %x.
>
> So I think it could continue to use %x, and just make sure the whole
> file is root-only.

Yup, sounds good.

Looks like the emerging rules for displaying virtual addresses are:

- don't use %p
- especially don't use %p in dmesg
- really, go use %pS/%pF
- if you absolutely need an address, show it with %x and have the file
be root-only

What should the guidance be for physical addresses? They're sensitive
too (especially since they're reachable via the physmap), but we've
traditionally been leaving them in dmesg, etc.

>> Looking other places that stand out, it seems like
>> /proc/lockdep_chains and /proc/lockdep (CONFIG_LOCKDEP=y) has a ton of
>> %p usage. It's unclear to me if a hash is sufficient for meaningful
>> debugging there?
>
> Maybe not, but that is also _so_ esoteric that I suspect the right fix
> is to just make it root-only readable.

Anyone running a "real" system with LOCKDEP is out of their mind. :)

> I've never used it, we should check with people who have. I get the
> feeling that this is purely for PeterZ debugging.
>
> The very first commit that introduced that code actually has a
>
>     (FIXME: should go into debugfs)

Peter, Paul, what do you think about relocating these files?
(/proc/lockdep* into debugfs)

> so I suspect it never should have been user-readable to begin with. I
> guess it makes some things easier, but it really is *very* different
> from things like profiling.

I didn't make that clear in the original report: I was running this as
root just to see what even the root leaks looked like (it was
surprisingly small, IMO). Those files are already root-only.

>> Seems like these three from dmesg could be removed?
>>
>> [    0.000000] Base memory trampoline at [ffffa3fc40099000] 99000 size 24576
>> arch/x86/realmode/init.c
>>
>> [    0.000000] percpu: Embedded 38 pages/cpu @ffffa4007fc00000 s116944
>> r8192 d30512 u524288
>> mm/percpu.c
>>
>> [    0.456395] software IO TLB [mem 0xbbfdf000-0xbffdf000] (64MB)
>> mapped at [ffffa3fcfbfdf000-ffffa3fcfffdefff]
>> lib/swiotlb.c
>
> Yes, I think the solution for a lot of the random device discovery
> messages etc is to just remove them. They were likely useful when the
> code was new and untested, and just stayed around afterwards.

Yup, sounds right. (Though my physical address question from above
remains: should these also drop their physical address reports?)

-Kees

-- 
Kees Cook
Pixel Security
