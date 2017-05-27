From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
	<1495829844-69341-6-git-send-email-keescook@chromium.org>
	<20170527084135.GA26844@infradead.org>
	<CAGXu5j+SA8N6s7StQX1OQsNf6YeQBkS7vSFVN7MR=BzJMwJH9Q@mail.gmail.com>
In-Reply-To: <CAGXu5j+SA8N6s7StQX1OQsNf6YeQBkS7vSFVN7MR=BzJMwJH9Q@mail.gmail.com>
Message-Id: <201705280704.DHF73450.SJtVOFOOQHFLMF@I-love.SAKURA.ne.jp>
Date: Sun, 28 May 2017 07:04:25 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH v2 05/20] randstruct: Whitelist struct security_hook_heads cast
To: keescook@chromium.org, hch@infradead.org
Cc: kernel-hardening@lists.openwall.com, james.l.morris@oracle.com, labbott@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook wrote:
> On Sat, May 27, 2017 at 1:41 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, May 26, 2017 at 01:17:09PM -0700, Kees Cook wrote:
> >> The LSM initialization routines walk security_hook_heads as an array
> >> of struct list_head instead of via names to avoid a ton of needless
> >> source. Whitelist this to avoid the false positive warning from the
> >> plugin:
> >
> > I think this crap just needs to be fixed properly.  If not it almost
> > defeats the protections as the "security" ops are just about everywhere.
> 
> There's nothing unsafe about 3dfc9b02864b19f4dab376f14479ee4ad1de6c9e,
> it just avoids tons of needless code. Tetsuo has some other ideas for
> cleaning it up further, but I don't like it because it removes
> compile-time verification of function types.

Excuse me, but why you think that compile-time verification of function
types is removed?

-	{ .head = &security_hook_heads.HEAD, .hook = { .HEAD = HOOK } }
+	{ .idx = LSM_##HEAD, .hook = { .HEAD = HOOK } }

This change removes dependency on absolute address of security_hook_heads
being known at compile-time. If function types of .hook.HEAD and HOOK
mismatches, the compiler can still warn it.
