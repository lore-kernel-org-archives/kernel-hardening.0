Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 1 Aug 2011 12:07:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20110801120750.5c0e6d2b.akpm@linux-foundation.org>
In-Reply-To: <20110801190341.GA6898@albatros>
References: <20110801180151.GA26686@albatros>
	<20110801112021.25ec9041.akpm@linux-foundation.org>
	<20110801190341.GA6898@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: initcall dependency problem (ns vs.
 threads)
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, torvalds@linux-foundation.org, Marc Zyngier <maz@misterjones.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 1 Aug 2011 23:03:41 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> > Are we talking about init_ipc_ns.ids[] here?  If so, did you try
> > initializing the three rwsems at compile-time?
> > 
> > That's rather a nasty hack though.  It'd be better to run the mystery
> > init function before starting the threads.
> 
> Looks like it solves the race.

What patch are you talking about here?

>  However, I think it should be solved on
> another level.

What level?

>  Other bugs might be hidden with this race.

What bugs?
