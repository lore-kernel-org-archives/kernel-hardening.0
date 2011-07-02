Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 2 Jul 2011 21:31:36 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110702173136.GF26232@openwall.com>
References: <20110622152514.GA9521@albatros> <20110629151436.9be479fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629151436.9be479fb.akpm@linux-foundation.org>
Subject: [kernel-hardening] Re: [RFC] ipc: introduce shm_rmid_forced sysctl
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 29, 2011 at 03:14:36PM -0700, Andrew Morton wrote:
> What a horrid patch.  But given the POSIX (mis?)feature I don't see a
> better way, and the feature seems desirable.  Sigh.
> 
> What sort of users would want to turn this on, and why?

Originally, I introduced it into Linux 2.0.x-ow to allow for resource
limits to be enforced on shared servers, such as with shared web
hosting.  A user is supposed to be limited by RLIMIT_AS * RLIMIT_NPROC.
(This is awfully inflexible, lacking a separate per-user memory limit,
but at least it's something.)  However, with shared memory segments a
user could bypass that limit, because those segments don't have to be
tied to a process.  So the patch changed that, requiring that any shm
segment be tied to a process, or be destroyed.

Alexander
