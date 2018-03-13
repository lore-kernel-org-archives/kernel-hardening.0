Date: Mon, 12 Mar 2018 22:53:44 -0600
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: VLA commit log
Message-ID: <20180313045344.GB9027@cisco>
References: <20180312052639.GE8631@eros>
 <CAJHCu1JTa_TFBv220Yju9xz0Rq-9xihp40yJ9-U5Ok-Pg4-aTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHCu1JTa_TFBv220Yju9xz0Rq-9xihp40yJ9-U5Ok-Pg4-aTQ@mail.gmail.com>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: "Tobin C. Harding" <tobin@apporbit.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2018 at 11:28:19AM +0100, Salvatore Mesoraca wrote:
> 2018-03-12 6:26 GMT+01:00 Tobin C. Harding <tobin@apporbit.com>:
> > Hi,
> >
> > I got some push back on the commit log we have all started to use
> > (copying Kees' initial commit log).  If we are going to do hundreds of
> > these patches should we write a perfectly correct commit log that can be
> > included as the start of the 'why' of each VLA removal patch?  Here is
> > my attempt, I am quite bad at writing commit logs so would love someone
> > to fix it up.
> >
> >     Kernel stack size is limited.  Variable Length Arrays (VLA) open the
> >     kernel up to stack abuse in a couple of ways;
> >
> >     1. If the variable can be controlled by an attacker.
> >     2. Not having the size of the stack right there in plain site makes it
> >     harder to maintain the code base because changes in one place can effect
> >     the stack in another place (i.e in another function).
> >
> >     It would be nice to be able to build the kernel with -Wvla.  There has
> >     been some consensus on this already [1].
> >
> >     ...
> >
> >     [1]: https://lkml.org/lkml/2018/3/7/621
> >
> > The '...' would of course be different for each patch.  In case you
> > missed it here is the catalyst for this email
> >
> >         On Mon, Mar 12, 2018 at 03:49:40PM +1100, Tobin C. Harding wrote:
> >         > The kernel would like to have all stack VLA usage removed[1].
> >
> >         Can you please stop writing this?  The Linux kernel isn't
> >         sentient; it doesn't "like" anything.  You need to explain why
> >         *you* (and other people) believe these changes should be made.
> >
> >
> > Perhaps we should add a summary of all the gcc discussion i.e why const
> > variables still cause gcc to emit a VLA warning.
> 
> Maybe it will be useful to update the doc (e.g.
> Documentation/process/coding-style.rst or a new
> Documentation/process/vla-considered-harmful.rst) with an extensive
> explanation of why VLAs shouldn't be used.
> And then we can just refer to that.

This seems like a great idea. Perhaps we can combine Kees' recent
reply + a link to the original Linus mail into something? There's also
a similar thread from about four months ago when I originally started
looking at this that we could grab stuff from.

Cheers,

Tycho
