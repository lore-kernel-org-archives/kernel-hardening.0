Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 3 Jul 2011 22:00:28 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110703180028.GA26742@albatros>
References: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org>
 <20110630134855.GA6165@mail.hallyn.com>
 <20110630135718.GA13406@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110630135718.GA13406@albatros>
Subject: [kernel-hardening] Re: + ipc-introduce-shm_rmid_forced-sysctl.patch added to -mm tree
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, oleg@redhat.com, rdunlap@xenotime.net, tj@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 30, 2011 at 17:57 +0400, Vasiliy Kulikov wrote:
> > So shp should store a reference to the struct pid, which you can check
> > here?  I think that'll do exactly what you need.
> 
> Documentation/namespaces/compatibility-list.txt says that IPC and PID
> namespaces have not been fully separated yet.

Looks like I've misunderstood the documentation.  It says that
identifiers from the same ipc namespace shouldn't travel between
different pid namespaces, not about incomplete implementaiton.   So yes,
storing pid or task will help.  I'll send a patch after some testing.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
