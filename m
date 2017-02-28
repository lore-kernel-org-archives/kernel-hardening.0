MIME-Version: 1.0
In-Reply-To: <CAGXu5jK2ppnFGA3SG76BPkmGGeZcK3-5k9XaHihkmWkwPvomgw@mail.gmail.com>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-5-git-send-email-keescook@chromium.org>
 <CALCETrUruKRCnHAEVg6pXe+43WQx7K6LCOHg5zVEjLfzw8nQUA@mail.gmail.com> <CAGXu5jK2ppnFGA3SG76BPkmGGeZcK3-5k9XaHihkmWkwPvomgw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 28 Feb 2017 14:54:25 -0800
Message-ID: <CALCETrV=HmBxUK9rp1JiJZuX78XWmmt8-mXFohEAUXyS4z6+oQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH 4/8] x86: Implement __arch_rare_write_map/unmap()
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 28, 2017 at 1:35 PM, Kees Cook <keescook@chromium.org> wrote:
>> Can't we at least make this:
>>
>> struct rare_write_mapping {
>>   void *addr;
>>   struct arch_rare_write_state arch_state;
>> };
>>
>> static inline struct rare_write_mapping __arch_rare_write_map(void
>> *addr, size_t len);
>> static inline void __arch_rare_write_unmap(struct rare_write_mapping mapping);
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

Fair enough.  That being said, how is this supposed to work on
architectures that don't have a global "disable write protection" bit?
 Surely these architectures exist.

>
>> or similar, this allowing a non-terrifying implementation (e.g. switch
>> CR3 to a specialized pagetable) down the road?
>
> We'd need some kind of per-CPU mapping that other CPUs couldn't get
> at... which is kind of what the WP bit gets us already. (And ARM is
> similar: it elevates permissions on the kernel memory domain to ignore
> restrictions.)
>
>> I realize that if you get exactly the code generation you want, the
>> CR0.WP approach *might* be okay, but that seems quite fragile.
>
> I think with preempt off, barriers, and inlining, this should be pretty safe...
>
