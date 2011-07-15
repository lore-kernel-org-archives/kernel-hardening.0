Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 15 Jul 2011 19:26:41 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110715152641.GA6286@albatros>
References: <20110713170657.59dae548@notabene.brown>
 <CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com>
 <alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
 <20110714112751.1bfd998f@notabene.brown>
 <20110714150602.GA30019@openwall.com>
 <20110715133013.4fa38d19@notabene.brown>
 <20110715063113.GA3166@albatros>
 <20110715170650.585f1dad@notabene.brown>
 <20110715073823.GA3821@albatros>
 <1310738313.30257.27.camel@moss-pluto>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310738313.30257.27.camel@moss-pluto>
Subject: Re: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from
 set_user() to do_execve_common()
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: NeilBrown <neilb@suse.de>, kernel-hardening@lists.openwall.com, Solar Designer <solar@openwall.com>, James Morris <jmorris@namei.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Stephen,

On Fri, Jul 15, 2011 at 09:58 -0400, Stephen Smalley wrote:
> Does this have implications for Android's zygote model?  There you have
> a long running uid 0 / all caps process (the zygote), which forks itself
> upon receiving a request to spawn an app and then calls

> setgroups();
> setrlimit(); setgid(); setuid();

Is RLIMIT_NPROC forced in your model and setuid() is expected to fail
because of NPROC exceeding?  If no, then it is not touched at all.

> Also, can't setuid() fail under other conditions, e.g. ENOMEM upon
> prepare_creds() allocation failure?  Is it ever reasonable for a program
> to not check setuid() for failure?  Certainly there are plenty of
> examples of programs not doing that, but it isn't clear that this is a
> bug in the kernel.

This thing is better to discuss separately, after the patch is applied.
Shorter, in current implementation it is not possible as mm layer tries
to alloc small structures (less than 8 pages) indefinitely.  cred and
user_struct are less than 64kb, so ENOMEM is impossible.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
