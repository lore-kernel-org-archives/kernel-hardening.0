Return-Path: <kernel-hardening-return-21917-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 8E250E77188
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jan 2025 21:10:20 +0000 (UTC)
Received: (qmail 13566 invoked by uid 550); 14 Jan 2025 21:10:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14289 invoked from network); 14 Jan 2025 20:57:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736888219;
	bh=rXWxQqj1X9udCuDo8ubNb9WhgjDmLf7uCCD7cFqLA1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ho7xJgj2U4PjuqI0DTZSJlnU5l3gW1d9BwbvabPXijOrOoQhCFO8q8N56702EGHoL
	 OU9dxrhOuif6sYmu4a/iWXwB5uYht2baYQunlkGGG78b6/1e30D24z5e9wIYzf86qf
	 cmVNZ84zhpUgfPDVS2Sd6/pXD0faZ2QGxbnkVaeFA143e1hGjADQQnxc1T1lyjbOuJ
	 QBAV9sUQPpt+AoVgBzOwXecL+1ebhChhXKy/LTIfJNzghmghwZGThVdbUyX2Y2T4UQ
	 b3Vzg8Wy//wlpvIlicM+MZwma1zjB0DU6TNXqYYRREg7ESN3JR/0mmSBNB8bqD1kB4
	 Yzszbo/FhR+Pw==
Date: Tue, 14 Jan 2025 13:56:45 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <serge@hallyn.com>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Alejandro Colomar <alx@kernel.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Heimes <christian@python.org>,
	Dmitry Vyukov <dvyukov@google.com>, Elliott Hughes <enh@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Fan Wu <wufan@linux.microsoft.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jamorris@linux.microsoft.com>,
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Jordan R Abrahams <ajordanr@google.com>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Luca Boccassi <bluca@debian.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	Xiaoming Ni <nixiaoming@huawei.com>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v23 7/8] samples/check-exec: Add an enlighten "inc"
 interpreter and 28 tests
Message-ID: <20250114205645.GA2825031@ax162>
References: <20241212174223.389435-1-mic@digikod.net>
 <20241212174223.389435-8-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241212174223.389435-8-mic@digikod.net>

Hi Mickaël,

On Thu, Dec 12, 2024 at 06:42:22PM +0100, Mickaël Salaün wrote:
> Add a very simple script interpreter called "inc" that can evaluate two
> different commands (one per line):
> - "?" to initialize a counter from user's input;
> - "+" to increment the counter (which is set to 0 by default).
> 
> It is enlighten to only interpret executable files according to
> AT_EXECVE_CHECK and the related securebits:
> 
>   # Executing a script with RESTRICT_FILE is only allowed if the script
>   # is executable:
>   ./set-exec -f -- ./inc script-exec.inc # Allowed
>   ./set-exec -f -- ./inc script-noexec.inc # Denied
> 
>   # Executing stdin with DENY_INTERACTIVE is only allowed if stdin is an
>   # executable regular file:
>   ./set-exec -i -- ./inc -i < script-exec.inc # Allowed
>   ./set-exec -i -- ./inc -i < script-noexec.inc # Denied
> 
>   # However, a pipe is not executable and it is then denied:
>   cat script-noexec.inc | ./set-exec -i -- ./inc -i # Denied
> 
>   # Executing raw data (e.g. command argument) with DENY_INTERACTIVE is
>   # always denied.
>   ./set-exec -i -- ./inc -c "+" # Denied
>   ./inc -c "$(<script-ask.inc)" # Allowed
> 
>   # To directly execute a script, we can update $PATH (used by `env`):
>   PATH="${PATH}:." ./script-exec.inc
> 
>   # To execute several commands passed as argument:
> 
> Add a complete test suite to check the script interpreter against all
> possible execution cases:
> 
>   make TARGETS=exec kselftest-install
>   ./tools/testing/selftests/kselftest_install/run_kselftest.sh
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Serge Hallyn <serge@hallyn.com>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Link: https://lore.kernel.org/r/20241212174223.389435-8-mic@digikod.net
...
> diff --git a/samples/check-exec/inc.c b/samples/check-exec/inc.c
> new file mode 100644
> index 000000000000..94b87569d2a2
> --- /dev/null
> +++ b/samples/check-exec/inc.c
...
> +/* Returns 1 on error, 0 otherwise. */
> +static int interpret_stream(FILE *script, char *const script_name,
> +			    char *const *const envp, const bool restrict_stream)
> +{
> +	int err;
> +	char *const script_argv[] = { script_name, NULL };
> +	char buf[128] = {};
> +	size_t buf_size = sizeof(buf);
> +
> +	/*
> +	 * We pass a valid argv and envp to the kernel to emulate a native
> +	 * script execution.  We must use the script file descriptor instead of
> +	 * the script path name to avoid race conditions.
> +	 */
> +	err = execveat(fileno(script), "", script_argv, envp,
> +		       AT_EMPTY_PATH | AT_EXECVE_CHECK);
> +	if (err && restrict_stream) {
> +		perror("ERROR: Script execution check");
> +		return 1;
> +	}
> +
> +	/* Reads script. */
> +	buf_size = fread(buf, 1, buf_size - 1, script);
> +	return interpret_buffer(buf, buf_size);
> +}

The use of execveat() in this test case breaks the build when glibc is
less than 2.34, as that is the earliest version that has the execveat()
wrapper:

https://sourceware.org/git/?p=glibc.git;a=commit;h=19d83270fcd993cc349570164e21b06d57036704

  $ ldd --version | head -1
  ldd (Debian GLIBC 2.31-13+deb11u11) 2.31

  $ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- mrproper allmodconfig samples/
  ...
  samples/check-exec/inc.c:81:8: error: call to undeclared function 'execveat'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     81 |         err = execveat(fileno(script), "", script_argv, envp,
        |               ^
  samples/check-exec/inc.c:81:8: note: did you mean 'execve'?
  /usr/include/unistd.h:551:12: note: 'execve' declared here
    551 | extern int execve (const char *__path, char *const __argv[],
        |            ^
  1 error generated.
  ...

Should this just use the syscall directly?

Cheers,
Nathan
