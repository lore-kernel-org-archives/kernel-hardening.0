Return-Path: <SRS0=jqdg=LZ=lists.openwall.com=kernel-hardening-return-21328-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFFFC11F67
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Jul 2021 23:55:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 40342613D6
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Jul 2021 23:55:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40342613D6
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=pm.me
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21328-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9893 invoked by uid 550); 1 Jul 2021 23:55:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9873 invoked from network); 1 Jul 2021 23:55:34 -0000
Date: Thu, 01 Jul 2021 23:55:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
	t=1625183722; bh=vHKTUFhjrBhE16qbi5KjG4YoGMyuu2TJDAhJMIvSDHc=;
	h=Date:To:From:Cc:Reply-To:Subject:From;
	b=TZNDt39DpZBBE6Juyish52qZ16sbLTnLJqFgFg73EshUVGla6BhOtcuxYVX0aT8LA
	 oCLKYTX7Gs4ipyk0Unx6KekFfLXieN/7qC/Q1zP3AaWtQ1k4CdObmssDljz7S3hLF4
	 8u/ho2Rd+KqT6PjzpPLb9UPCVY2WIh9odzuoJTbpRCLO5pW+Ui++CLuD3JtTvIeiLo
	 C4JgqvPz8GO2OIfXN6oGDkJVJryG50thjzE6nubiSMvhJYzzkByv7bQs+3aBKNfre8
	 HgW75k8F86MKBOomdEQS2hQ7yiaLqZiZNmlFEtO9uzYJlafNUKfEev51n8zyGGwqCR
	 CZpvnLTBpmgrw==
To: John Wood <john.wood@gmx.com>
From: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Lobakin <alobakin@pm.me>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Andi Kleen <ak@linux.intel.com>, valdis.kletnieks@vt.edu, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v8 3/8] security/brute: Detect a brute force attack
Message-ID: <20210701234807.50453-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

From: John Wood <john.wood@gmx.com>
Date: Sat, 5 Jun 2021 17:04:00 +0200

> For a correct management of a fork brute force attack it is necessary to
> track all the information related to the application crashes. To do so,
> use the extended attributes (xattr) of the executable files and define a
> statistical data structure to hold all the necessary information shared
> by all the fork hierarchy processes. This info is the number of crashes,
> the last crash timestamp and the crash period's moving average.
>
> The same can be achieved using a pointer to the fork hierarchy
> statistical data held by the task_struct structure. But this has an
> important drawback: a brute force attack that happens through the execve
> system call losts the faults info since these statistics are freed when
> the fork hierarchy disappears. Using this method makes not possible to
> manage this attack type that can be successfully treated using extended
> attributes.
>
> Also, to avoid false positives during the attack detection it is
> necessary to narrow the possible cases. So, only the following scenarios
> are taken into account:
>
> 1.- Launching (fork()/exec()) a setuid/setgid process repeatedly until a
>     desirable memory layout is got (e.g. Stack Clash).
> 2.- Connecting to an exec()ing network daemon (e.g. xinetd) repeatedly
>     until a desirable memory layout is got (e.g. what CTFs do for simple
>     network service).
> 3.- Launching processes without exec() (e.g. Android Zygote) and
>     exposing state to attack a sibling.
> 4.- Connecting to a fork()ing network daemon (e.g. apache) repeatedly
>     until the previously shared memory layout of all the other children
>     is exposed (e.g. kind of related to HeartBleed).
>
> In each case, a privilege boundary has been crossed:
>
> Case 1: setuid/setgid process
> Case 2: network to local
> Case 3: privilege changes
> Case 4: network to local
>
> To mark that a privilege boundary has been crossed it is only necessary
> to create a new stats for the executable file via the extended attribute
> and only if it has no previous statistical data. This is done using four
> different LSM hooks, one per privilege boundary:
>
> setuid/setgid process --> bprm_creds_from_file hook (based on secureexec
>                           flag).
> network to local -------> socket_accept hook (taking into account only
>                           external connections).
> privilege changes ------> task_fix_setuid and task_fix_setgid hooks.
>
> To detect a brute force attack it is necessary that the executable file
> statistics be updated in every fatal crash and the most important data
> to update is the application crash period. To do so, use the new
> "task_fatal_signal" LSM hook added in a previous step.
>
> The application crash period must be a value that is not prone to change
> due to spurious data and follows the real crash period. So, to compute
> it, the exponential moving average (EMA) is used.
>
> Based on the updated statistics two different attacks can be handled. A
> slow brute force attack that is detected if the maximum number of faults
> per fork hierarchy is reached and a fast brute force attack that is
> detected if the application crash period falls below a certain
> threshold.
>
> Moreover, only the signals delivered by the kernel are taken into
> account with the exception of the SIGABRT signal since the latter is
> used by glibc for stack canary, malloc, etc failures, which may indicate
> that a mitigation has been triggered.
>
> Signed-off-by: John Wood <john.wood@gmx.com>
>
> <snip>
>
> +static int brute_get_xattr_stats(struct dentry *dentry, struct inode *in=
ode,
> +=09=09=09=09 struct brute_stats *stats)
> +{
> +=09int rc;
> +=09struct brute_raw_stats raw_stats;
> +
> +=09rc =3D __vfs_getxattr(dentry, inode, XATTR_NAME_BRUTE, &raw_stats,
> +=09=09=09    sizeof(raw_stats));
> +=09if (rc < 0)
> +=09=09return rc;
> +
> +=09stats->faults =3D le32_to_cpu(raw_stats.faults);
> +=09stats->nsecs =3D le64_to_cpu(raw_stats.nsecs);
> +=09stats->period =3D le64_to_cpu(raw_stats.period);
> +=09stats->flags =3D raw_stats.flags;
> +=09return 0;
> +}
>
> <snip>
>
> +static int brute_task_execve(struct linux_binprm *bprm, struct file *fil=
e)
> +{
> +=09struct dentry *dentry =3D file_dentry(bprm->file);
> +=09struct inode *inode =3D file_inode(bprm->file);
> +=09struct brute_stats stats;
> +=09int rc;
> +
> +=09inode_lock(inode);
> +=09rc =3D brute_get_xattr_stats(dentry, inode, &stats);
> +=09if (WARN_ON_ONCE(rc && rc !=3D -ENODATA))
> +=09=09goto unlock;

I think I caught a problem here. Have you tested this with
initramfs?

According to init/do_mount.c's
init_rootfs()/rootfs_init_fs_context(), when `root=3D` cmdline
parameter is not empty, kernel creates rootfs of type ramfs
(tmpfs otherwise).
The thing about ramfs is that it doesn't support xattrs.

I'm running this v8 on a regular PC with initramfs and having
`root=3D` in cmdline, and Brute doesn't allow the kernel to run
any init processes (/init, /sbin/init, ...) with err =3D=3D -95
(-EOPNOTSUPP) -- I'm getting a

WARNING: CPU: 0 PID: 173 at brute_task_execve+0x15d/0x200
<snip>
Failed to execute /init (error -95)

and so on (and a panic at the end).

If I omit `root=3D` from cmdline, then the kernel runs init process
just fine -- I guess because initramfs is then placed inside tmpfs
with xattr support.

As for me, this ramfs/tmpfs selection based on `root=3D` presence
is ridiculous and I don't see or know any reasons behind that.
But that's another story, and ramfs might be not the only one
system without xattr support.
I think Brute should have a fallback here, e.g. it could simply
ignore files from xattr-incapable filesystems instead of such
WARNING splats and stuff.

> +
> +=09if (rc =3D=3D -ENODATA && bprm->secureexec) {
> +=09=09brute_reset_stats(&stats);
> +=09=09rc =3D brute_set_xattr_stats(dentry, inode, &stats);
> +=09=09if (WARN_ON_ONCE(rc))
> +=09=09=09goto unlock;
> +=09}
> +
> +=09rc =3D 0;
> +unlock:
> +=09inode_unlock(inode);
> +=09return rc;
> +}
> +
>
> <snip>

Thanks,
Al

