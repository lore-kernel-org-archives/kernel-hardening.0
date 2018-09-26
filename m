MIME-Version: 1.0
References: <20180926203446.2004-1-casey.schaufler@intel.com> <20180926203446.2004-3-casey.schaufler@intel.com>
In-Reply-To: <20180926203446.2004-3-casey.schaufler@intel.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 26 Sep 2018 23:30:35 +0200
Message-ID: <CAG48ez3_XJYCURiCurDeCousGguGUdPego30j5+UF8FebWxUtA@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] Smack: Prepare for PTRACE_MODE_SCHED
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
>
> Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
> ---
>  security/smack/smack_lsm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 340fc30ad85d..ffa95bcab599 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -422,7 +422,8 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
>         struct task_smack *tsp;
>         struct smack_known *tracer_known;
>
> -       if ((mode & PTRACE_MODE_NOAUDIT) == 0) {
> +       if ((mode & PTRACE_MODE_NOAUDIT) == 0 &&
> +           (mode & PTRACE_MODE_SCHED) == 0) {

If you ORed PTRACE_MODE_NOAUDIT into the flags when calling the
security hook, you could drop this patch, right?
