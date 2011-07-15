Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 15 Jul 2011 07:35:05 +0200
From: Willy Tarreau <w@1wt.eu>
Message-ID: <20110715053505.GA24870@1wt.eu>
References: <20110712132723.GA3193@albatros> <CA+55aFysXOeBqEvmVbuqL3i0jRFDcE=vDuVhmYL38XQ0+x=deQ@mail.gmail.com> <20110713091408.0d456352@notabene.brown> <20110713063142.GA19976@openwall.com> <20110713170657.59dae548@notabene.brown> <CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com> <alpine.LRH.2.00.1107141009510.17067@tundra.namei.org> <20110714112751.1bfd998f@notabene.brown> <20110714150602.GA30019@openwall.com> <20110715133013.4fa38d19@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715133013.4fa38d19@notabene.brown>
Subject: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from set_user() to do_execve_common()
To: NeilBrown <neilb@suse.de>
Cc: Solar Designer <solar@openwall.com>, James Morris <jmorris@namei.org>, Linus Torvalds <torvalds@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, kernel-hardening@lists.openwall.com, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Neil,

On Fri, Jul 15, 2011 at 01:30:13PM +1000, NeilBrown wrote:
(...)
> But what do you think of this.  It sure that only the process which ignored
> the return value from setuid is inconvenienced.
(...)

I think this is a smart idea. But will the flag be inherited by children
over a fork() ? If not, we might as well block fork(), because we can
expect a lot of fork+exec situations which are as dangerous as the simple
execve().

Regards,
Willy
