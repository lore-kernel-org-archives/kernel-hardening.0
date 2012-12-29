Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 29 Dec 2012 09:22:34 +0400
From: Vasily Kulikov <segoon@openwall.com>
Message-ID: <20121229052234.GA4153@cachalot>
References: <20121228175627.GA7683@cachalot>
 <87wqw15wqb.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqw15wqb.fsf@xmission.com>
Subject: [kernel-hardening] Re: [PATCH/RFC] user_ns: fix missing limiting of user_ns counts
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Containers <containers@lists.linux-foundation.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 28, 2012 at 20:05 -0800, Eric W. Biederman wrote:
> Vasily Kulikov <segoon@openwall.com> writes:
> 
> > Currently there is completely no limiting in number of user namespaces
> > created by unprivileged users.  One can freely create thousands of
> > user_ns'es and exhaust kernel memory without even bumping in
> > RLIMIT_NPROC or similar.
> 
> First for a proper sense of scale it will take roughly 14,000 to consume
> a megabyte.  So it will take hundreds of millions of user namespaces to
> eat up all of kernel memory.

Yes, but you can freely create *any* number of nested userns by a loop:

    for() {
        unshare()
        write to /proc/self/{u,g}id_map
    }

> > The code needs several checks.  First, noone should be able to create
> > user_ns of arbitrary depth.  Besides kernel stack overflow one could
> > create too big depth to DoS processes belonging to other users by
> > forcing them to loop a long time in cap_capable called from some
> > ns_capable() (e.g. in case one does smth like "ls -R /proc").
> 
> Where do you get a ns_capable call from "ls -R /proc" ?

E.g. if procfs is mounted with hidepid=2 then ls does
ptrace_may_access() check. 

Thanks,

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
