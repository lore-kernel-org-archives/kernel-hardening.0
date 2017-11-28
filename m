MIME-Version: 1.0
In-Reply-To: <20171128015041.GT17858@eros>
References: <1511821819-5496-1-git-send-email-me@tobin.cc> <CAGXu5jK3hJMMrdGQsQxhyLiXhro4DYdpftvtTunM-84PkUeD_Q@mail.gmail.com>
 <20171128015041.GT17858@eros>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Tue, 28 Nov 2017 08:58:44 +0530
Message-ID: <CAPDLWs8tJ5voge-gS-W+gxpRRk2GximPkGm1d9pxf5QNbCKufA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [RFC 0/3] kallsyms: don't leak address
 when printing symbol
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 7:20 AM, Tobin C. Harding <me@tobin.cc> wrote:
>
> Noob question: how do we _know_ this. In other words how do we know no
> userland tools rely on the current behaviour? No stress to answer Kees,
> this is a pretty general kernel dev question.

Perhaps I'm reading this wrong, but anyway: besides ftrace, kprobes
will require a
symbol-to-address lookup. Specifically, in the function
kprobe_lookup_name() which
in turn invokes kallsyms_lookup_name().
AFAIK, SystemTap (userland) is built on top of the kprobes infrastructure..

thanks,
Kaiwan.
