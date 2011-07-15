Reply-To: kernel-hardening@lists.openwall.com
From: Stephen Smalley <sds@tycho.nsa.gov>
In-Reply-To: <20110715152641.GA6286@albatros>
References: <20110713170657.59dae548@notabene.brown>
	 <CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com>
	 <alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
	 <20110714112751.1bfd998f@notabene.brown>
	 <20110714150602.GA30019@openwall.com>
	 <20110715133013.4fa38d19@notabene.brown> <20110715063113.GA3166@albatros>
	 <20110715170650.585f1dad@notabene.brown> <20110715073823.GA3821@albatros>
	 <1310738313.30257.27.camel@moss-pluto>  <20110715152641.GA6286@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 15:54:43 -0400
Message-ID: <1310759683.30257.123.camel@moss-pluto>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from
 set_user() to do_execve_common()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: NeilBrown <neilb@suse.de>, kernel-hardening@lists.openwall.com, Solar Designer <solar@openwall.com>, James Morris <jmorris@namei.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2011-07-15 at 19:26 +0400, Vasiliy Kulikov wrote:
> Hi Stephen,
> 
> On Fri, Jul 15, 2011 at 09:58 -0400, Stephen Smalley wrote:
> > Does this have implications for Android's zygote model?  There you have
> > a long running uid 0 / all caps process (the zygote), which forks itself
> > upon receiving a request to spawn an app and then calls
> 
> > setgroups();
> > setrlimit(); setgid(); setuid();
> 
> Is RLIMIT_NPROC forced in your model and setuid() is expected to fail
> because of NPROC exceeding?  If no, then it is not touched at all.

I don't know what their intent is.  But it is an example of a case where
moving the enforcement from setuid() to a subsequent execve() causes the
check to never get applied.  As to whether or not they care, I don't
know.  An app that calls fork() repeatedly will still be stopped, but an
app that repeatedly connects to the zygote and asks to spawn another
instance of itself would be unlimited.

OTOH, the current RLIMIT_NPROC check and lack of setuid() error checking
has been a repeated issue for Android.

-- 
Stephen Smalley
National Security Agency
