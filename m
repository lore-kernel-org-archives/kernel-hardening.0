MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1520970663-19633-1-git-send-email-s.mesoraca16@gmail.com>
References: <1520970663-19633-1-git-send-email-s.mesoraca16@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 26 Mar 2018 16:16:23 -0700
Message-ID: <CAGXu5jJ=46_1DiWg=0aKzOo1+kxL9vemLFi11brn-+iY6cgZMw@mail.gmail.com>
Subject: Re: [PATCH] ftrace: drop a VLA in module_exists()
Content-Type: text/plain; charset="UTF-8"
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 13, 2018 at 12:51 PM, Salvatore Mesoraca
<s.mesoraca16@gmail.com> wrote:
> Avoid a VLA[1] by using a real constant expression instead of a variable.
> The compiler should be able to optimize the original code and avoid using
> an actual VLA. Anyway this change is useful because it will avoid a false
> positive with -Wvla, it might also help the compiler generating better
> code.
>
> [1] https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> ---
>  kernel/trace/ftrace.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index eac9ce2..adebb92 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3902,14 +3902,13 @@ static bool module_exists(const char *module)
>  {
>         /* All modules have the symbol __this_module */
>         const char this_mod[] = "__this_module";
> -       const int modname_size = MAX_PARAM_PREFIX_LEN + sizeof(this_mod) + 1;
> -       char modname[modname_size + 1];
> +       char modname[MAX_PARAM_PREFIX_LEN + sizeof(this_mod) + 1];

Actually, I think this needs to be "+ 2" (":" and NULL).

>         unsigned long val;
>         int n;
>
> -       n = snprintf(modname, modname_size + 1, "%s:%s", module, this_mod);
> +       n = snprintf(modname, sizeof(modname), "%s:%s", module, this_mod);
>
> -       if (n > modname_size)
> +       if (n > sizeof(modname) - 1)
>                 return false;
>
>         val = module_kallsyms_lookup_name(modname);

Otherwise, looks good!

-Kees

-- 
Kees Cook
Pixel Security
