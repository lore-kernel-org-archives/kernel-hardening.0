Date: Mon, 6 Feb 2017 16:09:45 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170206160945.GB4190@leverpostej>
References: <CAEXv5_ivEPDJSaJwmx+oLiUYRZsAa9ZPWH6oWZy-Rkoa3ZHRZg@mail.gmail.com>
 <20170206151341.GA13383@kroah.com>
 <CAEXv5_g4zLSJCrfPWUe85UdyOo1WDGdw2LLXOkcjbf5kf4VnTw@mail.gmail.com>
 <20170206153047.GA14434@kroah.com>
 <CAEXv5_iD0k-mxqOgT9W_mf1_Xo46qePFXvTX2wd32xG0gPzSUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_iD0k-mxqOgT9W_mf1_Xo46qePFXvTX2wd32xG0gPzSUw@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: HARDENED_ATOMIC documentation
To: David Windsor <dwindsor@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 06, 2017 at 11:02:56AM -0500, David Windsor wrote:
> > Why not put the documentation right into the kernel tree?  That way it
> > is always up to date with the code (well, hopefully), it will get built
> > and hosted all over the internet at different sites (including
> > kernel.org) and is much easier to search and people can modify easier.
> >
> 
> Fair enough, I'll re-submit as a patch against something in
> Documentation/.  It doesn't appear that there's currently a good
> landing spot for this, as Documentation/security/self-protection.txt
> already looks fairly crowded.  Individual KSPP sub-project details
> would impossibly complicate this file.  Maybe a kspp/ or
> self-protection/ sub-directory with files for individual KSPP
> features?

It would be better to mirror our documentation of atomics; i.e. place
this in Documentation/core-api/refcount_ops.rst.

Developers don't care if this is part of KSPP, they care about the API.

Thanks,
Mark.
