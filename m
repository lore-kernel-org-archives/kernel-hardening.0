Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 6 Nov 2015 21:42:17 -0800
From: Josh Triplett <josh@joshtriplett.org>
Message-ID: <20151107054217.GA32075@x>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
 <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
 <20151107002508.GA2605@cloud>
 <20151107024612.GC19551@kroah.com>
 <CAGXu5jK70Rn3QqzkwDRMDmt-sW0Xhw0X8afp3KLgw4SYPiZHrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jK70Rn3QqzkwDRMDmt-sW0Xhw0X8afp3KLgw4SYPiZHrQ@mail.gmail.com>
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Kees Cook <keescook@chromium.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Theodore Tso <tytso@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 06, 2015 at 08:16:59PM -0800, Kees Cook wrote:
> On Fri, Nov 6, 2015 at 6:46 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Nov 06, 2015 at 04:25:08PM -0800, Josh Triplett wrote:
> >> On Fri, Nov 06, 2015 at 03:30:39PM -0800, Kees Cook wrote:
> >> > On Fri, Nov 6, 2015 at 2:55 PM, Emese Revfy <re.emese@gmail.com> wrote:
> >> > >  * initify: This plugin isn't security related either.
> >> > >     It moves string constants (__func__ and function string arguments
> >> > >     marked by the nocapture attribute) only referenced in
> >> > >     __init/__exit functions to __initconst/__exitconst sections.
> >> > >     It reduces memory usage (many kB), I think it may be important for
> >> > >     embedded systems.
> >> >
> >> > I bet the Tinification project ( https://tiny.wiki.kernel.org/ ) would
> >> > be interested in this! (CCing Josh for thoughts.)
> >>
> >> I'd be quite interested.
> >>
> >> Could the plugin operate in a mode where it emits warnings to add such
> >> annotations explicitly in the code, rather than just automatically
> >> moving the data?
> >
> > That would be nice for the constanfy mode as well, especially as some
> > people aren't using gcc to build the kernel anymore, so it would be good
> > to mark these "for real" in the .c code wherever possible to allow other
> > compilers to take advantage of the plugin indirectly.
> 
> Yeah, I think both modes have value, but I want to make sure we keep
> in mind that gaining these plugins in like using the stack-protector
> flag in gcc: the build results will cover non-upstream code too. I
> want to be sure that our many many downstream users of the kernel will
> still gain the benefits (i.e. it's less useful to Linux everywhere in
> the world if only the upstream code has been fixed).

I agree in both cases: having the plugin usable in "make it so" mode for
the benefit of legacy or out-of-tree code, and having it usable in
"suggest changes to the source" (or outright *edit* the source and
produce a patch) mode to avoid actually mandating the plugin.  Not least
of which because I'd find it surprising if the plugin ever worked across
as broad a range of GCC versions as the kernel typically wants to
support.

(For that matter, as the LLVM Linux project progresses, it might
actually prove easier to provide a clang-based plugin.)

- Josh Triplett
