Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 22 Jun 2011 14:17:24 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110622101724.GA4278@albatros>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
 <20110621153102.762557f3.akpm@linux-foundation.org>
 <20110622064545.GA3605@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622064545.GA3605@albatros>
Subject: [kernel-hardening] Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount
 options
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, Alexey Dobriyan <adobriyan@gmail.com>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 22, 2011 at 10:45 +0400, Vasiliy Kulikov wrote:
> More generic solution (I'm not suggesting it, but merely discussing)
> would use some user-supplied set of files to restrict access to (or,
> better, the set of allowed files because white list is almost always
> better than black list).  Maybe this one:
> 
>     mount -t proc -o "pid_allow=exe,status,comm,oom_*" proc /proc
> 
> And without pid_allow it would behave like pid_allow=*.

>  "pid_allow=."
> would deny access to the whole /proc/PID.

I mean "pid_allow=", of course.

> This would be a bit inconsistent with current permissions because e.g.
> if use pid_allow=environ then environ file would not be accessible
> because of posix permissions.  Hierarchical mode (pid_allow=fd/1) is not
> allowed too.

For hierarchical mode: attr_allowed, tgid_allowed, tid_allowed.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
