MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CALCETrUruKRCnHAEVg6pXe+43WQx7K6LCOHg5zVEjLfzw8nQUA@mail.gmail.com>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-5-git-send-email-keescook@chromium.org> <CALCETrUruKRCnHAEVg6pXe+43WQx7K6LCOHg5zVEjLfzw8nQUA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Feb 2017 13:35:13 -0800
Message-ID: <CAGXu5jK2ppnFGA3SG76BPkmGGeZcK3-5k9XaHihkmWkwPvomgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH 4/8] x86: Implement __arch_rare_write_map/unmap()
To: Andy Lutomirski <luto@amacapital.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 28, 2017 at 11:33 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Feb 27, 2017 at 12:43 PM, Kees Cook <keescook@chromium.org> wrote:
>> Based on PaX's x86 pax_{open,close}_kernel() implementation, this
>> allows HAVE_ARCH_RARE_WRITE to work on x86.
>>
>> There is missing work to sort out some header file issues where preempt.h
>> is missing, though it can't be included in pg_table.h unconditionally...
>> some other solution will be needed, perhaps an entirely separate header
>> file for rare_write()-related defines...
>>
>> This patch is also missing paravirt support.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> [...]
>> +static inline unsigned long __arch_rare_write_unmap(void)
>> +{
>> +       unsigned long cr0;
>> +
>> +       barrier();
>> +       cr0 = read_cr0() ^ X86_CR0_WP;
>> +       BUG_ON(!(cr0 & X86_CR0_WP));
>> +       write_cr0(cr0);
>> +       barrier();
>> +       preempt_enable_no_resched();
>> +       return cr0 ^ X86_CR0_WP;
>> +}
>
> This seems like a wonderful ROP target.  Off-hand, I'd guess the
> reason it's never been a problem (that I've heard of) in grsecurity is
> that grsecurity isn't quite popular enough to be a big publicly
> discussed target.

The reason it's less risky is due to the inlining. This will always
produce code where WP is left enabled again before a "ret" path is
taken. That said, it is still a minor ROP target in my mind, since it
still has the form:

turn off read-only;
write a thing;
turn on read-only;

But frankly, if an attacker already has enough control over the stack
to build up registers for the "write a thing" step to do what they
want it to do, they likely already have vast control over the kernel
already.

> Can't we at least make this:
>
> struct rare_write_mapping {
>   void *addr;
>   struct arch_rare_write_state arch_state;
> };
>
> static inline struct rare_write_mapping __arch_rare_write_map(void
> *addr, size_t len);
> static inline void __arch_rare_write_unmap(struct rare_write_mapping mapping);

How do you envision this working with the more complex things I
included in the latter patches of the series, namely doing linked list
updates across multiple structure instances, etc?

ie, poor list manipulation pseudo-code:

turn off read-only;
struct_one->next = struct_tree->node;
struct_three->prev = struct_one->node;
struct_two->prev = struct_two->next = NULL;
turn on read-only;

That's three separate memory areas involved...

> or similar, this allowing a non-terrifying implementation (e.g. switch
> CR3 to a specialized pagetable) down the road?

We'd need some kind of per-CPU mapping that other CPUs couldn't get
at... which is kind of what the WP bit gets us already. (And ARM is
similar: it elevates permissions on the kernel memory domain to ignore
restrictions.)

> I realize that if you get exactly the code generation you want, the
> CR0.WP approach *might* be okay, but that seems quite fragile.

I think with preempt off, barriers, and inlining, this should be pretty safe...

(Which reminds me that my x86 implementation needs to use
__always_inline, rather than just inline...)

-Kees

-- 
Kees Cook
Pixel Security
