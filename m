Date: Wed, 8 Feb 2017 10:47:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CAEk6tEyzgCV5YWppu5OwxjFz6royvXmJM-Qs_mKTUSsqeR7wZw@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1702081045440.3536@nanos>
References: <CAJwLwmYQt2ae_Y-TDXhPGsX5im29ATwwKmg3FtUC=6HjrzH4HA@mail.gmail.com> <CAGXu5j+qgNMP1jt1-cssuY5qNkSPDde5MzH9YQUcuLepbHX0jg@mail.gmail.com> <alpine.DEB.2.20.1702072344520.8117@nanos>
 <CAEk6tEyzgCV5YWppu5OwxjFz6royvXmJM-Qs_mKTUSsqeR7wZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: /proc/timer_list leaks the real pids of the associated
 processes
To: Jessica Frazelle <me@jessfraz.com>
Cc: Kees Cook <keescook@google.com>, Xing Gao <xgao01@email.wm.edu>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 7 Feb 2017, Jessica Frazelle wrote:

> So I used to use this "feature" as a hack to see if something was
> running in a k8s cluster or not because fluentd gives a lot of things
> away.

That file does not tell you at all whether something is running or not. It
merily tells you that there are timers queued.

> Runc basically decided to mask this file so it stopped happening
> though. But I think namespace aware is the right decision.

Unless you can come up with a real good argument why this is usefull beyond
debugging and crystal ball hackery, it's going to go away.

Thanks,

	tglx
