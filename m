Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Nov 2016 11:29:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161111102913.GE3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-13-git-send-email-elena.reshetova@intel.com>
 <20161110204046.GW3117@twins.programming.kicks-ass.net>
 <20161110225031.GA26751@worktop>
 <CAGXu5j+yy8Y=_bDhsTgEugJnN5=u8_XMSOAnqJBab-1+9v8+CA@mail.gmail.com>
 <20161110233004.GQ3568@worktop.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41BFF727@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BFF727@IRSMSX102.ger.corp.intel.com>
Subject: [kernel-hardening] Re: [RFC v4 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 11, 2016 at 09:32:45AM +0000, Reshetova, Elena wrote:
> It is covered in the documentation file (Documentation/security/
> hardened-atomic.txt) included in the first patch.
> There are just so many details that including them all in commit
> messages will produce pages long commit messages, so some
> things are moved to the documentation only. 

No, never skimp on Changelogs. Nobody reads documentation.

Also, this really should also have a very explicit code comment,
non-atomic constructs in atomic.h are 'surprising' at the very least.

> >Now is this harmless? If you have two increments racing like:
> 
> 	  inc
> 	  jno 1 // overflow
> 
> 			  inc
> 			  jno 1 // !overflow
> 
> 	  dec
> 	1:		1:
> 
> >The second thread will still affect your wrap and not BUG.

This still wants an answer, because attackers never exploit races?

> >I have a benchmark somewhere, I can run numbers tomorrow, but it
> >really shows once you get a bit of contention going. Once you hit 4
> >nodes contending on a variable its completely out there IIRC.

> This would help to get more numbers on this, thank you. 

		LOCK addl		LOCK cmpxchg-addl

1-node		1: 22.038250		1: 41.572270
		2: 174.019700           2: 198.965635
		3: 185.852060           3: 274.293927
		4: 389.169783           4: 266.738485
		6: 347.827897           6: 454.785715
		8: 369.649510           8: 463.125426


2-nodes		2: 428.448130		2: 1422.221850
		4: 616.203497           4: 1166.427205
		6: 855.639025           6: 1424.131080
		8: 1083.613291          8: 1402.484560

4-nodes		 4: 1180.591315		 4: 1830.301125
		 8: 1480.023056          8: 2043.418720
		16: 2602.128429         16: 2611.188079


Results are in cycles:u, average of 100000 loops.

As measured on a 4 socket IVB-EX (E7-4890 v2).

> >The unconditional atomic ops really are loads faster than cmpxchg
> >loops.
> 
> Yes, and this is what we saw when doing performance measurements. So,
> as a result we went with a faster method, which we believed still has
> a low risk of getting into race.  If you numbers prove otherwise, then
> we have to reconsider. 

Its fundamentally a question of semantics though. These are _atomic_
ops, they really should be, well, atomic. No exceptions.

If you want to play funny games, don't call them atomic.
