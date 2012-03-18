Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 18 Mar 2012 21:53:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20120318205342.GA14383@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com> <20120311174953.GB2729@redhat.com> <CA+55aFx43nZmhRg5Qv5x-4BdgcM-y80ECrgC8mCWc0RqU+_8rQ@mail.gmail.com> <20120314185510.GA14172@redhat.com> <20120314185538.GB14172@redhat.com> <CA+55aFzKc578eWYaq4+OaOM6hFjW+ePYCeC++_1p8f09YWV_hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzKc578eWYaq4+OaOM6hFjW+ePYCeC++_1p8f09YWV_hA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/1] CLONE_PARENT shouldn't allow to set ->exit_signal
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Djalal Harouni <tixxdz@opendz.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Roland McGrath <roland@hack.frob.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/18, Linus Torvalds wrote:
>
> On Wed, Mar 14, 2012 at 11:55 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > +       if (clone_flags & CLONE_THREAD)
> > +               p->exit_signal = -1;
> > +       else if (clone_flags & CLONE_PARENT)
> > +               p->exit_signal = current->group_leader->exit_signal;
> > +       else
> > +               p->exit_signal = (clone_flags & CSIGNAL);
>
> So why is it "current->group_leader->exit_signal" rather than the much
> more logical (imho) and simpler "current->exit_signal"?

This would be wrong if current is not the main thread. In this
case current->exit_signal = -1. Only group_leader has the "real"
exit_signal used for notification.

Historically "exit_signal = -1" meant different things, currently
it only means "I am not the leader", see thread_group_leader().

I'll write another email tomorrow. Yes, I do remember I promised
the security fixes in this area, sorry for delay.

Oleg.
