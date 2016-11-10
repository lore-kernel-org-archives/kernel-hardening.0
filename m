Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 10 Nov 2016 22:09:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161110210921.GA3142@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-2-git-send-email-elena.reshetova@intel.com>
 <CAEXv5_gvcpY0K3MeJUVHo4199X=9=UnH7UDttresd_eBrVFi7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_gvcpY0K3MeJUVHo4199X=9=UnH7UDttresd_eBrVFi7g@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC v4 PATCH 01/13] Add architecture independent hardened
 atomic base
To: David Windsor <dwindsor@gmail.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, will.deacon@arm.com, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

On Thu, Nov 10, 2016 at 03:41:19PM -0500, David Windsor wrote:
> The work done by this series adds overflow protection to existing
> kernel atomic_t users.
> 
> In the initial upstream submission, do we want to include my series
> which extends HARDENED_ATOMIC protection to cover additional kernel
> reference counters, which are currently integers (and thus
> unprotected):
> 
>  * struct fs_struct.users
>  * struct tty_port.count
>  * struct tty_ldisc_ops.refcount
>  * struct pipe_inode_info.{readers|writers|files|waiting_writers}
>  * struct kmem_cache.refcount
> 
> I can see arguments both for and against including new HARDENED_ATOMIC
> users in the initial upstream RFC.  Personally, I think it might be
> more appropriate to add new HARDENED_ATOMIC users in subsequent RFCs,
> after the original feature is merged.
> 
> In case folks are interested, I submitted this as an RFC, which can be
> found here: http://www.openwall.com/lists/kernel-hardening/2016/10/29/1

Be sure to submit this to a tiny list and not Cc the people who work on
this stuff.

> 
> The code itself can be found here:
> https://github.com/ereshetova/linux-stable/tree/hardened_atomic_next_expanded

I'm far too busy to go look at random places of the intartubes.
