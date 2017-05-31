References: <1495883858-3336-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <1496003387-3184-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <alpine.LRH.2.20.1705302025110.31018@namei.org>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <27e537cc-1d1c-1a48-d3fd-a04921f7b620@huawei.com>
Date: Wed, 31 May 2017 23:49:34 +0300
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.20.1705302025110.31018@namei.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] LSM: Convert security_hook_heads into explicit array
 of struct list_head
To: James Morris <jmorris@namei.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Casey Schaufler <casey@schaufler-ca.com>, Christoph Hellwig <hch@infradead.org>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-ID: <kernel-hardening.lists.openwall.com>

On 30/05/17 13:32, James Morris wrote:

> This seems like pointless churn in security-critical code in anticipation 
> of features which are still in development and may not be adopted.
> 
> Is there a compelling reason to merge this now? (And I don't mean worrying 
> about non-existent compliers).

I propose to take this patch as part of those I will be submitting.
It took me some unplanned time to add support for hardened user copy,
but now it's done - at least to a point that I can test it without failures.

So I'm back on track to provide an example of the smalloc api and I can
also use Tetsuo's work (thanks again, btw).
This patch would be sandwiched between the smalloc ones and the LSM rework.

It can get merged when the rest (hopefully) is merged.

But I have a more prosaic question: since smalloc is affecting the
memory subsystem, can it still be merged through the security tree?

---
thanks, igor
