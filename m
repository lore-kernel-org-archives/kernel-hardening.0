Date: Thu, 8 Mar 2018 09:28:01 +1100
From: "Tobin C. Harding" <tobin@apporbit.com>
Subject: Re: [RFC 2/2] lustre: use VLA_SAFE
Message-ID: <20180307222801.GH11750@eros>
References: <1520400451-11475-1-git-send-email-me@tobin.cc>
 <1520400451-11475-3-git-send-email-me@tobin.cc>
 <CAGXu5jKgQsg8e4N2oqZc6g6EdvcEA45hoK8Gu63=bwNuJwZrig@mail.gmail.com>
 <20180307101014.GG11750@eros>
 <87efkveezw.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87efkveezw.fsf@rasmusvillemoes.dk>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>, "Tobin C. Harding" <me@tobin.cc>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 07, 2018 at 10:45:55PM +0100, Rasmus Villemoes wrote:
> On Wed, Mar 07 2018, "Tobin C. Harding" <tobin@apporbit.com> wrote:
> 
> > On Tue, Mar 06, 2018 at 09:46:02PM -0800, Kees Cook wrote:
> >> On Tue, Mar 6, 2018 at 9:27 PM, Tobin C. Harding <me@tobin.cc> wrote:
> >> > Currently lustre uses a VLA to store a string on the stack.  We can use
> >> > the newly define VLA_SAFE macro to make this declaration safer.
> >> >
> >> > Use VLA_SAFE to declare VLA.
> >> 
> >> VLA_SAFE implements a max, which is nice, but I think we're just
> >> digging ourselves into a bigger hole with this, since now all the
> >> maxes must be validated (which isn't done here, what happens if
> >> VLA_DEFAULT_MAX is smaller than the strlen() math? We'll overflow the
> >> stack buffer in the later sprintf).
> >
> > ok, lets drop this.
> >
> > Memory on the stack is always going to be faster than memory from the
> > slub allocator, right?  Do you think using kasprintf() is going to be
> > acceptable? Isn't it only going to be acceptable on non-time critical
> > paths?
> 
> Probably anything that does string formatting to begin with (using any
> *printf function) is not performance critical.

Oh cool, good metric. thanks.

> That e.g. applies to the
> lustre case. It's true that kasprintf() ends up doing the vsnprintf()
> twice, but I haven't yet seen an example where that is really a
> problem. Should it actually come up, I've thought about a few things one
> might do to partly mitigate that:
> 
> (1) Use that the vast majority of kasprintf() results are short'ish
> strings, so instead of letting the first vsnprintf() write nothing at
> all, allocate a smallish (32/64) stack buffer and do the first
> vsnprintf() to that - on "success", just kmemdup() the result instead of
> doing the formatting again.
> 
> (2) Add a
> 
>   char *kasprintf_buf(buf, len, gfp, fmt, ...)
> 
> public API that will use the user-provided (buf, len) as initial target,
> and return buf on success, otherwise fall back to kmalloc'ing an
> appropriate buffer and redoing the formatting. It's not totally unheard
> of to decide whether to kfree() based on comparison with a caller-owned
> pointer. Typically buf would be stack-allocated, and it's up to the
> caller to decide what a reasonable size would be - and especially useful
> in cases such as the lustre one where the string does not outlive the
> sprintf() caller.
> 
> (1) is easily implemented in terms of this.
> 
> (3) As (2), but with the rule being that buf must be kmalloc'ed, and
> kasprintf() will kfree() it and allocate a new buffer if
> necessary. Probably too hard to use (and exact semantics on failure
> would need to be decided; like realloc(), or is the passed-in too-small
> buffer already kfree'd?)
> 
> Rasmus

So, I can go ahead and patch any place that uses *printf() with a VLA to
use kasprintf() and iff performance is mentioned look at speeding up
kasprintf().

I like it.

thanks,
Tobin.
