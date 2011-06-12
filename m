Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 12 Jun 2011 06:28:33 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110612022833.GB14976@openwall.com>
References: <20110609141745.GA11957@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609141745.GA11957@albatros>
Subject: Re: [kernel-hardening] rlimit_nproc check
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy -

On Thu, Jun 09, 2011 at 06:17:45PM +0400, Vasiliy Kulikov wrote:
> I found 8-years old patch that enables RLIMIT_NPROC check at setuid (and
> similar) calls:
> 
> http://lkml.org/lkml/2003/7/13/226
> 
> So, checking it on execve() is a bit redundant.  But it means that
> setuid() may fail if it follows setrlimit() call and the target user
> has already reached the limit (asserted on the test C program).  If the
> limit is defined in pam_limit, the attack becomes real.

Right.  Dealing with setuid() failing to drop privs yet returning, which
many apps don't expect, is definitely something we (you) need to do
under this project.  In Linux 2.4.x-ow, I simply do:

--- linux-2.4.37.9.orig/kernel/sys.c	2010-02-01 21:04:46 +0000
+++ linux-2.4.37.9/kernel/sys.c	2010-02-18 14:04:42 +0000
@@ -514,8 +514,10 @@ static int set_user(uid_t new_ruid, int 
 	struct user_struct *new_user;
 
 	new_user = alloc_uid(new_ruid);
-	if (!new_user)
+	if (!new_user) {
+		force_sig(SIGSEGV, current);
 		return -EAGAIN;
+	}
 	switch_uid(new_user);
 
 	if(dumpclear)

As an option, you could propose to revert that 8-year old change and
introduce the check on execve().  Unrealistic?

The requirements are:

1. setuid(2) must not fail and return, when it was invoked with
"appropriate privileges".  If it fails, it must not return.

This suggests that it should not fail very often, so maybe the
RLIMIT_NPROC check does not belong there.

2. The setuid-execve sequence should not successfully start the new
program when that would exceed RLIMIT_NPROC for the target UID.

Oh, by the way, here's what I found:

Subject: [PATCH] sched: Don't allow setuid to succeed if the user does not have rt bandwidth
http://lists.openwall.net/linux-kernel/2009/02/27/177

Thanks,

Alexander
