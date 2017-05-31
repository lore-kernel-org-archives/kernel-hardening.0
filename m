Date: Wed, 31 May 2017 15:43:17 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170531154317.4f487300@alans-desktop>
In-Reply-To: <201705311941.CGD64590.MOFSOLFJtQFOVH@I-love.SAKURA.ne.jp>
References: <201705281026.EHD04622.HJFOLQFMSOtFOV@I-love.SAKURA.ne.jp>
	<alpine.LRH.2.20.1705302021090.31018@namei.org>
	<201705302329.IEB05735.FLJOFHSQVtOOFM@I-love.SAKURA.ne.jp>
	<20170530162550.19ba1811@alans-desktop>
	<alpine.LRH.2.20.1705310858430.6920@namei.org>
	<201705311941.CGD64590.MOFSOLFJtQFOVH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] LSM: Convert security_hook_heads into explicit array of
 struct list_head
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jmorris@namei.org, keescook@chromium.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, casey@schaufler-ca.com, hch@infradead.org, igor.stoppa@huawei.com, james.l.morris@oracle.com, paul@paul-moore.com, sds@tycho.nsa.gov
List-ID: <kernel-hardening.lists.openwall.com>

> I saw several companies who ship their embedded devices with
> single-function LSM modules (e.g. restrict only mount operation and
> ptrace operation). What is unfortunate is that their LSM modules had
> never been proposed for upstream, and thus bugs remained unnoticed.

So which of them cannot be done with seccomp ? We have a small tight
interface for simple things like restricting a few calls.
 
> via lack of ability to use LKM-based LSM modules). My customers cannot afford
> enabling SELinux, but my customers cannot rebuild their kernels because
> rebuilding makes it even more difficult to get help from support centers.

And "I've loaded this third party module" doesn't ?

Alan
