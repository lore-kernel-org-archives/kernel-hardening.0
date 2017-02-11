Date: Sat, 11 Feb 2017 10:23:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CALAqxLWMP7MFNRPTU3Ar3m=D1hFdS=d7_tbhkyrEadUQrRe7qw@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1702111016120.3734@nanos>
References: <20170211013758.3288-1-me@jessfraz.com> <20170211013758.3288-2-me@jessfraz.com> <CALAqxLWMP7MFNRPTU3Ar3m=D1hFdS=d7_tbhkyrEadUQrRe7qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 2/5] time: mark syscore_ops as __ro_after_init
To: John Stultz <john.stultz@linaro.org>
Cc: Jess Frazelle <me@jessfraz.com>, Rik van Riel <riel@redhat.com>, open list <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 10 Feb 2017, John Stultz wrote:

> On Fri, Feb 10, 2017 at 5:37 PM, Jess Frazelle <me@jessfraz.com> wrote:
> > Marked syscore_ops structs as __ro_after_init when register_syscore_ops was
> > called only during init. Most of the caller functions were already annotated as
> > __init.
> > unregister_syscore_ops() was never called on these ops.
> > This protects the data structure from accidental corruption.
> >
> > Suggested-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Jess Frazelle <me@jessfraz.com>
> > Acked-by: Rik van Riel <riel@redhat.com>
> 
> Thanks for sending this out. Looks reasonable to me. I'll queue it for
> testing, targeting for 4.12.

NAK. See:

  http://lkml.kernel.org/r/alpine.DEB.2.20.1702110948030.3734@nanos

Thanks,

	tglx
