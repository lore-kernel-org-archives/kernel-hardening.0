Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Fri, 16 Dec 2016 23:45:42 +0100
MIME-Version: 1.0
Message-ID: <58546E96.16770.2C23F1B4@pageexec.freemail.hu>
In-reply-to: <1481925984-98605-2-git-send-email-keescook@chromium.org>
References: <1481925984-98605-1-git-send-email-keescook@chromium.org>, <1481925984-98605-2-git-send-email-keescook@chromium.org>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH v4 1/4] gcc-plugins: Add the initify gcc plugin
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, spender@grsecurity.net, mmarek@suse.com, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, sam@ravnborg.org
List-ID: <kernel-hardening.lists.openwall.com>

On 16 Dec 2016 at 14:06, Kees Cook wrote:

> diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
> index 950fd2e64bb7..369bfb471e58 100644
> --- a/scripts/gcc-plugins/gcc-common.h
> +++ b/scripts/gcc-plugins/gcc-common.h
> @@ -287,6 +287,26 @@ static inline struct cgraph_node *cgraph_next_function_with_gimple_body(struct c
>   return NULL;
>  }
> 
> +static inline bool cgraph_for_node_and_aliases(cgraph_node_ptr node,
> +				bool (*callback)(cgraph_node_ptr, void *),
> +				void *data, bool include_overwritable)
> +{
> +	cgraph_node_ptr alias;
> +
> +	if (callback(node, data))
> +		return true;
> +
> +	for (alias = node->same_body; alias; alias = alias->next) {
> +		if (include_overwritable ||
> +			cgraph_function_body_availability(alias) > AVAIL_OVERWRITABLE)
> +			if (cgraph_for_node_and_aliases(alias, callback, data,
> +							include_overwritable))
> +				return true;
> +	}
> +
> +	return false;
> +}
> +
>  #define FOR_EACH_FUNCTION_WITH_GIMPLE_BODY(node) \
>   for ((node) = cgraph_first_function_with_gimple_body(); (node); \
>    (node) = cgraph_next_function_with_gimple_body(node))

this hunk above and...

> @@ -674,6 +707,14 @@ static inline cgraph_node_ptr cgraph_alias_target(cgraph_node_ptr node)
>   return node->get_alias_target();
>  }
> 
> +static inline bool cgraph_for_node_and_aliases(cgraph_node_ptr node,
> +				bool (*callback)(cgraph_node_ptr, void *),
> +				void *data, bool include_overwritable)
> +{
> +	return node->call_for_symbol_thunks_and_aliases(callback, data,
> +							include_overwritable);
> +}
> +
>  static inline struct cgraph_node_hook_list *cgraph_add_function_insertion_hook(cgraph_node_hook hook, void *data)
>  {
>   return symtab->add_cgraph_insertion_hook(hook, data);

...this one aren't needed by any plugins upstream so maybe introduce them when
the needed arises? and the whole patch against gcc-common.h would also conflict
with the version i maintain and that you said you'd sync to so there's a decision
to be made regarding how this will is to be maintained...
