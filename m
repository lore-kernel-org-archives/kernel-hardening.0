Date: Tue, 28 Nov 2017 12:50:41 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171128015041.GT17858@eros>
References: <1511821819-5496-1-git-send-email-me@tobin.cc>
 <CAGXu5jK3hJMMrdGQsQxhyLiXhro4DYdpftvtTunM-84PkUeD_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jK3hJMMrdGQsQxhyLiXhro4DYdpftvtTunM-84PkUeD_Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC 0/3] kallsyms: don't leak address when printing symbol
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 04:52:21PM -0800, Kees Cook wrote:
> On Mon, Nov 27, 2017 at 2:30 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > This is an RFC for two reasons.
> >
> > 1) I don't know who this patch set may break?
> > 2) Patch set includes a function that is not called. Function is there
> >    to facilitate fixing breakages.
> >
> > _If_ no one gets broken then we can remove the unused function.
> >
> > Thanks for looking at this.
> >
> > Currently if a pointer is printed using %p[ssB] and the symbol is not
> > found (kallsyms_lookup() fails) then we print the actual address. This
> > potentially leaks kernel addresses. We could instead print something
> > _safe_. If kallsyms is made to return an error then callers of
> > sprint_symbol() can decide what to do.
> >
> > In the case of vsprintf we can print '<no-symbol>' (patch 2).
> >
> > In the case of trace we want the address so we can check the return code
> > and print the address if no symbol is found (patch 3).
> >
> > Design for this set loosely suggested by Steve Rostedt (so as not to
> > break ftrace).
> 
> If tracing is the only place this is needed, this series seems reasonable to me.

Noob question: how do we _know_ this. In other words how do we know no
userland tools rely on the current behaviour? No stress to answer Kees,
this is a pretty general kernel dev question.

thanks,
Tobin.
