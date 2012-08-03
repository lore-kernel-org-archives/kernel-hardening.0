Reply-To: kernel-hardening@lists.openwall.com
Sender: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Fri, 3 Aug 2012 17:34:38 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
Message-ID: <20120803133438.GE11952@moon>
References: <1344000593-18794-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344000593-18794-1-git-send-email-richard@nod.at>
Subject: [kernel-hardening] Re: [PATCH] Revert "futex: Mark get_robust_list as deprecated"
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, dvhart@linux.intel.com, paul.gortmaker@windriver.com, jkosina@suse.cz, rob@landley.net, Randy Dunlap <rdunlap@xenotime.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, kernel-hardening@lists.openwall.com, spender@grsecurity.net, keescook@chromium.org, tglx@linutronix.de, xemul@parallels.com, stable@vger.kernel.org, #3.4.x@moon.localdomain
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 03, 2012 at 03:29:53PM +0200, Richard Weinberger wrote:
> get_robust_list has at least two valid use cases.
> 1. checkpoint/restore in userspace
> 2. post mortem analysis
> 
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Darren Hart <dvhart@linux.intel.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
> Cc: kernel-hardening@lists.openwall.com
> Cc: spender@grsecurity.net
> Cc: keescook@chromium.org
> Cc: tglx@linutronix.de
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: xemul@parallels.com
> Cc: <stable@vger.kernel.org> # 3.4.x
> Cc: <stable@vger.kernel.org> # 3.5.x
> Link: http://lkml.kernel.org/r/CAFLxGvzPVPyXPwjay4a01q1vx4K4Ht56bHjzswYrr1wvB_1dYw%20%28%29%20mail%20!%20gmail%20!%20com
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

Thanks, Richard!
