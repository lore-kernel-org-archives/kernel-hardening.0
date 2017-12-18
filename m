Date: Mon, 18 Dec 2017 11:49:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171218114947.2c11211a@gandalf.local.home>
In-Reply-To: <1513554812-13014-4-git-send-email-me@tobin.cc>
References: <1513554812-13014-1-git-send-email-me@tobin.cc>
	<1513554812-13014-4-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/3] trace: print address if symbol not found
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 18 Dec 2017 10:53:32 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:

> Fixes behaviour modified by: commit bd6b239cdbb2 ("kallsyms: don't leak
> address when symbol not found")
> 
> Previous patch changed behaviour of kallsyms function sprint_symbol() to
> return an error code instead of printing the address if a symbol was not
> found. Ftrace relies on the original behaviour. We should not break
> tracing when applying the previous patch. We can maintain the original
> behaviour by checking the return code on calls to sprint_symbol() and
> friends.
> 
> Check return code and print actual address on error (i.e symbol not
> found).
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>  kernel/trace/trace.h             | 24 ++++++++++++++++++++++++
>  kernel/trace/trace_events_hist.c |  6 +++---
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 2a6d0325a761..881b1a577d75 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -1814,4 +1814,28 @@ static inline void trace_event_eval_update(struct trace_eval_map **map, int len)
>  
>  extern struct trace_iterator *tracepoint_print_iter;
>  
> +static inline int
> +trace_sprint_symbol(char *buffer, unsigned long address)
> +{
> +	int ret;
> +
> +	ret = sprint_symbol(buffer, address);
> +	if (ret == -1)
> +		ret = sprintf(buffer, "0x%lx", address);
> +
> +	return ret;
> +}
> +
> +static inline int
> +trace_sprint_symbol_no_offset(char *buffer, unsigned long address)
> +{
> +	int ret;
> +
> +	ret = sprint_symbol_no_offset(buffer, address);
> +	if (ret == -1)
> +		ret = sprintf(buffer, "0x%lx", address);
> +
> +	return ret;
> +}
> +
>  #endif /* _LINUX_KERNEL_TRACE_H */
> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index 1e1558c99d56..3e28522a76f4 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -982,7 +982,7 @@ static void hist_trigger_stacktrace_print(struct seq_file *m,
>  			return;
>  
>  		seq_printf(m, "%*c", 1 + spaces, ' ');
> -		sprint_symbol(str, stacktrace_entries[i]);
> +		trace_sprint_symbol_addr(str, stacktrace_entries[i]);

Hmm, where is trace_sprint_symbol_addr() defined?

-- Steve

>  		seq_printf(m, "%s\n", str);
>  	}
>  }
> @@ -1014,12 +1014,12 @@ hist_trigger_entry_print(struct seq_file *m,
>  			seq_printf(m, "%s: %llx", field_name, uval);
>  		} else if (key_field->flags & HIST_FIELD_FL_SYM) {
>  			uval = *(u64 *)(key + key_field->offset);
> -			sprint_symbol_no_offset(str, uval);
> +			trace_sprint_symbol_no_offset(str, uval);
>  			seq_printf(m, "%s: [%llx] %-45s", field_name,
>  				   uval, str);
>  		} else if (key_field->flags & HIST_FIELD_FL_SYM_OFFSET) {
>  			uval = *(u64 *)(key + key_field->offset);
> -			sprint_symbol(str, uval);
> +			trace_sprint_symbol(str, uval);
>  			seq_printf(m, "%s: [%llx] %-55s", field_name,
>  				   uval, str);
>  		} else if (key_field->flags & HIST_FIELD_FL_EXECNAME) {
