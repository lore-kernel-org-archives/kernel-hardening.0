Date: Wed, 7 Mar 2018 21:10:14 +1100
From: "Tobin C. Harding" <tobin@apporbit.com>
Subject: Re: [RFC 2/2] lustre: use VLA_SAFE
Message-ID: <20180307101014.GG11750@eros>
References: <1520400451-11475-1-git-send-email-me@tobin.cc>
 <1520400451-11475-3-git-send-email-me@tobin.cc>
 <CAGXu5jKgQsg8e4N2oqZc6g6EdvcEA45hoK8Gu63=bwNuJwZrig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKgQsg8e4N2oqZc6g6EdvcEA45hoK8Gu63=bwNuJwZrig@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 06, 2018 at 09:46:02PM -0800, Kees Cook wrote:
> On Tue, Mar 6, 2018 at 9:27 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > Currently lustre uses a VLA to store a string on the stack.  We can use
> > the newly define VLA_SAFE macro to make this declaration safer.
> >
> > Use VLA_SAFE to declare VLA.
> 
> VLA_SAFE implements a max, which is nice, but I think we're just
> digging ourselves into a bigger hole with this, since now all the
> maxes must be validated (which isn't done here, what happens if
> VLA_DEFAULT_MAX is smaller than the strlen() math? We'll overflow the
> stack buffer in the later sprintf).

ok, lets drop this.

Memory on the stack is always going to be faster than memory from the
slub allocator, right?  Do you think using kasprintf() is going to be
acceptable? Isn't it only going to be acceptable on non-time critical
paths?  I'm still trying to get my head around how we get rid of VLA
when the stack is faster?  Is this a speed vs safety trade off that must
be tackled on a case by case basis?


thanks,
Tobin.
