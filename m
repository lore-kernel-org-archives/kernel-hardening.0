Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jul 2011 18:17:31 +1000 (EST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <20110729081156.GB2488@albatros>
Message-ID: <alpine.LRH.2.00.1107291815410.15102@tundra.namei.org>
References: <20110721124830.GA1325@openwall.com> <CA+55aFy4ybatb0McQr2f4A56ympZVLqK2sbp2=73idu58_4RxQ@mail.gmail.com> <20110721193939.GA3914@openwall.com> <20110725171423.GA3739@albatros> <20110725234013.GB24110@openwall.com> <20110726104713.37273143@notabene.brown>
 <20110726011629.GA24610@openwall.com> <20110726141118.32f948e0@notabene.brown> <20110726144848.GA7133@albatros> <20110729080613.GA2488@albatros> <20110729081156.GB2488@albatros>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [patch v3] move RLIMIT_NPROC check from set_user() to
 do_execve_common()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com, Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 29 Jul 2011, Vasiliy Kulikov wrote:

> +	 * RLIMIT_NPROC limits on user->processes have already been checked
> +	 * in set_user().
>  	 */
> +
>  	alter_cred_subscribers(new, 2);

Please get rid of the extra blank line if you re-spin.


Reviewed-by: James Morris <jmorris@namei.org>



-- 
James Morris
<jmorris@namei.org>
