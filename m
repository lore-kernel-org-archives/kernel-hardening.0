MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170301104337.GA28874@leverpostej>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-2-git-send-email-keescook@chromium.org>
 <1488270174.1747.11.camel@gmail.com> <CAGXu5jKvY1VRxBk_F9omixEBhaSTE18tfRWNcPUKhFk303v6iw@mail.gmail.com>
 <20170301104337.GA28874@leverpostej>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 1 Mar 2017 12:13:57 -0800
Message-ID: <CAGXu5jKTunStRbQ0FpuZpE5bXkmbv0wPmHYqJB2HNxnOzUTvXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH 1/8] Introduce rare_write() infrastructure
To: Mark Rutland <mark.rutland@arm.com>
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 1, 2017 at 2:43 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> On Tue, Feb 28, 2017 at 07:05:32AM -0800, Kees Cook wrote:
>> On Tue, Feb 28, 2017 at 12:22 AM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
>> > On Mon, 2017-02-27 at 12:42 -0800, Kees Cook wrote:
>
>> >> +/*
>> >> + * Build "write rarely" infrastructure for flipping memory r/w
>> >> + * on a per-CPU basis.
>> >> + */
>> >> +#ifndef CONFIG_HAVE_ARCH_RARE_WRITE
>> >> +# define __wr_rare
>> >> +# define __wr_rare_type
>> >> +# define __rare_write_type(v)        typeof(v)
>> >> +# define __rare_write_ptr(v) (&(v))
>> >> +# define __rare_write(__var, __val)  ({              \
>> >> +     __var = __val;                                  \
>> >> +     __var;                                          \
>> >> +})
>> >> +# define rare_write_enable() do { } while (0)
>> >> +# define rare_write_disable()        do { } while (0)
>> >> +#else
>> >> +# define __wr_rare           __ro_after_init
>> >> +# define __wr_rare_type              const
>> >> +# define __rare_write_type(v)        typeof((typeof(v))0)
>> >> +# define __rare_write_ptr(v) ((__rare_write_type(v) *)&(v))
>> >
>> > Should we make __rare_write_ptr arch-specific so architectures can
>> > convert the pointer to rw alias from ro address like this ? [1]
>> >
>> > #ifndef __arch_rare_write_ptr
>> > # define __rare_write_ptr(v)    ((__rare_write_type(v) *)&(v))
>> > #else
>> > # define __rate_write_ptr(v)    __arch_rare_write_ptr
>> > #endif
>>
>> I think that was Mark's idea too, but I'm not sure to handle the
>> complex cases of doing multiple updates at once (e.g. linked list
>> updates, etc).
>
> Assuming there aren't that many places with complex updates, we could
> allow code to explicitly do the map/unmap and use __rare_write_ptr
> directly. That does mean that the list code has to be specialised for
> __wr_rare, which is less than ideal.

Here's some sed output: http://paste.ubuntu.com/24092015/

grsecurity currently has 314 instances of using
pax_open/close_kernel(). The number of lines of code between them is
about half a single line, but there is a lot of variation on how it's
used:

count  lines-of-code
    164 1
     72 2
     21 3
     20 4
      2 5
      8 6
      3 7
      2 8
      1 9
     18 10+

The obvious helpers are in the list code (for double, rcu, and single
lists), with most header file uses are operating on page tables.

The list code is already specialized (see the rare_list_add()/del()
function), and could be made even more explicit if needed.

> That would also depend on what is __rw_rare in those cases, too.  i.e.
> is it just the list_head for the list itself, the list_head of all
> elements, or only some of them?

lib/list_debug.c:EXPORT_SYMBOL(__pax_list_add);
lib/list_debug.c:EXPORT_SYMBOL(pax_list_del);
lib/list_debug.c:EXPORT_SYMBOL(pax_list_del_init);
lib/list_debug.c:EXPORT_SYMBOL(__pax_list_add_rcu);
lib/list_debug.c:EXPORT_SYMBOL(pax_list_del_rcu);
lib/llist.c:EXPORT_SYMBOL_GPL(pax_llist_add_batch);

I haven't exhaustively checked, but I assume it could touch any of the
list pieces? I suspect there are mixtures of read-only and
non-read-only elements, but I haven't dug that far yet. From what I
can see in the cgroup case I showed, all the struct cftype variables
were in .data (static struct cftype foo[] = { ... }) so no kmalloc nor
vmalloc ones are mixed in. But I doubt we can entirely depend on
that...

> For the latter mixed case, the __rare_write_ptr() approach probably
> doesn't work, and that rules out the mm-based approach, too, I guess. :/
>
>> I think we're better doing a full disabling of RO protection, but
>> there had been objections to this idea in the past, which is why I
>> included the "complex" example, so I don't see a way around it.
>
> My objection to that was that we can't implement CPU-local full
> disabling of RO protection for the kernel page tables on some
> architectures and configurations, e.g. arm64, or 32-bit arm with LPAE.

The CPU-local is a pretty important requirement... Hrmm

> The RW alias write_write(var, val) approach only relies on what arches
> already have to implement for userspace to work, so if we can figure out
> how to make that work API-wise, we can probably implement that
> generically with switch_mm() and {get,put}_user().

With a third mm? I maybe misunderstood what you meant about userspace...

> The only other way I can think to make this work would be to make a copy
> of the whole swapper page tables, with the write-rarely data marked RW.
> For arm64 at least, that'll be incredibly painful to keep in-sync with
> the usual tables, in addition to being very expensive to switch to/from.

Well, I think sync shouldn't be hard since it'd just be a mirror of
the .rodata section, which is configured once. (Well, and for
modules... oof.)

-Kees

-- 
Kees Cook
Pixel Security
