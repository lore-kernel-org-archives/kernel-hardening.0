Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 24 Jul 2011 22:02:31 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110724180231.GA5134@albatros>
References: <20110715133013.4fa38d19@notabene.brown>
 <20110715063113.GA3166@albatros>
 <20110715170650.585f1dad@notabene.brown>
 <20110715073823.GA3821@albatros>
 <1310738313.30257.27.camel@moss-pluto>
 <20110715152641.GA6286@albatros>
 <1310759683.30257.123.camel@moss-pluto>
 <20110721140936.632d2c8b@notabene.brown>
 <20110721124830.GA1325@openwall.com>
 <20110724143231.GA18453@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724143231.GA18453@openwall.com>
Subject: Re: [kernel-hardening] [PATCH] move RLIMIT_NPROC check from
 set_user() to do_execve_common()
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sun, Jul 24, 2011 at 18:32 +0400, Solar Designer wrote:
> On Thu, Jul 21, 2011 at 04:48:30PM +0400, Solar Designer wrote:
> > Here's my current proposal:
> > 
> > 1. Apply Vasiliy's patch to move the RLIMIT_NPROC check from setuid() to
> > execve(), optionally enhanced with setting PF_SETUSER_FAILED on
> > would-be-failed setuid() and checking this flag in execve() (in addition
> > to repeating the RLIMIT_NPROC check).
> > 
> > 2. With a separate patch, add a prctl() to read the PF_SETUSER_FAILED flag.
> > Android will be able to use this if it wants to.
> 
> Can you please implement these two patches and post them to LKML?
> (Include the PF_SETUSER_FAILED implementation in the first patch.)

I think (2) is too compicated.  IIRC, application already may read
process flags via procfs.  I'll prepare and test (1).

Thanks,

-- 
Vasiliy
