Return-Path: <kernel-hardening-return-21892-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 87314E7717F
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Dec 2024 16:47:22 +0000 (UTC)
Received: (qmail 20205 invoked by uid 550); 10 Dec 2024 16:47:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20182 invoked from network); 10 Dec 2024 16:47:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1733849219;
	bh=AKfqiUY7eMfEsdz5u103joyKamvACxWQp+22wr0Wd44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vwg+iP1pCcTZFg8Af2j12no9tm5Fb8Pt2xbYiD2GysMa6zrK+CSv2TeJRyR7IA3+7
	 sSMiT5JX8buLAstexHqWXypwYaab22lsuYRmVF3D/8/kLxGnbJ4CuWLHYMI9UDylr4
	 wzsRzvbKiz0k6JcxUwQXKYUEXipWeJa3bMExhtzg=
Date: Tue, 10 Dec 2024 17:46:45 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Jeff Xu <jeffxu@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <serge@hallyn.com>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, Alejandro Colomar <alx@kernel.org>, 
	Aleksa Sarai <cyphar@cyphar.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Elliott Hughes <enh@google.com>, 
	Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, 
	Fan Wu <wufan@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jamorris@linux.microsoft.com>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Luca Boccassi <bluca@debian.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, 
	Matt Bobrowski <mattbobrowski@google.com>, Matthew Garrett <mjg59@srcf.ucam.org>, 
	Matthew Wilcox <willy@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Scott Shell <scottsh@microsoft.com>, 
	Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Steve Dower <steve.dower@python.org>, 
	Steve Grubb <sgrubb@redhat.com>, Theodore Ts'o <tytso@mit.edu>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, 
	Xiaoming Ni <nixiaoming@huawei.com>, Yin Fengwei <fengwei.yin@intel.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v22 2/8] security: Add EXEC_RESTRICT_FILE and
 EXEC_DENY_INTERACTIVE securebits
Message-ID: <20241210.FahfahPu5dae@digikod.net>
References: <20241205160925.230119-1-mic@digikod.net>
 <20241205160925.230119-3-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241205160925.230119-3-mic@digikod.net>
X-Infomaniak-Routing: alpha

On Thu, Dec 05, 2024 at 05:09:19PM +0100, Mickaël Salaün wrote:
> The new SECBIT_EXEC_RESTRICT_FILE, SECBIT_EXEC_DENY_INTERACTIVE, and
> their *_LOCKED counterparts are designed to be set by processes setting
> up an execution environment, such as a user session, a container, or a
> security sandbox.  Unlike other securebits, these ones can be set by
> unprivileged processes.  Like seccomp filters or Landlock domains, the
> securebits are inherited across processes.
> 
> When SECBIT_EXEC_RESTRICT_FILE is set, programs interpreting code should
> control executable resources according to execveat(2) + AT_EXECVE_CHECK
> (see previous commit).
> 
> When SECBIT_EXEC_DENY_INTERACTIVE is set, a process should deny
> execution of user interactive commands (which excludes executable
> regular files).
> 
> Being able to configure each of these securebits enables system
> administrators or owner of image containers to gradually validate the
> related changes and to identify potential issues (e.g. with interpreter
> or audit logs).
> 
> It should be noted that unlike other security bits, the
> SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE bits are
> dedicated to user space willing to restrict itself.  Because of that,
> they only make sense in the context of a trusted environment (e.g.
> sandbox, container, user session, full system) where the process
> changing its behavior (according to these bits) and all its parent
> processes are trusted.  Otherwise, any parent process could just execute
> its own malicious code (interpreting a script or not), or even enforce a
> seccomp filter to mask these bits.
> 
> Such a secure environment can be achieved with an appropriate access
> control (e.g. mount's noexec option, file access rights, LSM policy) and
> an enlighten ld.so checking that libraries are allowed for execution
> e.g., to protect against illegitimate use of LD_PRELOAD.
> 
> Ptrace restrictions according to these securebits would not make sense
> because of the processes' trust assumption.
> 
> Scripts may need some changes to deal with untrusted data (e.g. stdin,
> environment variables), but that is outside the scope of the kernel.
> 
> See chromeOS's documentation about script execution control and the
> related threat model:
> https://www.chromium.org/chromium-os/developer-library/guides/security/noexec-shell-scripts/
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Paul Moore <paul@paul-moore.com>
> Reviewed-by: Serge Hallyn <serge@hallyn.com>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Link: https://lore.kernel.org/r/20241205160925.230119-3-mic@digikod.net
> ---
> 
> Changes since v21:
> * Extend user documentation with exception regarding tailored execution
>   environments (e.g. chromeOS's libc) as discussed with Jeff.
> 
> Changes since v20:
> * Move UAPI documentation to a dedicated RST file and format it.
> 
> Changes since v19:
> * Replace SECBIT_SHOULD_EXEC_CHECK and SECBIT_SHOULD_EXEC_RESTRICT with
>   SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE:
>   https://lore.kernel.org/all/20240710.eiKohpa4Phai@digikod.net/
> * Remove the ptrace restrictions, suggested by Andy.
> * Improve documentation according to the discussion with Jeff.
> 
> New design since v18:
> https://lore.kernel.org/r/20220104155024.48023-3-mic@digikod.net
> ---
>  Documentation/userspace-api/check_exec.rst | 107 +++++++++++++++++++++
>  include/uapi/linux/securebits.h            |  24 ++++-
>  security/commoncap.c                       |  29 ++++--
>  3 files changed, 153 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/userspace-api/check_exec.rst b/Documentation/userspace-api/check_exec.rst
> index 393dd7ca19c4..05dfe3b56f71 100644
> --- a/Documentation/userspace-api/check_exec.rst
> +++ b/Documentation/userspace-api/check_exec.rst
> @@ -5,6 +5,31 @@
>  Executability check
>  ===================
>  
> +The ``AT_EXECVE_CHECK`` :manpage:`execveat(2)` flag, and the
> +``SECBIT_EXEC_RESTRICT_FILE`` and ``SECBIT_EXEC_DENY_INTERACTIVE`` securebits
> +are intended for script interpreters and dynamic linkers to enforce a
> +consistent execution security policy handled by the kernel.  See the
> +`samples/check-exec/inc.c`_ example.
> +
> +Whether an interpreter should check these securebits or not depends on the
> +security risk of running malicious scripts with respect to the execution
> +environment, and whether the kernel can check if a script is trustworthy or
> +not.  For instance, Python scripts running on a server can use arbitrary
> +syscalls and access arbitrary files.  Such interpreters should then be
> +enlighten to use these securebits and let users define their security policy.
> +However, a JavaScript engine running in a web browser should already be
> +sandboxed and then should not be able to harm the user's environment.
> +
> +Script interpreters or dynamic linkers built for tailored execution environments
> +(e.g. hardened Linux distributions or hermetic container images) could use
> +``AT_EXECVE_CHECK`` without checking the related securebits if backward
> +compatibility is handled by something else (e.g. atomic update ensuring that
> +all legitimate libraries are allowed to be executed).  It is then recommended
> +for script interpreters and dynamic linkers to check the securebits at run time
> +by default, but also to provide the ability for custom builds to behave like if
> +``SECBIT_EXEC_RESTRICT_FILE`` or ``SECBIT_EXEC_DENY_INTERACTIVE`` were always
> +set to 1 (i.e. always enforce restrictions).

Jeff, does this work for you?

I'll update the IMA patch with a last version but otherwise it should be
good: https://lore.kernel.org/all/20241210.Wie6ion7Aich@digikod.net/

> +
>  AT_EXECVE_CHECK
>  ===============
>  
> @@ -35,3 +60,85 @@ be executable, which also requires integrity guarantees.
>  To avoid race conditions leading to time-of-check to time-of-use issues,
>  ``AT_EXECVE_CHECK`` should be used with ``AT_EMPTY_PATH`` to check against a
>  file descriptor instead of a path.
> +
> +SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE
> +==========================================================
> +
> +When ``SECBIT_EXEC_RESTRICT_FILE`` is set, a process should only interpret or
> +execute a file if a call to :manpage:`execveat(2)` with the related file
> +descriptor and the ``AT_EXECVE_CHECK`` flag succeed.
> +
> +This secure bit may be set by user session managers, service managers,
> +container runtimes, sandboxer tools...  Except for test environments, the
> +related ``SECBIT_EXEC_RESTRICT_FILE_LOCKED`` bit should also be set.
> +
> +Programs should only enforce consistent restrictions according to the
> +securebits but without relying on any other user-controlled configuration.
> +Indeed, the use case for these securebits is to only trust executable code
> +vetted by the system configuration (through the kernel), so we should be
> +careful to not let untrusted users control this configuration.
> +
> +However, script interpreters may still use user configuration such as
> +environment variables as long as it is not a way to disable the securebits
> +checks.  For instance, the ``PATH`` and ``LD_PRELOAD`` variables can be set by
> +a script's caller.  Changing these variables may lead to unintended code
> +executions, but only from vetted executable programs, which is OK.  For this to
> +make sense, the system should provide a consistent security policy to avoid
> +arbitrary code execution e.g., by enforcing a write xor execute policy.
> +
> +When ``SECBIT_EXEC_DENY_INTERACTIVE`` is set, a process should never interpret
> +interactive user commands (e.g. scripts).  However, if such commands are passed
> +through a file descriptor (e.g. stdin), its content should be interpreted if a
> +call to :manpage:`execveat(2)` with the related file descriptor and the
> +``AT_EXECVE_CHECK`` flag succeed.
> +
> +For instance, script interpreters called with a script snippet as argument
> +should always deny such execution if ``SECBIT_EXEC_DENY_INTERACTIVE`` is set.
> +
> +This secure bit may be set by user session managers, service managers,
> +container runtimes, sandboxer tools...  Except for test environments, the
> +related ``SECBIT_EXEC_DENY_INTERACTIVE_LOCKED`` bit should also be set.
> +
> +Here is the expected behavior for a script interpreter according to combination
> +of any exec securebits:
> +
> +1. ``SECBIT_EXEC_RESTRICT_FILE=0`` and ``SECBIT_EXEC_DENY_INTERACTIVE=0``
> +
> +   Always interpret scripts, and allow arbitrary user commands (default).
> +
> +   No threat, everyone and everything is trusted, but we can get ahead of
> +   potential issues thanks to the call to :manpage:`execveat(2)` with
> +   ``AT_EXECVE_CHECK`` which should always be performed but ignored by the
> +   script interpreter.  Indeed, this check is still important to enable systems
> +   administrators to verify requests (e.g. with audit) and prepare for
> +   migration to a secure mode.
> +
> +2. ``SECBIT_EXEC_RESTRICT_FILE=1`` and ``SECBIT_EXEC_DENY_INTERACTIVE=0``
> +
> +   Deny script interpretation if they are not executable, but allow
> +   arbitrary user commands.
> +
> +   The threat is (potential) malicious scripts run by trusted (and not fooled)
> +   users.  That can protect against unintended script executions (e.g. ``sh
> +   /tmp/*.sh``).  This makes sense for (semi-restricted) user sessions.
> +
> +3. ``SECBIT_EXEC_RESTRICT_FILE=0`` and ``SECBIT_EXEC_DENY_INTERACTIVE=1``
> +
> +   Always interpret scripts, but deny arbitrary user commands.
> +
> +   This use case may be useful for secure services (i.e. without interactive
> +   user session) where scripts' integrity is verified (e.g.  with IMA/EVM or
> +   dm-verity/IPE) but where access rights might not be ready yet.  Indeed,
> +   arbitrary interactive commands would be much more difficult to check.
> +
> +4. ``SECBIT_EXEC_RESTRICT_FILE=1`` and ``SECBIT_EXEC_DENY_INTERACTIVE=1``
> +
> +   Deny script interpretation if they are not executable, and also deny
> +   any arbitrary user commands.
> +
> +   The threat is malicious scripts run by untrusted users (but trusted code).
> +   This makes sense for system services that may only execute trusted scripts.
> +
> +.. Links
> +.. _samples/check-exec/inc.c:
> +   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/samples/check-exec/inc.c
