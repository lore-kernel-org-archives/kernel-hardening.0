Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 9 Nov 2011 13:06:34 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111109090634.GA3418@albatros>
References: <20111105104828.GA3489@albatros>
 <20111108115900.GA14587@albatros>
 <20111108151752.b2e37741.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108151752.b2e37741.akpm@linux-foundation.org>
Subject: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/$PID/{sched,schedstat}
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>, Alexey Dobriyan <adobriyan@gmail.com>, security@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 08, 2011 at 15:17 -0800, Andrew Morton wrote:
> > On Sat, Nov 05, 2011 at 14:48 +0400, Vasiliy Kulikov wrote:
> > > /proc/$PID/{sched,schedstat} contain debugging scheduler counters, which
> > > should not be world readable.  They may be used to gather private information
> > > about processes' activity.  E.g. it can be used to count the number of
> > > characters typed in gksu dialog:
> > > 
> > > http://www.openwall.com/lists/oss-security/2011/11/05/3
> > > 
> > > This infoleak is similar to io (1d1221f375c) and stat's eip/esp (f83ce3e6b02d)
> > > infoleaks.  Probably other 0644/0444 procfs files are vulnerable to
> > > similar infoleaks.
> 
> Grumble.
> 
> The obvious issue with this patch is its non-back-compatibility.  What
> existing code will break, in what manner and what is the seriousness of
> the breakage?
> 
> You *know* this is the main issue, yet you didn't address it at all! 
> You just leave the issue out there for other people to work out, and to
> ask the obvious questions.
> 
> This happens over and over and I'm getting rather tired of the charade.
> 
> So I'm going to ignore this patch and I ask that you and other security
> people never do this again.
> 
> If you're going to submit a patch which you know will change kernel
> interfaces in a non-backward-compatible fashion then don't just pretend
> that it didn't happen!  Please provide us with a complete description
> of the breakage and at least some analysis of the downstream
> implications of the change.  So that we are better able to decide
> whether the security improvements justify the disruption.

I'm sorry it looked like I didn't test the patch, but I really didn't
face to any breakage (top, ps, gnome monitor).  The actual problem is
that the patch is still incomplete - all proc monitoring tools watch for
/proc/$PID/stat file content changes, not /proc/$PID/sched.
/proc/$PID/stat contains the same sched information, which I've missed.
Restricting "stat" does break these tools.

/proc/$PID/stat already has "fake" fields like KSTK_EIP() and KSTK_ESP().
We can continue to do such sort of force fields zeroing, which doesn't
break ABI.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
