Date: Wed, 23 Aug 2017 19:59:02 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Message-ID: <20170824025901.cpppy4nn5xv2ao24@ast-mbp>
References: <20170821000933.13024-1-mic@digikod.net>
 <20170821000933.13024-9-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170821000933.13024-9-mic@digikod.net>
Subject: [kernel-hardening] Re: [PATCH net-next v7 08/10] bpf: Add a Landlock sandbox example
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Matthew Garrett <mjg59@srcf.ucam.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, netdev@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 21, 2017 at 02:09:31AM +0200, Mickaël Salaün wrote:
> Add a basic sandbox tool to create a process isolated from some part of
> the system. This sandbox create a read-only environment. It is only
> allowed to write to a character device such as a TTY:
> 
>   # :> X
>   # echo $?
>   0
>   # ./samples/bpf/landlock1 /bin/sh -i
>   Launching a new sandboxed process.
>   # :> Y
>   cannot create Y: Operation not permitted
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>

...

> +SEC("landlock1")
> +static int landlock_fs_prog1(struct landlock_context *ctx)
> +{
> +	char fmt_error_mode[] = "landlock1: error: get_mode:%lld\n";
> +	char fmt_error_access[] = "landlock1: error: access denied\n";
> +	long long ret;
> +
> +	/*
> +	 * The argument ctx->arg2 contains bitflags of actions for which the
> +	 * rule is run.  The flag LANDLOCK_ACTION_FS_WRITE means that a write
> +	 * is requested by one of the userspace processes restricted by this
> +	 * rule. The following test allows any actions which does not include a
> +	 * write.
> +	 */
> +	if (!(ctx->arg2 & LANDLOCK_ACTION_FS_WRITE))
> +		return 0;
> +
> +	/*
> +	 * The argument ctx->arg1 is a file handle for which the process want
> +	 * to access. The function bpf_handle_fs_get_mode() return the mode of
> +	 * a file (e.g. S_IFBLK, S_IFDIR, S_IFREG...). If there is an error,
> +	 * for example if the argument is not a file handle, then an
> +	 * -errno value is returned. Otherwise the caller get the file mode as
> +	 *  with stat(2).
> +	 */
> +	ret = bpf_handle_fs_get_mode((void *)ctx->arg1);
> +	if (ret < 0) {
> +
> +		/*
> +		 * The bpf_trace_printk() function enable to write in the
> +		 * kernel eBPF debug log, accessible through
> +		 * /sys/kernel/debug/tracing/trace_pipe . To be allowed to call
> +		 * this function, a Landlock rule must have the
> +		 * LANDLOCK_SUBTYPE_ABILITY_DEBUG ability, which is only
> +		 * allowed for CAP_SYS_ADMIN.
> +		 */
> +		bpf_trace_printk(fmt_error_mode, sizeof(fmt_error_mode), ret);
> +		return 1;
> +	}
> +
> +	/*
> +	 * This check allows the action on the file if it is a directory or a
> +	 * pipe. Otherwise, a message is printed to the eBPF log.
> +	 */
> +	if (S_ISCHR(ret) || S_ISFIFO(ret))
> +		return 0;
> +	bpf_trace_printk(fmt_error_access, sizeof(fmt_error_access));
> +	return 1;
> +}
> +
> +/*
> + * This subtype enable to set the ABI, which ensure that the eBPF context and
> + * program behavior will be compatible with this Landlock rule.
> + */
> +SEC("subtype")
> +static const union bpf_prog_subtype _subtype = {
> +	.landlock_rule = {
> +		.abi = 1,
> +		.event = LANDLOCK_SUBTYPE_EVENT_FS,
> +		.ability = LANDLOCK_SUBTYPE_ABILITY_DEBUG,
> +	}
> +};

from rule writer perspective can you somehow merge subtype definition
with the program? It seems they go hand in hand.
Like section name of the program can be:
SEC("landlock_rule1/event=fs/ability=debug")
static int landlock_fs_prog1(struct landlock_context *ctx)...
and the loader can parse this string and prepare appropriate
data structures for the kernel.
