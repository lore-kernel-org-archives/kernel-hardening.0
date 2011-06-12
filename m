Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 12 Jun 2011 06:39:16 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110612023916.GC14976@openwall.com>
References: <20110604132054.GC2583@openwall.com> <20110604200948.GA5850@shinshilla> <20110604205955.GA5972@openwall.com> <20110605182430.GA5789@albatros> <20110605192641.GA9240@openwall.com> <20110605194746.GA6484@albatros> <20110605201025.GA9541@openwall.com> <20110606180806.GA3986@albatros> <20110606183358.GA14711@openwall.com> <20110608172307.GA3380@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608172307.GA3380@albatros>
Subject: Re: [kernel-hardening] [RFC v2] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Wed, Jun 08, 2011 at 09:23:08PM +0400, Vasiliy Kulikov wrote:
> I think this version of the patch is ready for LKML review.

OK, post it - and CC kernel-hardening on your posting, as planned.
(We'll see if we can afford the traffic, or if we need to split this
list in two...)

Unfortunately, I don't have time to review this more closely (in
context), and no one else in here provided any comments. ;-(

> +	if (pid->hide_net &&
> +	    (!capable(CAP_NET_ADMIN) && !in_group_p(pid->pid_gid))) {

As discussed, capable() should be the very last check.

Thanks,

Alexander
