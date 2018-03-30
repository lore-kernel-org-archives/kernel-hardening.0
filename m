Date: Fri, 30 Mar 2018 10:34:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [v2] ftrace: drop a VLA in module_exists()
Message-ID: <20180330103411.5ed25f43@gandalf.local.home>
In-Reply-To: <1522399988-8815-1-git-send-email-s.mesoraca16@gmail.com>
References: <1522399988-8815-1-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 30 Mar 2018 10:53:08 +0200
Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:

Couple of things. First, "PATCH" was dropped from the subject. If my
inbox was busy today, I probably would have missed this email.

> Avoid a VLA[1] by using a real constant expression instead of a variable.
> The compiler should be able to optimize the original code and avoid using
> an actual VLA. Anyway this change is useful because it will avoid a false
> positive with -Wvla, it might also help the compiler generating better
> code.
> 
> [1] https://lkml.org/lkml/2018/3/7/621

Second, do not use lkml.org, use http://lkml.kernel.org/r/<messageid>

Search for "Link:" tags in git log to see examples.

Other than that, the patch looks fine to me and I can pull it for the
next merge window.

-- Steve

> 
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> ---
>  kernel/trace/ftrace.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index eac9ce2..16bbf06 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3902,14 +3902,13 @@ static bool module_exists(const char *module)
>  {
>  	/* All modules have the symbol __this_module */
>  	const char this_mod[] = "__this_module";
> -	const int modname_size = MAX_PARAM_PREFIX_LEN + sizeof(this_mod) + 1;
> -	char modname[modname_size + 1];
> +	char modname[MAX_PARAM_PREFIX_LEN + sizeof(this_mod) + 2];
>  	unsigned long val;
>  	int n;
>  
> -	n = snprintf(modname, modname_size + 1, "%s:%s", module, this_mod);
> +	n = snprintf(modname, sizeof(modname), "%s:%s", module, this_mod);
>  
> -	if (n > modname_size)
> +	if (n > sizeof(modname) - 1)
>  		return false;
>  
>  	val = module_kallsyms_lookup_name(modname);
