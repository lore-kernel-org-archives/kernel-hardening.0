Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 8 Nov 2015 00:37:09 -0800
From: Josh Triplett <josh@joshtriplett.org>
Message-ID: <20151108083708.GB1900@x>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
 <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
 <20151107002508.GA2605@cloud>
 <20151107224235.774f2e26aca4725bc24be02b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151107224235.774f2e26aca4725bc24be02b@gmail.com>
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Emese Revfy <re.emese@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 07, 2015 at 10:42:35PM +0100, Emese Revfy wrote:
> On Fri, 6 Nov 2015 16:25:08 -0800
> Josh Triplett <josh@joshtriplett.org> wrote:
> 
> > On Fri, Nov 06, 2015 at 03:30:39PM -0800, Kees Cook wrote:
> > > On Fri, Nov 6, 2015 at 2:55 PM, Emese Revfy <re.emese@gmail.com> wrote:
> > > >  * initify: This plugin isn't security related either.
> > > >     It moves string constants (__func__ and function string arguments
> > > >     marked by the nocapture attribute) only referenced in
> > > >     __init/__exit functions to __initconst/__exitconst sections.
> > > >     It reduces memory usage (many kB), I think it may be important for
> > > >     embedded systems.
> > > 
> > > I bet the Tinification project ( https://tiny.wiki.kernel.org/ ) would
> > > be interested in this! (CCing Josh for thoughts.)
> > 
> > I'd be quite interested.
> > 
> > Could the plugin operate in a mode where it emits warnings to add such
> > annotations explicitly in the code, rather than just automatically
> > moving the data?
> 
> I can do it, but as Ard said it also moves e.g., format strings and __func__
> that is not possible to do with source code changes.

Ah.  It'd be nice to have GCC options in default GCC to move those.
