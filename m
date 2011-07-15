Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 15 Jul 2011 10:31:13 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110715063113.GA3166@albatros>
References: <20110712132723.GA3193@albatros>
 <CA+55aFysXOeBqEvmVbuqL3i0jRFDcE=vDuVhmYL38XQ0+x=deQ@mail.gmail.com>
 <20110713091408.0d456352@notabene.brown>
 <20110713063142.GA19976@openwall.com>
 <20110713170657.59dae548@notabene.brown>
 <CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com>
 <alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
 <20110714112751.1bfd998f@notabene.brown>
 <20110714150602.GA30019@openwall.com>
 <20110715133013.4fa38d19@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715133013.4fa38d19@notabene.brown>
Subject: Re: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from
 set_user() to do_execve_common()
To: kernel-hardening@lists.openwall.com
Cc: Solar Designer <solar@openwall.com>, James Morris <jmorris@namei.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

Neil,

On Fri, Jul 15, 2011 at 13:30 +1000, NeilBrown wrote:
> I'm still bothers that the proposed patch can cause exec to fail for an
> separate 'innocent' process.
> It also seems to 'hide' the problem - just shuffling code around.
> The comment in do_execve_common helps.  A similar comment in set_user
> wouldn't hurt.
> 
> But what do you think of this.  It sure that only the process which ignored
> the return value from setuid is inconvenienced.

I don't like it.  You're mixing the main problem and an RLIMIT check
enforcement.  The main goal is denying setuid() to fail unless there is not
enough privileges, RLIMIT in execve() is just an *attempt* to still count
NPROC in *some* widespread cases.  But you're trying to fix setuid()
where RLIMIT accounting is simple :\

Your patch doesn't address the core issue in this situation:

    setuid(); /* it fails because of RLIMIT */
    do_some_fs();
    execve();

do_some_fs() should be called ONLY if root is dropped.  In your scheme
the process may interact with FS as root while thinking it is nonroot,
which almost always leads to privilege escalation.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
