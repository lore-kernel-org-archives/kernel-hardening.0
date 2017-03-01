MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170301112436.GC28874@leverpostej>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-5-git-send-email-keescook@chromium.org>
 <CALCETrUruKRCnHAEVg6pXe+43WQx7K6LCOHg5zVEjLfzw8nQUA@mail.gmail.com>
 <CAGXu5jK2ppnFGA3SG76BPkmGGeZcK3-5k9XaHihkmWkwPvomgw@mail.gmail.com>
 <CALCETrV=HmBxUK9rp1JiJZuX78XWmmt8-mXFohEAUXyS4z6+oQ@mail.gmail.com>
 <CAGXu5jLWL8cUV5nTqCB5ganimuFfvNwaAW9STBvwU-UM9pgbEg@mail.gmail.com> <20170301112436.GC28874@leverpostej>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 1 Mar 2017 12:25:11 -0800
Message-ID: <CAGXu5jKVANfBQVf66c=bJO7kRPhc7Q++L6pQk5m+6TLWm_gw8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH 4/8] x86: Implement __arch_rare_write_map/unmap()
To: Mark Rutland <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 1, 2017 at 3:24 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Tue, Feb 28, 2017 at 03:52:26PM -0800, Kees Cook wrote:
>> On Tue, Feb 28, 2017 at 2:54 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > On Tue, Feb 28, 2017 at 1:35 PM, Kees Cook <keescook@chromium.org> wrote:
>> >>> Can't we at least make this:
>> >>>
>> >>> struct rare_write_mapping {
>> >>>   void *addr;
>> >>>   struct arch_rare_write_state arch_state;
>> >>> };
>> >>>
>> >>> static inline struct rare_write_mapping __arch_rare_write_map(void
>> >>> *addr, size_t len);
>> >>> static inline void __arch_rare_write_unmap(struct rare_write_mapping mapping);
>> >>
>> >> How do you envision this working with the more complex things I
>> >> included in the latter patches of the series, namely doing linked list
>> >> updates across multiple structure instances, etc?
>> >>
>> >> ie, poor list manipulation pseudo-code:
>> >>
>> >> turn off read-only;
>> >> struct_one->next = struct_tree->node;
>> >> struct_three->prev = struct_one->node;
>> >> struct_two->prev = struct_two->next = NULL;
>> >> turn on read-only;
>> >>
>> >> That's three separate memory areas involved...
>> >
>> > Fair enough.  That being said, how is this supposed to work on
>> > architectures that don't have a global "disable write protection" bit?
>> > Surely these architectures exist.
>>
>> I don't know. :) That's part of the reason for putting up this series:
>> looking to see what's possible on other architectures. It's not clear
>> to me what arm64 can do, for example.
>
> There is no global override of this sort on arm64. Just having map/unap,
> open/close, shed/unshed, etc, won't work.
>
> The options I can think of for arm64 are:
>
> * Have a separate RW alias of just the write_rarely data, that we
>   temporarily map-in on a given CPU (using TTBR0) to perform the write.
>   The RW alias is at a different VA to the usual RO alias, so we have to
>   convert each pointer to its RW alias to perform the write. That's why
>   we need __rare_write_ptr() to hide this, and can't have uninstrumented
>   writes.

I think only the list code isn't instrumented, and that's just because
it discards casts outside the function. There's no reason it couldn't
be instrumented. All the other places I can see are using the
const_cast() explicitly because otherwise gcc freaks out (since the
constify plugin forces the variables const). There are a few places
where things aren't explicitly const_cast() (like in the modules).

Oh hey, I just found a bug in the open/close stuff, that's why there
was a giant routine misdetected by scripts... just changes one of the
outiers though. I'll send a separate email with the correction...

>   Since this would *only* map the write_rarely data, it's simple to set
>   up, and we don't need to modify the tables at runtime.
>
>   I also think we can implement this generically using switch_mm() and
>   {get,put}_user(), or specialised variants thereof.
>
>   Assuming we can figure out how to handle those complex cases, this is
>   my preferred solution. :)

Would this alias be CPU-local? (I assume yes, given the "give up on on
being per-cpu" option below..)

> * Have a copy of the entire swapper page tables, which differs only in
>   the write_rarely data being RW. We then switch TTBR1 over to this for
>   the duration of the rare_write_map() .. write_write_unmap() sequence.
>
>   While this sounds conceptually simple, it's far more complex in
>   practice. Keeping the not-quite-clone of the swapper in-sync is going
>   to be very painful and ripe for error.
>
>   Additionally, the TTBR1 switch will be very expensive, far more so
>   than the TTBR0 switch due to TLB maintenance and other work (including
>   switching TTBR0 twice per TTBR1 switch, itself requiring synchronised
>   TLB maintenance and other work).
>
>   I am not fond of this approach.
>
> * Give up on this being per-cpu. Either change the permissions in place,
>   or fixmap an RW alias as required. In either case, all CPUs will have
>   RW access.

-Kees

-- 
Kees Cook
Pixel Security
