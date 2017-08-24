Date: Wed, 23 Aug 2017 19:50:32 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Message-ID: <20170824025030.sxl2hkpcbzipb47y@ast-mbp>
References: <20170821000933.13024-1-mic@digikod.net>
 <20170821000933.13024-6-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170821000933.13024-6-mic@digikod.net>
Subject: [kernel-hardening] Re: [PATCH net-next v7 05/10] landlock: Add LSM hooks related to
 filesystem
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Matthew Garrett <mjg59@srcf.ucam.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, netdev@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 21, 2017 at 02:09:28AM +0200, Mickaël Salaün wrote:
> Handle 33 filesystem-related LSM hooks for the Landlock filesystem
> event: LANDLOCK_SUBTYPE_EVENT_FS.
> 
> A Landlock event wrap LSM hooks for similar kernel object types (e.g.
> struct file, struct path...). Multiple LSM hooks can trigger the same
> Landlock event.
> 
> Landlock handle nine coarse-grained actions: read, write, execute, new,
> get, remove, ioctl, lock and fcntl. Each of them abstract LSM hook
> access control in a way that can be extended in the future.
> 
> The Landlock LSM hook registration is done after other LSM to only run
> actions from user-space, via eBPF programs, if the access was granted by
> major (privileged) LSMs.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>

...

> +/* WRAP_ARG_SB */
> +#define WRAP_ARG_SB_TYPE	WRAP_TYPE_FS
> +#define WRAP_ARG_SB_DEC(arg)					\
> +	EXPAND_C(WRAP_TYPE_FS) wrap_##arg =			\
> +	{ .type = BPF_HANDLE_FS_TYPE_DENTRY, .dentry = arg->s_root };
> +#define WRAP_ARG_SB_VAL(arg)	((uintptr_t)&wrap_##arg)
> +#define WRAP_ARG_SB_OK(arg)	(arg && arg->s_root)
...

> +HOOK_NEW_FS(sb_remount, 2,
> +	struct super_block *, sb,
> +	void *, data,
> +	WRAP_ARG_SB, sb,
> +	WRAP_ARG_RAW, LANDLOCK_ACTION_FS_WRITE
> +);

this looks wrong. casting super_block to dentry?

> +/* a directory inode contains only one dentry */
> +HOOK_NEW_FS(inode_create, 3,
> +	struct inode *, dir,
> +	struct dentry *, dentry,
> +	umode_t, mode,
> +	WRAP_ARG_INODE, dir,
> +	WRAP_ARG_RAW, LANDLOCK_ACTION_FS_WRITE
> +);

more general question: why you're not wrapping all useful
arguments? Like in the above dentry can be acted upon
by the landlock rule and it's readily available...

The limitation of only 2 args looks odd.
Is it a hard limitation ? how hard to extend?
