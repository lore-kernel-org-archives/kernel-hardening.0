From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LRH.2.20.1702131631490.8914@namei.org>
In-Reply-To: <alpine.LRH.2.20.1702131631490.8914@namei.org>
Message-Id: <201702131933.GAF69296.FHQOOJSLOFVtFM@I-love.SAKURA.ne.jp>
Date: Mon, 13 Feb 2017 19:33:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [RFC PATCH 1/4] security: mark LSM hooks as __ro_after_init
To: jmorris@namei.org, linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

James Morris wrote:
> As the regsitration of LSMs is performed during init and then does
> not change, we can mark all of the regsitration hooks as __ro_after_init.
> 
> Signed-off-by: James Morris <james.l.morris@oracle.com>

This patch makes LKM based LSMs (e.g. AKARI) impossible.
I'm not happy with this patch.
