Date: Wed, 19 Jun 2019 10:24:30 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v1 12/22] docs: driver-api: add .rst files from the main
 dir
Message-ID: <20190619102430.558a775e@coco.lan>
In-Reply-To: <20190619121308.GA6284@openwall.com>
References: <cover.1560890771.git.mchehab+samsung@kernel.org>
	<b0d24e805d5368719cc64e8104d64ee9b5b89dd0.1560890772.git.mchehab+samsung@kernel.org>
	<20190619114356.GP3419@hirez.programming.kicks-ass.net>
	<20190619114551.GQ3463@hirez.programming.kicks-ass.net>
	<20190619115007.GR3463@hirez.programming.kicks-ass.net>
	<20190619121308.GA6284@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Solar Designer <solar@openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Em Wed, 19 Jun 2019 14:13:08 +0200
Solar Designer <solar@openwall.com> escreveu:

> On Wed, Jun 19, 2019 at 01:50:07PM +0200, Peter Zijlstra wrote:
> > Also, cross-posting to moderated lists is rude.  
> 
> It's even worse with partially-pre-moderated lists, because then list
> moderators are forced to either accept all the mostly off-topic messages
> (as some follow-ups from other lists would get through anyway, and would
> be out of context if a message in a thread were rejected) or switch the
> list to fully pre-moderated with no exceptions for anyone (and then it's
> more work and greater delays on desirable messages).
> 
> I already brought this up with Mauro off-list, and I hope we'll see no
> more of these threads on kernel-hardening, but we'll have to let the
> rest of already started threads through.

I'll take care on a next review to explicitly remove kernel-hardening.

As I pointed in priv, as gcc-plugins file is listed at MAINTAINERS,
except if someone actively remove kernel-hardening ML from 
get_maintainers.pl results, you'll likely keep receiving e-mails with
patches that will be touching it.

> I think this has significant negative effect on the kernel-hardening
> project, shifting it further towards and beyond security circus (to
> non-security circus now) and thereby discouraging desirable
> contributions, whereas the (one relevant) file rename is unimportant
> (and buried in lots of other renames).

Sorry for that.

Thanks,
Mauro
