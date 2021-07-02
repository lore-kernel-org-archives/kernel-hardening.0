Return-Path: <SRS0=exdU=L2=lists.openwall.com=kernel-hardening-return-21330-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1A6C11F68
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Jul 2021 17:08:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 492EE613E8
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Jul 2021 17:08:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 492EE613E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=pm.me
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21330-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19602 invoked by uid 550); 2 Jul 2021 17:08:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19582 invoked from network); 2 Jul 2021 17:08:34 -0000
Date: Fri, 02 Jul 2021 17:08:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
	t=1625245702; bh=a0dudNCpkGNtNs8mdjq6tTFehahgFVidBNRIuz7OjCA=;
	h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
	b=ALNZPPjjr+IZ9Uy2KlvVjUNm13Xi3UXKi4BgTQl3RRDC8vvtYUTIg7LECP69YPFdk
	 XTfU8kO0y48TwujNw9eOok49hm6xb5i+jUfDxS82NKIhTvyXCB172/WTKgpLqYQ+ee
	 VFcWfdO5cr/Pylxozf3GcaSGXvTW+vFJ1AJGxtPgzyLjI7XH47iCorWKnreRFFCMso
	 zox/YAD/w4myB1O5oxeQKeEqa10afYHPBHXLR6wGHPjrHZzausWsd8/G+O0ZRTF1Qs
	 v0N2o6kSJc+9Z6zaDQusA8d2oSnDWDLH9yzicM0pCGKFBiuhdtJcPUiCnq1St7kEwl
	 bCE1FDbmfQDCw==
To: John Wood <john.wood@gmx.com>
From: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Lobakin <alobakin@pm.me>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Andi Kleen <ak@linux.intel.com>, valdis.kletnieks@vt.edu, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v8 3/8] security/brute: Detect a brute force attack
Message-ID: <20210702170101.16116-1-alobakin@pm.me>
In-Reply-To: <20210702145954.GA4513@ubuntu>
References: <20210701234807.50453-1-alobakin@pm.me> <20210702145954.GA4513@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

From: John Wood <john.wood@gmx.com>
Date: Fri, 2 Jul 2021 16:59:54 +0200

> Hi,
>
> On Thu, Jul 01, 2021 at 11:55:14PM +0000, Alexander Lobakin wrote:
> > Hi,
> >
> > From: John Wood <john.wood@gmx.com>
> > Date: Sat, 5 Jun 2021 17:04:00 +0200
> >
> > > +static int brute_task_execve(struct linux_binprm *bprm, struct file =
*file)
> > > +{
> > > +=09struct dentry *dentry =3D file_dentry(bprm->file);
> > > +=09struct inode *inode =3D file_inode(bprm->file);
> > > +=09struct brute_stats stats;
> > > +=09int rc;
> > > +
> > > +=09inode_lock(inode);
> > > +=09rc =3D brute_get_xattr_stats(dentry, inode, &stats);
> > > +=09if (WARN_ON_ONCE(rc && rc !=3D -ENODATA))
> > > +=09=09goto unlock;
> >
> > I think I caught a problem here. Have you tested this with
> > initramfs?
>
> No, it has not been tested with initramfs :(
>
> > According to init/do_mount.c's
> > init_rootfs()/rootfs_init_fs_context(), when `root=3D` cmdline
> > parameter is not empty, kernel creates rootfs of type ramfs
> > (tmpfs otherwise).
> > The thing about ramfs is that it doesn't support xattrs.
>
> It is a known issue that systems without xattr support are not
> suitable for Brute (there are a note in the documentation).
> However, the purpose is not to panic the system :(
>
> > I'm running this v8 on a regular PC with initramfs and having
> > `root=3D` in cmdline, and Brute doesn't allow the kernel to run
> > any init processes (/init, /sbin/init, ...) with err =3D=3D -95
> > (-EOPNOTSUPP) -- I'm getting a
> >
> > WARNING: CPU: 0 PID: 173 at brute_task_execve+0x15d/0x200
> > <snip>
> > Failed to execute /init (error -95)
> >
> > and so on (and a panic at the end).
> >
> > If I omit `root=3D` from cmdline, then the kernel runs init process
> > just fine -- I guess because initramfs is then placed inside tmpfs
> > with xattr support.
> >
> > As for me, this ramfs/tmpfs selection based on `root=3D` presence
> > is ridiculous and I don't see or know any reasons behind that.
> > But that's another story, and ramfs might be not the only one
> > system without xattr support.
> > I think Brute should have a fallback here, e.g. it could simply
> > ignore files from xattr-incapable filesystems instead of such
> > WARNING splats and stuff.
>
> Ok, it seems reasonable to me: if the file system doesn't support
> xattr, but Brute is enabled, Brute will do nothing and the system
> will work normally.

On the other hand, it leaves a potentional window for attackers to
perform brute force from xattr-incapable filesystems. So at the end
of the day I think that the current implementation (a strong
rejection of such filesystems) is way more secure than having
a fallback I proposed.

I'm planning to make a patch which will eliminate such weird rootfs
type selection and just always use more feature-rich tmpfs if it's
compiled in. So, as an alternative, you could add it to your series
as a preparatory change and just add a Kconfig dependency on
CONFIG_TMPFS && CONFIG_TMPFS_XATTR to CONFIG_SECURITY_FORK_BRUTE
without messing with any fallbacks at all.
What do you think?

> I will work on it for the next version.
> Thanks for the feedback.
>
> John Wood

Thanks,
Al

