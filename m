Date: Thu, 2 Mar 2017 11:20:32 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170302112032.GC19632@leverpostej>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-5-git-send-email-keescook@chromium.org>
 <CALCETrUruKRCnHAEVg6pXe+43WQx7K6LCOHg5zVEjLfzw8nQUA@mail.gmail.com>
 <CAGXu5jK2ppnFGA3SG76BPkmGGeZcK3-5k9XaHihkmWkwPvomgw@mail.gmail.com>
 <CALCETrV=HmBxUK9rp1JiJZuX78XWmmt8-mXFohEAUXyS4z6+oQ@mail.gmail.com>
 <CAGXu5jLWL8cUV5nTqCB5ganimuFfvNwaAW9STBvwU-UM9pgbEg@mail.gmail.com>
 <20170301112436.GC28874@leverpostej>
 <CAGXu5jKVANfBQVf66c=bJO7kRPhc7Q++L6pQk5m+6TLWm_gw8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKVANfBQVf66c=bJO7kRPhc7Q++L6pQk5m+6TLWm_gw8g@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC][PATCH 4/8] x86: Implement __arch_rare_write_map/unmap()
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 01, 2017 at 12:25:11PM -0800, Kees Cook wrote:
> On Wed, Mar 1, 2017 at 3:24 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > There is no global override of this sort on arm64. Just having map/unap,
> > open/close, shed/unshed, etc, won't work.
> >
> > The options I can think of for arm64 are:
> >
> > * Have a separate RW alias of just the write_rarely data, that we
> >   temporarily map-in on a given CPU (using TTBR0) to perform the write.
> >   The RW alias is at a different VA to the usual RO alias, so we have to
> >   convert each pointer to its RW alias to perform the write. That's why
> >   we need __rare_write_ptr() to hide this, and can't have uninstrumented
> >   writes.
> 
> I think only the list code isn't instrumented, and that's just because
> it discards casts outside the function. There's no reason it couldn't
> be instrumented. 

Ok, it sounds like we could make this work, then.

> >   Since this would *only* map the write_rarely data, it's simple to set
> >   up, and we don't need to modify the tables at runtime.
> >
> >   I also think we can implement this generically using switch_mm() and
> >   {get,put}_user(), or specialised variants thereof.
> >
> >   Assuming we can figure out how to handle those complex cases, this is
> >   my preferred solution. :)
> 
> Would this alias be CPU-local? (I assume yes, given the "give up on on
> being per-cpu" option below..)

Yes, this would be CPU-local. It would be like mapping the idmap, or
userspace.

Thanks,
Mark.
