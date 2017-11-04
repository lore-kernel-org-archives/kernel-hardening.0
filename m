Date: Sat, 4 Nov 2017 18:53:46 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20171104235346.GA17170@mail.hallyn.com>
References: <20171103004436.40026-1-mahesh@bandewar.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103004436.40026-1-mahesh@bandewar.net>
Subject: [kernel-hardening] Re: [PATCH resend 2/2] userns: control capabilities of some user
 namespaces
To: Mahesh Bandewar <mahesh@bandewar.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Serge Hallyn <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <maheshb@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Mahesh Bandewar (mahesh@bandewar.net):
> Init-user-ns is always uncontrolled and a process that has SYS_ADMIN
> that belongs to uncontrolled user-ns can create another (child) user-
> namespace that is uncontrolled. Any other process (that either does
> not have SYS_ADMIN or belongs to a controlled user-ns) can only
> create a user-ns that is controlled.

That's a huge change though.  It means that any system that previously
used unprivileged containers will need new privileged code (which always
risks more privilege leaks through the new code) to re-enable what was
possible without privilege before.  That's a regression.

I'm very much interested in what you want to do,  But it seems like
it would be worth starting with some automated code analysis that shows
exactly what code becomes accessible to unprivileged users with user
namespaces which was accessible to unprivileged users before.  Then we
can reason about classifying that code and perhaps limiting access to
some of it.
