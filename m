MIME-Version: 1.0
References: <20180926203446.2004-1-casey.schaufler@intel.com> <20180926203446.2004-2-casey.schaufler@intel.com>
In-Reply-To: <20180926203446.2004-2-casey.schaufler@intel.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 26 Sep 2018 23:16:35 +0200
Message-ID: <CAG48ez1xu_WJi5_UZvrTO_H6o=DHRvm5LMp_jg=GauLbpkYARg@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] AppArmor: Prepare for PTRACE_MODE_SCHED
Content-Type: text/plain; charset="UTF-8"
To: Casey Schaufler <casey.schaufler@intel.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Dave Hansen <dave.hansen@intel.com>, deneen.t.dock@intel.com, kristen@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Sep 26, 2018 at 10:35 PM Casey Schaufler
<casey.schaufler@intel.com> wrote:
> A ptrace access check with mode PTRACE_MODE_SCHED gets called
> from process switching code. This precludes the use of audit,
> as the locking is incompatible. Don't do audit in the PTRACE_MODE_SCHED
> case.

Why is this separate from PTRACE_MODE_NOAUDIT? It looks like
apparmor_ptrace_access_check() currently ignores PTRACE_MODE_NOAUDIT.
Could you, instead of adding a new flag, fix the handling of
PTRACE_MODE_NOAUDIT?

> Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
> ---
>  security/apparmor/domain.c      | 2 +-
>  security/apparmor/include/ipc.h | 2 +-
>  security/apparmor/ipc.c         | 8 +++++---
>  security/apparmor/lsm.c         | 5 +++--
>  4 files changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
> index 08c88de0ffda..28300f4c3ef9 100644
> --- a/security/apparmor/domain.c
> +++ b/security/apparmor/domain.c
> @@ -77,7 +77,7 @@ static int may_change_ptraced_domain(struct aa_label *to_label,
>         if (!tracer || unconfined(tracerl))
>                 goto out;
>
> -       error = aa_may_ptrace(tracerl, to_label, PTRACE_MODE_ATTACH);
> +       error = aa_may_ptrace(tracerl, to_label, PTRACE_MODE_ATTACH, true);
>
>  out:
>         rcu_read_unlock();
> diff --git a/security/apparmor/include/ipc.h b/security/apparmor/include/ipc.h
> index 5ffc218d1e74..299d1c45fef0 100644
> --- a/security/apparmor/include/ipc.h
> +++ b/security/apparmor/include/ipc.h
> @@ -34,7 +34,7 @@ struct aa_profile;
>         "xcpu xfsz vtalrm prof winch io pwr sys emt lost"
>
>  int aa_may_ptrace(struct aa_label *tracer, struct aa_label *tracee,
> -                 u32 request);
> +                 u32 request, bool audit);
>  int aa_may_signal(struct aa_label *sender, struct aa_label *target, int sig);
>
>  #endif /* __AA_IPC_H */
> diff --git a/security/apparmor/ipc.c b/security/apparmor/ipc.c
> index 527ea1557120..9ed110afc822 100644
> --- a/security/apparmor/ipc.c
> +++ b/security/apparmor/ipc.c
> @@ -121,15 +121,17 @@ static int profile_tracer_perm(struct aa_profile *tracer,
>   * Returns: %0 else error code if permission denied or error
>   */
>  int aa_may_ptrace(struct aa_label *tracer, struct aa_label *tracee,
> -                 u32 request)
> +                 u32 request, bool audit)
>  {
>         struct aa_profile *profile;
>         u32 xrequest = request << PTRACE_PERM_SHIFT;
>         DEFINE_AUDIT_DATA(sa, LSM_AUDIT_DATA_NONE, OP_PTRACE);
>
>         return xcheck_labels(tracer, tracee, profile,
> -                       profile_tracer_perm(profile, tracee, request, &sa),
> -                       profile_tracee_perm(profile, tracer, xrequest, &sa));
> +                       profile_tracer_perm(profile, tracee, request,
> +                                           audit ? &sa : NULL),
> +                       profile_tracee_perm(profile, tracer, xrequest,
> +                                           audit ? &sa : NULL));
>  }
>
>
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index 8b8b70620bbe..da9d0b228857 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -118,7 +118,8 @@ static int apparmor_ptrace_access_check(struct task_struct *child,
>         tracee = aa_get_task_label(child);
>         error = aa_may_ptrace(tracer, tracee,
>                         (mode & PTRACE_MODE_READ) ? AA_PTRACE_READ
> -                                                 : AA_PTRACE_TRACE);
> +                                                 : AA_PTRACE_TRACE,
> +                       !(mode & PTRACE_MODE_SCHED));
>         aa_put_label(tracee);
>         end_current_label_crit_section(tracer);
>
> @@ -132,7 +133,7 @@ static int apparmor_ptrace_traceme(struct task_struct *parent)
>
>         tracee = begin_current_label_crit_section();
>         tracer = aa_get_task_label(parent);
> -       error = aa_may_ptrace(tracer, tracee, AA_PTRACE_TRACE);
> +       error = aa_may_ptrace(tracer, tracee, AA_PTRACE_TRACE, true);
>         aa_put_label(tracer);
>         end_current_label_crit_section(tracee);
>
> --
> 2.17.1
>
