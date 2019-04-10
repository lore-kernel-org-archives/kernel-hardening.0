MIME-Version: 1.0
References: <20190410011418.76408-1-joel@joelfernandes.org>
In-Reply-To: <20190410011418.76408-1-joel@joelfernandes.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 10 Apr 2019 09:26:44 -0700
Message-ID: <CAGXu5jKs6Ag2L+GYEVYAzPky1pLntZt-Tc5ki-pqjVoyCWgxxg@mail.gmail.com>
Subject: Re: [PATCH 1/2] module: Prepare for addition of new ro_after_init sections
Content-Type: text/plain; charset="UTF-8"
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, rcu@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Android Kernel Team <kernel-team@android.com>, Kees Cook <keescook@chromium.org>, Jessica Yu <jeyu@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 9, 2019 at 6:14 PM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> For the purposes of hardening modules by adding sections to
> ro_after_init sections, prepare for addition of new ro_after_init
> entries which we do in future patches. Create a table to which new
> entries could be added later. This makes it less error prone and reduce
> code duplication.
>
> Cc: paulmck@linux.vnet.ibm.com
> Cc: rostedt@goodmis.org
> Cc: mathieu.desnoyers@efficios.com
> Cc: rcu@vger.kernel.org
> Cc: kernel-hardening@lists.openwall.com
> Cc: kernel-team@android.com
> Suggested-by: keescook@chromium.org
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>
> ---
>  kernel/module.c | 42 ++++++++++++++++++++++++------------------
>  1 file changed, 24 insertions(+), 18 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 524da609c884..f9221381d076 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3300,11 +3300,28 @@ static bool blacklisted(const char *module_name)
>  }
>  core_param(module_blacklist, module_blacklist, charp, 0400);
>
> +/*
> + * Mark ro_after_init section with SHF_RO_AFTER_INIT so that
> + * layout_sections() can put it in the right place.
> + * Note: ro_after_init sections also have SHF_{WRITE,ALLOC} set.
> + */
> +static char *ro_after_init_sections[] = {

static const char * const ... Need to make sure the table and its
strings can't be changed. :)

> +       ".data..ro_after_init",
> +
> +       /*
> +        * __jump_table structures are never modified, with the exception of
> +        * entries that refer to code in the __init section, which are
> +        * annotated as such at module load time.
> +        */
> +       "__jump_table",
> +       NULL

Since this table is known at build time, you don't need a NULL
terminator, you can use ARRAY_SIZE() instead.

> +};
> +
>  static struct module *layout_and_allocate(struct load_info *info, int flags)
>  {
>         struct module *mod;
>         unsigned int ndx;
> -       int err;
> +       int err, i;
>
>         err = check_modinfo(info->mod, info, flags);
>         if (err)
> @@ -3319,23 +3336,12 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>         /* We will do a special allocation for per-cpu sections later. */
>         info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
>
> -       /*
> -        * Mark ro_after_init section with SHF_RO_AFTER_INIT so that
> -        * layout_sections() can put it in the right place.
> -        * Note: ro_after_init sections also have SHF_{WRITE,ALLOC} set.
> -        */
> -       ndx = find_sec(info, ".data..ro_after_init");
> -       if (ndx)
> -               info->sechdrs[ndx].sh_flags |= SHF_RO_AFTER_INIT;
> -       /*
> -        * Mark the __jump_table section as ro_after_init as well: these data
> -        * structures are never modified, with the exception of entries that
> -        * refer to code in the __init section, which are annotated as such
> -        * at module load time.
> -        */
> -       ndx = find_sec(info, "__jump_table");
> -       if (ndx)
> -               info->sechdrs[ndx].sh_flags |= SHF_RO_AFTER_INIT;
> +       /* Set sh_flags for read-only after init sections */
> +       for (i = 0; ro_after_init_sections[i]; i++) {

i.e. for (i = 0; i < ARRAY_SIZE(ro_after_init_sections); i++)

> +               ndx = find_sec(info, ro_after_init_sections[i]);
> +               if (ndx)
> +                       info->sechdrs[ndx].sh_flags |= SHF_RO_AFTER_INIT;
> +       }
>
>         /* Determine total sizes, and put offsets in sh_entsize.  For now
>            this is done generically; there doesn't appear to be any

Otherwise, yeah, looks good to me.

-- 
Kees Cook
