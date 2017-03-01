Date: Wed, 1 Mar 2017 10:59:15 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170301105914.GB28874@leverpostej>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-5-git-send-email-keescook@chromium.org>
 <CALCETrUruKRCnHAEVg6pXe+43WQx7K6LCOHg5zVEjLfzw8nQUA@mail.gmail.com>
 <CAGXu5jK2ppnFGA3SG76BPkmGGeZcK3-5k9XaHihkmWkwPvomgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jK2ppnFGA3SG76BPkmGGeZcK3-5k9XaHihkmWkwPvomgw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC][PATCH 4/8] x86: Implement __arch_rare_write_map/unmap()
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 28, 2017 at 01:35:13PM -0800, Kees Cook wrote:
> On Tue, Feb 28, 2017 at 11:33 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> > On Mon, Feb 27, 2017 at 12:43 PM, Kees Cook <keescook@chromium.org> wrote:
> >> Based on PaX's x86 pax_{open,close}_kernel() implementation, this
> >> allows HAVE_ARCH_RARE_WRITE to work on x86.
> >>
> >> There is missing work to sort out some header file issues where preempt.h
> >> is missing, though it can't be included in pg_table.h unconditionally...
> >> some other solution will be needed, perhaps an entirely separate header
> >> file for rare_write()-related defines...
> >>
> >> This patch is also missing paravirt support.
> >>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> ---
> >> [...]
> >> +static inline unsigned long __arch_rare_write_unmap(void)
> >> +{
> >> +       unsigned long cr0;
> >> +
> >> +       barrier();
> >> +       cr0 = read_cr0() ^ X86_CR0_WP;
> >> +       BUG_ON(!(cr0 & X86_CR0_WP));
> >> +       write_cr0(cr0);
> >> +       barrier();
> >> +       preempt_enable_no_resched();
> >> +       return cr0 ^ X86_CR0_WP;
> >> +}

> > Can't we at least make this:
> >
> > struct rare_write_mapping {
> >   void *addr;
> >   struct arch_rare_write_state arch_state;
> > };
> >
> > static inline struct rare_write_mapping __arch_rare_write_map(void
> > *addr, size_t len);
> > static inline void __arch_rare_write_unmap(struct rare_write_mapping mapping);
> 
> How do you envision this working with the more complex things I
> included in the latter patches of the series, namely doing linked list
> updates across multiple structure instances, etc?
> 
> ie, poor list manipulation pseudo-code:
> 
> turn off read-only;
> struct_one->next = struct_tree->node;
> struct_three->prev = struct_one->node;
> struct_two->prev = struct_two->next = NULL;
> turn on read-only;
> 
> That's three separate memory areas involved...

Do we need all list manipulation primitives, or is is just list_add()
and list_del() that we really care about?

If we only need to support a limited set of primitives, then we could
special-case those, e.g. for the above:

	rare_write_map();
	__rare_write(struct_one->next, struct_tree->node);
	__rare_write(struct_three->prev, struct_one->node);
	__rare_write(struct_two->prev, NULL);
	__rare_write(struct_two->next, NULL);
	rare_write_unmap();

... then the __rare_write() can map/unmap a separate page table if
required. We can have separate rare_write() and __rare_write() to fold
in the rare_write_{map,unmap}(), as with {__,}copy_*_user().

That doesn't work if we need arbitrary primitives, certainly.

Thanks,
Mark.
