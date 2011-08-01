Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 1 Aug 2011 23:03:41 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110801190341.GA6898@albatros>
References: <20110801180151.GA26686@albatros>
 <20110801112021.25ec9041.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801112021.25ec9041.akpm@linux-foundation.org>
Subject: Re: [kernel-hardening] Re: initcall dependency problem (ns vs.
 threads)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, torvalds@linux-foundation.org, Marc Zyngier <maz@misterjones.org>
List-ID: <kernel-hardening.lists.openwall.com>

> Are we talking about init_ipc_ns.ids[] here?  If so, did you try
> initializing the three rwsems at compile-time?
> 
> That's rather a nasty hack though.  It'd be better to run the mystery
> init function before starting the threads.

Looks like it solves the race.  However, I think it should be solved on
another level.  Other bugs might be hidden with this race.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
