From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201705302329.IEB05735.FLJOFHSQVtOOFM@I-love.SAKURA.ne.jp>
	<20170530162550.19ba1811@alans-desktop>
	<alpine.LRH.2.20.1705310858430.6920@namei.org>
	<201705311941.CGD64590.MOFSOLFJtQFOVH@I-love.SAKURA.ne.jp>
	<alpine.LRH.2.20.1705312102560.8015@namei.org>
In-Reply-To: <alpine.LRH.2.20.1705312102560.8015@namei.org>
Message-Id: <201705312031.JFG24680.HQFtMJOLOOFSFV@I-love.SAKURA.ne.jp>
Date: Wed, 31 May 2017 20:31:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH] LSM: Convert security_hook_heads into explicit array of struct list_head
To: jmorris@namei.org
Cc: gnomes@lxorguk.ukuu.org.uk, keescook@chromium.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, casey@schaufler-ca.com, hch@infradead.org, igor.stoppa@huawei.com, james.l.morris@oracle.com, paul@paul-moore.com, sds@tycho.nsa.gov
List-ID: <kernel-hardening.lists.openwall.com>

James Morris wrote:
> On Wed, 31 May 2017, Tetsuo Handa wrote:
> 
> > via lack of ability to use LKM-based LSM modules). My customers cannot afford
> > enabling SELinux, but my customers cannot rebuild their kernels because
> > rebuilding makes it even more difficult to get help from support centers.
> > Therefore, my customers remain unable to use LSM modules which they want.
> > This is really unfortunate for me.
> 
> And they'll be able to get vendor support when they have their own custom 
> LSMs installed?  

As long as customers are using the vmlinux provided by that distributor, they
can get distributor's support regarding problems which are not caused by use of
their own custom LKM-based LSMs. For example, distributors do not unconditionally
reject due to use of storage driver kernel module provided by hardware venders
(or, their servers won't boot) and/or on-access scanner kernel module provided by
antivirus venders. Customers won't be able to get distributor's support regarding
problems caused by use of storage driver / on-access scanner kernel modules not
provided by distributors. But rebuilding the vmlinux in order to use LSM modules
not enabled by distributors makes customer's situation very worse.
