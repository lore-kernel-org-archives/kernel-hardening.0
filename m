Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1469630746-32279-1-git-send-email-jeffv@google.com>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 27 Jul 2016 13:43:09 -0700
Message-ID: <CAGXu5jJ9A=dB7RqLnGkd_Gfwa00jYyeSMz5+CFy+SFzLf6VWQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Jeff Vander Stoep <jeffv@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 27, 2016 at 7:45 AM, Jeff Vander Stoep <jeffv@google.com> wrote:
> When kernel.perf_event_paranoid is set to 3 (or greater), disallow
> all access to performance events by users without CAP_SYS_ADMIN.
>
> This new level of restriction is intended to reduce the attack
> surface of the kernel. Perf is a valuable tool for developers but
> is generally unnecessary and unused on production systems. Perf may
> open up an attack vector to vulnerable device-specific drivers as
> recently demonstrated in CVE-2016-0805, CVE-2016-0819,
> CVE-2016-0843, CVE-2016-3768, and CVE-2016-3843. This new level of
> restriction allows for a safe default to be set on production systems
> while leaving a simple means for developers to grant access [1].
>
> This feature is derived from CONFIG_GRKERNSEC_PERF_HARDEN by Brad
> Spengler. It is based on a patch by Ben Hutchings [2]. Ben's patches
> have been modified and split up to address on-list feedback.
>
> kernel.perf_event_paranoid=3 is the default on both Debian [2] and
> Android [3].
>
> [1] Making perf available to developers on Android:
> https://android-review.googlesource.com/#/c/234400/
> [2] Original patch by Ben Hutchings:
> https://lkml.org/lkml/2016/1/11/587
> [3] https://android-review.googlesource.com/#/c/234743/
>
> Signed-off-by: Jeff Vander Stoep <jeffv@google.com>

Thanks for splitting this up! It'll be nice to have this delta out of
Debian and Android.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  Documentation/sysctl/kernel.txt | 1 +
>  include/linux/perf_event.h      | 5 +++++
>  kernel/events/core.c            | 4 ++++
>  3 files changed, 10 insertions(+)
>
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index ffab8b5..fac9798 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -665,6 +665,7 @@ users (without CAP_SYS_ADMIN).  The default value is 2.
>  >=0: Disallow raw tracepoint access by users without CAP_IOC_LOCK
>  >=1: Disallow CPU event access by users without CAP_SYS_ADMIN
>  >=2: Disallow kernel profiling by users without CAP_SYS_ADMIN
> +>=3: Disallow all event access by users without CAP_SYS_ADMIN
>
>  ==============================================================
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 8ed43261..1e2080f 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1156,6 +1156,11 @@ static inline bool perf_paranoid_kernel(void)
>         return sysctl_perf_event_paranoid > 1;
>  }
>
> +static inline bool perf_paranoid_any(void)
> +{
> +       return sysctl_perf_event_paranoid > 2;
> +}
> +
>  extern void perf_event_init(void);
>  extern void perf_tp_event(u16 event_type, u64 count, void *record,
>                           int entry_size, struct pt_regs *regs,
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 356a6c7..52bd100 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -353,6 +353,7 @@ static struct srcu_struct pmus_srcu;
>   *   0 - disallow raw tracepoint access for unpriv
>   *   1 - disallow cpu events for unpriv
>   *   2 - disallow kernel profiling for unpriv
> + *   3 - disallow all unpriv perf event use
>   */
>  int sysctl_perf_event_paranoid __read_mostly = 2;
>
> @@ -9296,6 +9297,9 @@ SYSCALL_DEFINE5(perf_event_open,
>         if (flags & ~PERF_FLAG_ALL)
>                 return -EINVAL;
>
> +       if (perf_paranoid_any() && !capable(CAP_SYS_ADMIN))
> +                               return -EACCES;
> +
>         err = perf_copy_attr(attr_uptr, &attr);
>         if (err)
>                 return err;
> --
> 2.8.0.rc3.226.g39d4020
>



-- 
Kees Cook
Chrome OS & Brillo Security
