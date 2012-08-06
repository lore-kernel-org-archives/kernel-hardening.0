Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1344264832.27828.65.camel@twins>
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 06 Aug 2012 16:53:52 +0200
In-Reply-To: <1344000593-18794-1-git-send-email-richard@nod.at>
References: <1344000593-18794-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0
Subject: [kernel-hardening] Re: [PATCH] Revert "futex: Mark get_robust_list as deprecated"
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, dvhart@linux.intel.com, paul.gortmaker@windriver.com, jkosina@suse.cz, rob@landley.net, Randy Dunlap <rdunlap@xenotime.net>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, "Serge E.
 Hallyn" <serge.hallyn@canonical.com>, kernel-hardening@lists.openwall.com, spender@grsecurity.net, keescook@chromium.org, tglx@linutronix.de, Cyrill Gorcunov <gorcunov@openvz.org>, xemul@parallels.com, stable@vger.kernel.org, #@programming.kicks-ass.net, 3.4.x@programming.kicks-ass.net
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2012-08-03 at 15:29 +0200, Richard Weinberger wrote:
> get_robust_list has at least two valid use cases.
> 1. checkpoint/restore in userspace
> 2. post mortem analysis=20

Shouldn't this then also be added as a comment somewhere near the
implementation to avoid a repeat of this deprecate / undeprecate cycle?
