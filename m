Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1344000593-18794-1-git-send-email-richard@nod.at>
References: <1344000593-18794-1-git-send-email-richard@nod.at>
Date: Fri, 3 Aug 2012 10:17:44 -0700
Message-ID: <CAGXu5jLGd2gcut25RBaiHg+xVivQuvNYdbSDT4uGVk=ym3oTGQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH] Revert "futex: Mark get_robust_list as deprecated"
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, dvhart@linux.intel.com, paul.gortmaker@windriver.com, jkosina@suse.cz, rob@landley.net, Randy Dunlap <rdunlap@xenotime.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, kernel-hardening@lists.openwall.com, spender@grsecurity.net, tglx@linutronix.de, Cyrill Gorcunov <gorcunov@openvz.org>, xemul@parallels.com, "# 3.4.x" <stable@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 3, 2012 at 6:29 AM, Richard Weinberger <richard@nod.at> wrote:
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

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
