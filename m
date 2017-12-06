References: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
 <1512516827-29797-3-git-send-email-alex.popov@linux.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <15d83270-7a91-436f-1aab-0f6001954f4a@redhat.com>
Date: Wed, 6 Dec 2017 10:57:19 -0800
MIME-Version: 1.0
In-Reply-To: <1512516827-29797-3-git-send-email-alex.popov@linux.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v6 2/6] gcc-plugins: Add STACKLEAK plugin for tracking
 the kernel stack
To: Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 12/05/2017 03:33 PM, Alexander Popov wrote:
> +__visible int plugin_init(struct plugin_name_args *plugin_info,
> +			  struct plugin_gcc_version *version)
> +{
> +	const char * const plugin_name = plugin_info->base_name;
> +	const int argc = plugin_info->argc;
> +	const struct plugin_argument * const argv = plugin_info->argv;
> +	int i;
> +
> +	/* Extra GGC root tables describing our GTY-ed data */
> +	static const struct ggc_root_tab gt_ggc_r_gt_stackleak[] = {
> +		{
> +			.base = &track_function_decl,
> +			.nelt = 1,
> +			.stride = sizeof(track_function_decl),
> +			.cb = &gt_ggc_mx_tree_node,
> +			.pchw = &gt_pch_nx_tree_node
> +		},
> +		{
> +			.base = &check_function_decl,
> +			.nelt = 1,
> +			.stride = sizeof(check_function_decl),
> +			.cb = &gt_ggc_mx_tree_node,
> +			.pchw = &gt_pch_nx_tree_node
> +		},
> +		LAST_GGC_ROOT_TAB
> +	};
> +
> +	/*
> +	 * The stackleak_tree_instrument pass should be executed before the
> +	 * "optimized" pass, which is the control flow graph cleanup that is
> +	 * performed just before expanding gcc trees to the RTL. In former
> +	 * versions of the plugin this new pass was inserted before the
> +	 * "tree_profile" pass, which is currently called "profile".
> +	 */
> +	PASS_INFO(stackleak_tree_instrument, "optimized", 1,
> +						PASS_POS_INSERT_BEFORE);
> +
> +	/*
> +	 * The stackleak_final pass should be executed before the "final" pass,
> +	 * which turns the RTL (Register Transfer Language) into assembly.
> +	 */
> +	PASS_INFO(stackleak_final, "final", 1, PASS_POS_INSERT_BEFORE);
> +
> +	if (!plugin_default_version_check(version, &gcc_version)) {
> +		error(G_("incompatible gcc/plugin versions"));
> +		return 1;
> +	}
> +
> +	/* Parse the plugin arguments */
> +	if (argc != 1) {
> +		error(G_("bad number of the plugin arguments: %d"), argc);
> +		return 1;
> +	}
> +
> +	if (strcmp(argv[i].key, "track-min-size")) {
> +		error(G_("unknown option '-fplugin-arg-%s-%s'"),
> +				plugin_name, argv[i].key);
> +		return 1;
> +	}
> +
> +	if (!argv[i].value) {
> +		error(G_("no value supplied for option '-fplugin-arg-%s-%s'"),
> +				plugin_name, argv[i].key);
> +		return 1;
> +	}
> +
> +	track_frame_size = atoi(argv[i].value);
> +	if (track_frame_size < 0) {
> +		error(G_("invalid option argument '-fplugin-arg-%s-%s=%s'"),
> +				plugin_name, argv[i].key, argv[i].value);
> +		return 1;
> +	}

I don't see i getting updated anywhere, which seems to be an artifact of
removing the for loop. I'd prefer if you just kept the loop since the
arm64 version requires a --disable option like structleak.

Thanks,
Laura
