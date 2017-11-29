Date: Thu, 30 Nov 2017 10:58:34 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171129235834.GQ6217@eros>
References: <1511821819-5496-1-git-send-email-me@tobin.cc>
 <CAGXu5jK3hJMMrdGQsQxhyLiXhro4DYdpftvtTunM-84PkUeD_Q@mail.gmail.com>
 <20171128015041.GT17858@eros>
 <CAPDLWs8tJ5voge-gS-W+gxpRRk2GximPkGm1d9pxf5QNbCKufA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDLWs8tJ5voge-gS-W+gxpRRk2GximPkGm1d9pxf5QNbCKufA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC 0/3] kallsyms: don't leak address
 when printing symbol
To: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 08:58:44AM +0530, Kaiwan N Billimoria wrote:
> On Tue, Nov 28, 2017 at 7:20 AM, Tobin C. Harding <me@tobin.cc> wrote:
> >
> > Noob question: how do we _know_ this. In other words how do we know no
> > userland tools rely on the current behaviour? No stress to answer Kees,
> > this is a pretty general kernel dev question.
> 
> Perhaps I'm reading this wrong, but anyway: besides ftrace, kprobes
> will require a
> symbol-to-address lookup. Specifically, in the function
> kprobe_lookup_name() which
> in turn invokes kallsyms_lookup_name().

We should be right for this call chain because the patch doesn't touch
kallsyms_lookup_name().

> AFAIK, SystemTap (userland) is built on top of the kprobes infrastructure..

This actually indirectly answers the concern. Since no userland tool
should be looking up a kernel address the only code we can break is
kernel code.


thanks,
Tobin
