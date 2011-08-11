Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 11 Aug 2011 21:18:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110811171812.GA17346@albatros>
References: <20110808150204.GA4252@albatros>
 <20110809121632.18aef937@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809121632.18aef937@notabene.brown>
Subject: Re: [kernel-hardening] Re: [PATCH v3 -resend] move RLIMIT_NPROC
 check from set_user() to do_execve_common()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Linus,

On Tue, Aug 09, 2011 at 12:16 +1000, NeilBrown wrote:
> On Mon, 8 Aug 2011 19:02:04 +0400 Vasiliy Kulikov <segoon@openwall.com> wrote:
> 
> > The patch http://lkml.org/lkml/2003/7/13/226 introduced an RLIMIT_NPROC
> > check in set_user() to check for NPROC exceeding via setuid() and
> > similar functions.  Before the check there was a possibility to greatly
> > exceed the allowed number of processes by an unprivileged user if the
> > program relied on rlimit only.  But the check created new security
> > threat: many poorly written programs simply don't check setuid() return
> > code and believe it cannot fail if executed with root privileges.  So,
> > the check is removed in this patch because of too often privilege
> > escalations related to buggy programs.
...
> > Reviewed-by: James Morris <jmorris@namei.org>
> Acked-by: NeilBrown <neilb@suse.de>

It got 2 positive feedbacks and seems nobody has better solution.
Is it possible to see it in 3.1?

Thanks!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
