MIME-Version: 1.0
In-Reply-To: <20171104235346.GA17170@mail.hallyn.com>
References: <20171103004436.40026-1-mahesh@bandewar.net> <20171104235346.GA17170@mail.hallyn.com>
From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= <maheshb@google.com>
Date: Sun, 5 Nov 2017 23:23:33 -0800
Message-ID: <CAF2d9jg1tZz-hnVBeXm3geq7jSBt5v5w6+p5B1V-7huS4qbMBA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH resend 2/2] userns: control capabilities of some user namespaces
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 4, 2017 at 4:53 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
>
> Quoting Mahesh Bandewar (mahesh@bandewar.net):
> > Init-user-ns is always uncontrolled and a process that has SYS_ADMIN
> > that belongs to uncontrolled user-ns can create another (child) user-
> > namespace that is uncontrolled. Any other process (that either does
> > not have SYS_ADMIN or belongs to a controlled user-ns) can only
> > create a user-ns that is controlled.
>
> That's a huge change though.  It means that any system that previously
> used unprivileged containers will need new privileged code (which always
> risks more privilege leaks through the new code) to re-enable what was
> possible without privilege before.  That's a regression.
>
I wouldn't call it a regression since the existing behavior is
preserved as it is if the default-mask is not altered. i.e.
uncontrolled process can create user-ns and have full control inside
that user-ns. The only difference is - as an example if 'something'
comes up which makes a specific capability expose ring-0, so admin can
quickly remove the capability in question from the mask, so that no
untrusted code can exploit that capability until either the kernel is
patched or workloads are sanitized keeping in mind what was
discovered. (I have given some real life example vulnerabilities
published recently about CAP_NET_RAW in the cover letter)

> I'm very much interested in what you want to do,  But it seems like
> it would be worth starting with some automated code analysis that shows
> exactly what code becomes accessible to unprivileged users with user
> namespaces which was accessible to unprivileged users before.  Then we
> can reason about classifying that code and perhaps limiting access to
> some of it.
I would like to look at this as 'a tool' that is available to admins
who can quickly take possible-compromise-situation under-control
probably at the cost of some functionality-loss until kernel is
patched and the mask is restored to default value.

I'm not sure if automated tools could discover anything since these
changes should not alter behavior in any way.
