Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 6 Nov 2015 18:46:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20151107024612.GC19551@kroah.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
 <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
 <20151107002508.GA2605@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151107002508.GA2605@cloud>
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Theodore Tso <tytso@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 06, 2015 at 04:25:08PM -0800, Josh Triplett wrote:
> On Fri, Nov 06, 2015 at 03:30:39PM -0800, Kees Cook wrote:
> > On Fri, Nov 6, 2015 at 2:55 PM, Emese Revfy <re.emese@gmail.com> wrote:
> > >  * initify: This plugin isn't security related either.
> > >     It moves string constants (__func__ and function string arguments
> > >     marked by the nocapture attribute) only referenced in
> > >     __init/__exit functions to __initconst/__exitconst sections.
> > >     It reduces memory usage (many kB), I think it may be important for
> > >     embedded systems.
> > 
> > I bet the Tinification project ( https://tiny.wiki.kernel.org/ ) would
> > be interested in this! (CCing Josh for thoughts.)
> 
> I'd be quite interested.
> 
> Could the plugin operate in a mode where it emits warnings to add such
> annotations explicitly in the code, rather than just automatically
> moving the data?

That would be nice for the constanfy mode as well, especially as some
people aren't using gcc to build the kernel anymore, so it would be good
to mark these "for real" in the .c code wherever possible to allow other
compilers to take advantage of the plugin indirectly.

thanks,

greg k-h
