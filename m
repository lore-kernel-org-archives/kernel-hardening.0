Date: Wed, 31 May 2017 21:04:30 +1000 (AEST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <201705311941.CGD64590.MOFSOLFJtQFOVH@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.2.20.1705312102560.8015@namei.org>
References: <201705281026.EHD04622.HJFOLQFMSOtFOV@I-love.SAKURA.ne.jp>        <alpine.LRH.2.20.1705302021090.31018@namei.org>        <201705302329.IEB05735.FLJOFHSQVtOOFM@I-love.SAKURA.ne.jp>        <20170530162550.19ba1811@alans-desktop>       
 <alpine.LRH.2.20.1705310858430.6920@namei.org> <201705311941.CGD64590.MOFSOLFJtQFOVH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] LSM: Convert security_hook_heads into explicit array of
 struct list_head
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: gnomes@lxorguk.ukuu.org.uk, keescook@chromium.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, casey@schaufler-ca.com, hch@infradead.org, igor.stoppa@huawei.com, james.l.morris@oracle.com, paul@paul-moore.com, sds@tycho.nsa.gov
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 31 May 2017, Tetsuo Handa wrote:

> via lack of ability to use LKM-based LSM modules). My customers cannot afford
> enabling SELinux, but my customers cannot rebuild their kernels because
> rebuilding makes it even more difficult to get help from support centers.
> Therefore, my customers remain unable to use LSM modules which they want.
> This is really unfortunate for me.

And they'll be able to get vendor support when they have their own custom 
LSMs installed?  


-- 
James Morris
<jmorris@namei.org>
