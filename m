Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20120323190855.GA27213@www.outflux.net>
References: <alpine.LFD.2.02.1203231926000.2542@ionos>
	<20120323190855.GA27213@www.outflux.net>
Date: Tue, 27 Mar 2012 14:05:24 -0400
Message-ID: <CA+5PVA5FR_QoTtNVV04VXrjOujAMFHMXF4-GnyZHLPUGnvb3zA@mail.gmail.com>
From: Josh Boyer <jwboyer@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2] futex: mark get_robust_list as deprecated
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Darren Hart <dvhart@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 23, 2012 at 3:08 PM, Kees Cook <keescook@chromium.org> wrote:
> Notify get_robust_list users that the syscall is going away.
>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
> =A0- add note to feature-removal-schedule.txt.
> ---
> =A0Documentation/feature-removal-schedule.txt | =A0 10 ++++++++++
> =A0kernel/futex.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 | =A0 =A02 ++
> =A0kernel/futex_compat.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
 =A02 ++
> =A03 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/f=
eature-removal-schedule.txt
> index 4bfd982..e3bf119 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -543,3 +543,13 @@ When: =A0 =A0 =A03.5
> =A0Why: =A0 The old kmap_atomic() with two arguments is deprecated, we on=
ly
> =A0 =A0 =A0 =A0keep it for backward compatibility for few cycles and then=
 drop it.
> =A0Who: =A0 Cong Wang <amwang@redhat.com>
> +
> +----------------------------
> +
> +What: =A0get_robust_list syscall
> +When: =A02013
> +Why: =A0 There appear to be no production users of the get_robust_list s=
yscall,
> + =A0 =A0 =A0 and it runs the risk of leaking address locations, allowing=
 the bypass
> + =A0 =A0 =A0 of ASLR. It was only ever intended for debugging, so it sho=
uld be
> + =A0 =A0 =A0 removed.
> +Who: =A0 Kees Cook <keescook@chromium.org>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index d701be5..e2b0fb9 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2449,6 +2449,8 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
> =A0 =A0 =A0 =A0if (!futex_cmpxchg_enabled)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOSYS;
>
> + =A0 =A0 =A0 WARN_ONCE(1, "deprecated: get_robust_list will be deleted i=
n 2013.\n");
> +

Do you really need WARN_ONCE?  It's going to spew a backtrace if this
is called, and that is going to cause various auto-bug reporters to file
bugs as well.  There's nothing that can be done with those bugs other
than to wait until this is removed.  Maybe it won't trigger because
nobody is using it, but ugh.

Is printk_once sufficient?

josh
