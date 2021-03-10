Return-Path: <SRS0=KhdM=II=lists.openwall.com=kernel-hardening-return-20916-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAD_ENC_HEADER,BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CEEC433DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 19:24:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CACE464F58
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 19:23:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CACE464F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20916-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22043 invoked by uid 550); 10 Mar 2021 19:23:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22023 invoked from network); 10 Mar 2021 19:23:49 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  James Morris <jmorris@namei.org>,
  Serge Hallyn <serge@hallyn.com>,  Andy Lutomirski <luto@amacapital.net>,
  Casey Schaufler <casey@schaufler-ca.com>,  Christian Brauner
 <christian.brauner@ubuntu.com>,  Christoph Hellwig <hch@lst.de>,  David
 Howells <dhowells@redhat.com>,  Dominik Brodowski
 <linux@dominikbrodowski.net>,  John Johansen
 <john.johansen@canonical.com>,  Kees Cook <keescook@chromium.org>,
  Kentaro Takeda <takedakn@nttdata.co.jp>,  Tetsuo Handa
 <penguin-kernel@i-love.sakura.ne.jp>,
  kernel-hardening@lists.openwall.com,  linux-fsdevel@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-security-module@vger.kernel.org,
  =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@linux.microsoft.com>
References: <20210310181857.401675-1-mic@digikod.net>
	<20210310181857.401675-2-mic@digikod.net>
Date: Wed, 10 Mar 2021 13:23:35 -0600
In-Reply-To: <20210310181857.401675-2-mic@digikod.net> (=?utf-8?Q?=22Micka?=
 =?utf-8?Q?=C3=ABl_Sala=C3=BCn=22's?=
	message of "Wed, 10 Mar 2021 19:18:57 +0100")
Message-ID: <m17dmeq0co.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-XM-SPF: eid=1lK4Qc-000rmA-Vd;;;mid=<m17dmeq0co.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19S/7ngoYSiqgP0zhuPuu98BieLUm0rlgg=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v2 1/1] fs: Allow no_new_privs tasks to call chroot(2)
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> writes:

> From: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
>
> Being able to easily change root directories enable to ease some
> development workflow and can be used as a tool to strengthen
> unprivileged security sandboxes.  chroot(2) is not an access-control
> mechanism per se, but it can be used to limit the absolute view of the
> filesystem, and then limit ways to access data and kernel interfaces
> (e.g. /proc, /sys, /dev, etc.).
>
> Users may not wish to expose namespace complexity to potentially
> malicious processes, or limit their use because of limited resources.
> The chroot feature is much more simple (and limited) than the mount
> namespace, but can still be useful.  As for containers, users of
> chroot(2) should take care of file descriptors or data accessible by
> other means (e.g. current working directory, leaked FDs, passed FDs,
> devices, mount points, etc.).  There is a lot of literature that discuss
> the limitations of chroot, and users of this feature should be aware of
> the multiple ways to bypass it.  Using chroot(2) for security purposes
> can make sense if it is combined with other features (e.g. dedicated
> user, seccomp, LSM access-controls, etc.).
>
> One could argue that chroot(2) is useless without a properly populated
> root hierarchy (i.e. without /dev and /proc).  However, there are
> multiple use cases that don't require the chrooting process to create
> file hierarchies with special files nor mount points, e.g.:
> * A process sandboxing itself, once all its libraries are loaded, may
>   not need files other than regular files, or even no file at all.
> * Some pre-populated root hierarchies could be used to chroot into,
>   provided for instance by development environments or tailored
>   distributions.
> * Processes executed in a chroot may not require access to these special
>   files (e.g. with minimal runtimes, or by emulating some special files
>   with a LD_PRELOADed library or seccomp).
>
> Allowing a task to change its own root directory is not a threat to the
> system if we can prevent confused deputy attacks, which could be
> performed through execution of SUID-like binaries.  This can be
> prevented if the calling task sets PR_SET_NO_NEW_PRIVS on itself with
> prctl(2).  To only affect this task, its filesystem information must not
> be shared with other tasks, which can be achieved by not passing
> CLONE_FS to clone(2).  A similar no_new_privs check is already used by
> seccomp to avoid the same kind of security issues.  Furthermore, because
> of its security use and to avoid giving a new way for attackers to get
> out of a chroot (e.g. using /proc/<pid>/root), an unprivileged chroot is
> only allowed if the new root directory is the same or beneath the
> current one.  This still allows a process to use a subset of its
> legitimate filesystem to chroot into and then further reduce its view of
> the filesystem.
>
> This change may not impact systems relying on other permission models
> than POSIX capabilities (e.g. Tomoyo).  Being able to use chroot(2) on
> such systems may require to update their security policies.
>
> Only the chroot system call is relaxed with this no_new_privs check; the
> init_chroot() helper doesn't require such change.
>
> Allowing unprivileged users to use chroot(2) is one of the initial
> objectives of no_new_privs:
> https://www.kernel.org/doc/html/latest/userspace-api/no_new_privs.html
> This patch is a follow-up of a previous one sent by Andy Lutomirski, but
> with less limitations:
> https://lore.kernel.org/lkml/0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.132=
7858005.git.luto@amacapital.net/
>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: John Johansen <john.johansen@canonical.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
> Cc: Serge Hallyn <serge@hallyn.com>
> Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> Link: https://lore.kernel.org/r/20210310181857.401675-2-mic@digikod.net
> ---
>
> Changes since v1:
> * Replace custom is_path_beneath() with existing path_is_under().

Neither is_path_beneath nor path_is_under really help prevent escapes,
as except for open files and files accessible from proc chroot already
disallows going up.  The reason is the path is resolved with the current
root before switching to it.

My brain was fuzzy.  I had the classic escape scenario confused.
It isn't chroot("../../..");

The actual classic chroot escape is.
chdir("/");
chroot("/somedir");
chdir("../../../..");

Your change would disallow changing the root directory, but it doesn't
much help as all files in the mount namespace are visible anyway.

Furthermore changing chdir to ensure it's path is at or beneath the
current root would cause regressions in existing userspace programs
so we can't do that.

Plus you are trying to rely on changing the definition of chroot to make
it safe (not just changing the permission checks).  That is also
confusing and makes it difficult to analyze because people's previous
analysis gets confused.


Eric

> ---
>  fs/open.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/fs/open.c b/fs/open.c
> index e53af13b5835..280dbff25b25 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -22,6 +22,7 @@
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
>  #include <linux/fs.h>
> +#include <linux/path.h>
>  #include <linux/personality.h>
>  #include <linux/pagemap.h>
>  #include <linux/syscalls.h>
> @@ -546,15 +547,31 @@ SYSCALL_DEFINE1(chroot, const char __user *, filena=
me)
>  	if (error)
>  		goto dput_and_out;
>=20=20
> +	/*
> +	 * Changing the root directory for the calling task (and its future
> +	 * children) requires that this task has CAP_SYS_CHROOT in its
> +	 * namespace, or be running with no_new_privs and not sharing its
> +	 * fs_struct and not escaping its current root directory.  As for
> +	 * seccomp, checking no_new_privs avoids scenarios where unprivileged
> +	 * tasks can affect the behavior of privileged children.  Lock the path
> +	 * to protect against TOCTOU race between path_is_under() and
> +	 * set_fs_root().  No need to lock the root because it is not possible
> +	 * to rename it beneath itself.
> +	 */
>  	error =3D -EPERM;
> -	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT))
> -		goto dput_and_out;
> +	inode_lock(d_inode(path.dentry));
> +	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT) &&
> +			!(task_no_new_privs(current) && current->fs->users =3D=3D 1
> +				&& path_is_under(&path, &current->fs->root)))
> +		goto unlock_and_out;
>  	error =3D security_path_chroot(&path);
>  	if (error)
> -		goto dput_and_out;
> +		goto unlock_and_out;
>=20=20
>  	set_fs_root(current->fs, &path);
>  	error =3D 0;
> +unlock_and_out:
> +	inode_unlock(d_inode(path.dentry));
>  dput_and_out:
>  	path_put(&path);
>  	if (retry_estale(error, lookup_flags)) {
