From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1495883858-3336-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
	<CAGXu5jJ045iaDfoW+2dXU+U-KhfnNH1WX5ngUW9dHyS5Yn3EGg@mail.gmail.com>
	<201705281026.EHD04622.HJFOLQFMSOtFOV@I-love.SAKURA.ne.jp>
	<alpine.LRH.2.20.1705302021090.31018@namei.org>
In-Reply-To: <alpine.LRH.2.20.1705302021090.31018@namei.org>
Message-Id: <201705302329.IEB05735.FLJOFHSQVtOOFM@I-love.SAKURA.ne.jp>
Date: Tue, 30 May 2017 23:29:10 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH] LSM: Convert security_hook_heads into explicit array of struct list_head
To: jmorris@namei.org
Cc: keescook@chromium.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, casey@schaufler-ca.com, hch@infradead.org, igor.stoppa@huawei.com, james.l.morris@oracle.com, paul@paul-moore.com, sds@tycho.nsa.gov
List-ID: <kernel-hardening.lists.openwall.com>

James Morris wrote:
> On Sun, 28 May 2017, Tetsuo Handa wrote:
> 
> > can afford enabling". And we know that we cannot merge all security modules
> > into mainline. Thus, allowing LKM-based LSM modules is inevitable.
> 
> Nope, it's not inevitable.  The LSM API only caters to in-tree users.
> 
> I'm not sure why you persist against this.

Then, we are willing to accept LSM modules with users less than 10, aren't we?
Forcing users to patch and recompile is as heartless as forcing CONFIG_MODULES=n.
