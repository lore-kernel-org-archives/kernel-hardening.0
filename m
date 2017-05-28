From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1495883858-3336-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
	<42691278-5b9a-16f1-0636-e766c6d648fb@schaufler-ca.com>
In-Reply-To: <42691278-5b9a-16f1-0636-e766c6d648fb@schaufler-ca.com>
Message-Id: <201705280938.IAH43233.OJLHOSOFFMFQtV@I-love.SAKURA.ne.jp>
Date: Sun, 28 May 2017 09:38:13 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH] LSM: Convert security_hook_heads into explicit array of struct list_head
To: casey@schaufler-ca.com, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, hch@infradead.org, igor.stoppa@huawei.com, james.l.morris@oracle.com, keescook@chromium.org, paul@paul-moore.com, sds@tycho.nsa.gov
List-ID: <kernel-hardening.lists.openwall.com>

Casey Schaufler wrote:
> > But currently, LSM_HOOK_INIT() macro depends on the address of
> > security_hook_heads being known at compile time. If we use an enum
> > so that LSM_HOOK_INIT() macro does not need to know absolute address of
> > security_hook_heads, it will help us to use that allocator for LSM hooks.
> >
> > As a result of introducing an enum, security_hook_heads becomes a local
> > variable, making it easier to allocate security_hook_heads at run time.
> 
> You loose the type checking in security.c. This is the same
> objection I had before to this approach. It's why I objected
> to 3dfc9b02864b19f4 and why I didn't adopt the array approach
> in the first place. If it's so important that randstruct not
> complain about the unnatural cast, revert the patch that
> introduced it. I see no net benefit in hiding the symbol over
> loosing the typing. You trade a list of typed function
> pointers for an enumerated list of values. It doesn't even
> make the code look smaller!

I still cannot understand what you are referring by "type checking".
Please explain me what the type checking in security/security.c is.
