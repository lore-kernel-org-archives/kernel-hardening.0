Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 30 Jun 2011 17:08:02 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110630130802.GA12620@albatros>
References: <20110622152514.GA9521@albatros>
 <20110629151436.9be479fb.akpm@linux-foundation.org>
 <20110630092103.GA4252@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110630092103.GA4252@albatros>
Subject: [kernel-hardening] Re: [RFC] ipc: introduce shm_rmid_forced sysctl
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, Randy Dunlap <rdunlap@xenotime.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 30, 2011 at 13:21 +0400, Vasiliy Kulikov wrote:
> > Perhaps shm_rmid_forced should have had bool type.
> 
> OK.  The sysctl handler should parse it OK if feed it with sizeof(bool).

I was wrong, maxlen must not be less than sizeof(int), it makes sense
for arrays only.  So, it is kept being int.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
