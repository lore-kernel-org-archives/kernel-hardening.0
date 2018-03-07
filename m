MIME-Version: 1.0
Sender: keescook@google.com
From: Kees Cook <keescook@chromium.org>
Date: Wed, 7 Mar 2018 09:37:24 -0800
Message-ID: <CAGXu5jJaVPPjqtpOLapk8ABT93zaUoaKR-i7Ga6LVSK2OiX_tQ@mail.gmail.com>
Subject: VLA removal (was Re: [RFC 2/2] lustre: use VLA_SAFE)
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <tobin@apporbit.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 7, 2018 at 2:10 AM, Tobin C. Harding <tobin@apporbit.com> wrote:
> On Tue, Mar 06, 2018 at 09:46:02PM -0800, Kees Cook wrote:
>> On Tue, Mar 6, 2018 at 9:27 PM, Tobin C. Harding <me@tobin.cc> wrote:
>> > Currently lustre uses a VLA to store a string on the stack.  We can use
>> > the newly define VLA_SAFE macro to make this declaration safer.
>> >
>> > Use VLA_SAFE to declare VLA.
>>
>> VLA_SAFE implements a max, which is nice, but I think we're just
>> digging ourselves into a bigger hole with this, since now all the
>> maxes must be validated (which isn't done here, what happens if
>> VLA_DEFAULT_MAX is smaller than the strlen() math? We'll overflow the
>> stack buffer in the later sprintf).
>
> ok, lets drop this.
>
> Memory on the stack is always going to be faster than memory from the
> slub allocator, right?  Do you think using kasprintf() is going to be
> acceptable? Isn't it only going to be acceptable on non-time critical
> paths?  I'm still trying to get my head around how we get rid of VLA
> when the stack is faster?  Is this a speed vs safety trade off that must
> be tackled on a case by case basis?

It really does need to be a case-by-case basis. It'll be a balance of
speed, safety, and sanity. :) In the lustre case, that's both a bug
fix (buffer over-run) and an unbounded VLA removal. Putting a string
of unknown length on the stack tends not to be sensible, so the
kmalloc/kfree is reasonable, IMO.

Building with -Wvla, I see 209 unique locations reported in 60 directories:
http://paste.ubuntu.com/p/srQxwPQS9s/

In the case of the crypto, my past thoughts have included either
adding a buffer to some already-allocated context, or using an upper
bound on the VLAs, since there's a fixed number of implementations
built in at any given time. Though, I suspect neither will work
without more examination. Usually, if it were easy, it'd be done
already. ;)

To try to keep from adding new VLAs, maybe we could add -Wvla to the
W=n level in scripts/Makefile.extrawarn. Likely W=2:

# W=1 - warnings that may be relevant and does not occur too often
# W=2 - warnings that occur quite often but may still be relevant
# W=3 - the more obscure warnings, can most likely be ignored

And frankly, maybe -Wformat-security -- and perhaps format-truncation
and format-overflow -- should get added to W=2 too... they've gotten
it much less noisy over time, though still very noisy. ;)

Or, as mentioned in another thread, disable -Wvla in certain
directories but enable it at the top-level. I'm less of a fan of that,
though, since it tends to lead to the problem just getting forgotten.

-Kees

-- 
Kees Cook
Pixel Security
