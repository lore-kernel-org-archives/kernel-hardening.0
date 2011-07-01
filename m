Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 1 Jul 2011 15:18:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20110701151827.7061dcda@lxorguk.ukuu.org.uk>
In-Reply-To: <20110701120453.GA28008@elte.hu>
References: <20110622152514.GA9521@albatros>
	<20110629151436.9be479fb.akpm@linux-foundation.org>
	<20110701112534.GG20990@elte.hu>
	<20110701113533.GA19945@albatros>
	<20110701120453.GA28008@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC] ipc: introduce shm_rmid_forced sysctl
To: Ingo Molnar <mingo@elte.hu>
Cc: Vasiliy Kulikov <segoon@openwall.com>, solar@openwall.com, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

> As we really prefer working systems over non-working ones (and lots 
> of unattached shm segments can clearly result in a non-working 
> system) we can only accept the "this will break stuff" argument if 
> it's *demonstrated* to break stuff and if the failure scenario is 
> carefully described in the commit.
> 
> It would take a serious breakage to override a "system locks up 
> swapping itself to death" failure scenario.

Ths shared memory interface is defined to be persistent for good reason
and all sorts of apps rely upon that so no you can't just ignore that. As
a configurable alternative it makes sense (indeed many SYS5 admins used
to run shared memory segment sweepers to clean up long idle ones)

However if it's locking the machine up and not being properly handled by
resource management then

a) your resource management is broken so fix that instead
b) if your resource management is busted or you are not properly
tracking resource commits then the user is going to be able to achieve the
same result by other means (eg a unix domain socket bomb)

If you've got no overcommit set you shouldn't be able to swap to death,
it may be the sysv shared memory objects need to be accounted for
specifically somewhere but that would be the right thing to fix and the
mechanisms to do it exist.
