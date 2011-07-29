Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 29 Jul 2011 12:06:13 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110729080613.GA2488@albatros>
References: <20110721140936.632d2c8b@notabene.brown>
 <20110721124830.GA1325@openwall.com>
 <CA+55aFy4ybatb0McQr2f4A56ympZVLqK2sbp2=73idu58_4RxQ@mail.gmail.com>
 <20110721193939.GA3914@openwall.com>
 <20110725171423.GA3739@albatros>
 <20110725234013.GB24110@openwall.com>
 <20110726104713.37273143@notabene.brown>
 <20110726011629.GA24610@openwall.com>
 <20110726141118.32f948e0@notabene.brown>
 <20110726144848.GA7133@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726144848.GA7133@albatros>
Subject: [kernel-hardening] Re: [patch v2] move RLIMIT_NPROC check from set_user() to
 do_execve_common()
To: kernel-hardening@lists.openwall.com
Cc: Solar Designer <solar@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 26, 2011 at 18:48 +0400, Vasiliy Kulikov wrote:
>  	if (atomic_read(&new_user->processes) >= rlimit(RLIMIT_NPROC) &&
> -			new_user != INIT_USER) {
> -		free_uid(new_user);
> -		return -EAGAIN;
> -	}
> +			new_user != INIT_USER)
> +		current->flags |= PF_NPROC_EXCEEDED;

It doesn't respect the chain: setresuid() with exceeded rlimit to user A,
setresuid() with normal limit to user B.  While being user B, the PF is
kept, which is wrong as it is not B's exceeded limit.  So, it must be
cleared on successful set_user() calls.  I'll send a patch.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
