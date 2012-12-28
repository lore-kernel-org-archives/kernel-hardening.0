Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Dec 2012 18:43:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20121228184334.GZ4939@ZenIV.linux.org.uk>
References: <20121228175627.GA7683@cachalot>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121228175627.GA7683@cachalot>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH/RFC] user_ns: fix missing limiting of user_ns counts
To: Vasily Kulikov <segoon@openwall.com>
Cc: Containers <containers@lists.linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Serge Hallyn <serge.hallyn@canonical.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 28, 2012 at 09:56:27PM +0400, Vasily Kulikov wrote:
> The included patch is a basic fix for both or them.  Both values are
> hardcoded here to 100 max depth and 1000 max in total.  I'm not sure how
> better to make them configurable.  Looks like it needs some sysctl value
> like kernel.max_user_ns_per_user, but also something more configurable
> like new rlimit'ish limit may be created for user_ns needs.  E.g. in
> case root wants one user to contain hundreds of private containers
> (container owner user), but he doesn't want anybody to fill the kernel
> with hundreds of containers multiplied by number of system users (equals
> to thousands).

I'm sorry, but this is not a solution.  Kernel is not x86-only; there are
architectures with far bigger minimal stack frame size.  E.g. on sparc64
every fucking stack frame is at least 176 bytes.  So your 100 calls deep
call chain will happily overflow the damn stack all by itself - kernel
stack on sparc64 is 16Kb total, including struct thread_info living there.
