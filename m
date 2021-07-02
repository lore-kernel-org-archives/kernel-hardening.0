Return-Path: <SRS0=Y4RR=L2=lists.openwall.com=kernel-hardening-return-21329-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788CDC11F68
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Jul 2021 15:01:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8CC0261413
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Jul 2021 15:01:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CC0261413
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21329-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26154 invoked by uid 550); 2 Jul 2021 15:01:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26134 invoked from network); 2 Jul 2021 15:01:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1625238017;
	bh=zidR5285gxvu2arbyxmhDqg6e5LTCzi9fQLp50nBsWk=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DuwxOwI7319Lhx+I9Dc37PZMe6AbuRiW2QGky5FKmFl1Xg9YxF2MVb5pznrGmPGSG
	 jDEfrCCNH/5D0owzJ+rQfsut4w+8PVHn04RN3vsa/vy15PQMMDwtv0vo+XZM4BbQRQ
	 BbuJ3M+fhEcG2fy8ysO3Su1QGNK3ABFykt/t90p8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Fri, 2 Jul 2021 16:59:54 +0200
From: John Wood <john.wood@gmx.com>
To: Alexander Lobakin <alobakin@pm.me>
Cc: John Wood <john.wood@gmx.com>, Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>, Andi Kleen <ak@linux.intel.com>,
	valdis.kletnieks@vt.edu,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v8 3/8] security/brute: Detect a brute force attack
Message-ID: <20210702145954.GA4513@ubuntu>
References: <20210701234807.50453-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701234807.50453-1-alobakin@pm.me>
X-Provags-ID: V03:K1:dlN1ofh6LpaEb5MwTI60oBZZOzpxRydjUFLx8+d3q3xlDqOLQ/g
 AseUQcRVOSgw+y90S5R3RUUGkX4oXSPdXODz7muskTdGNG4XTvD+dI31GrvERxszJqmj3O+
 NGR5HMBSM0ueD0/qczK9UGA5RkFsMcK72AJTDElYA0GJzeW/4Rjit8KMkEtMMq+A508WvZ1
 9CbOiefkEzVVJqbrQIGyQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9i/ZvK/cQjw=:a39Z0eLmluy9VDDGJKeaLg
 TvSqt9FDYwL9BX/25PlbGRXeBfVdd3fgvyeCfs3Cp+XW92EKF2euJ/2+8TNV7UogXY/OPVI6H
 FiS43ZCv15Ssd8V0eSkpzvQ5M7jHPHu341L84wtUpSzP0G21MSQnvItwJXbGogBsXNar813oT
 SUjE4WB1mmj64Lhvz5tEcgxk09x+e3yVDtMStATKQafRV93kysgYntaYek7y+rvnVs+Jz9cho
 6ftPnQa7oB+fiBrMlvv18UPBM7FYSf5xmj0eyeAcUEngS6J9NnI7vje+YtPv01oFwp53wRMo7
 Ui1yNLxR6D8tkXq4NAl9MqRVsX0/VbkYgti+7sEL7SXbC8sVtjhNTkCafaP8hGK6fDHserJxV
 6MwKbHRunfIlcT6k/5PukZ7cCcG/lwCBLu1BsGz7mJ/H2qiTr9btN92/xs1280gM/u4bTToHc
 NugNiuR3cZ786M2B2/Qgy6SkwwlRn5b8nIZhWGt30TwI+FU2acVkPZZMqBL7krRB2ftGc32yg
 7qv+UruXZ9hYUEi9NSWXhlv0enDJDSEaFoMuU3WCSKx/hmRDlhI66InBaQMe0FQa8svHAzLFb
 MK7kCn3InBuncnfy+7rF6WUovWzYH51ZqwRXwND50Rbd2KoPpM1AxqVEgql8erI+4ixdfGjSE
 PrB7w+qQCOLJoT6NtZm5wi7RwlrDounjK5jV1+HzoIXxDcJhS1wpkpT6Bjl1YwB0mrvrtJykq
 yc1ExbKWcfNOpVAOiDjblN+wy5gHGKO/aFv+OsZ+RKgENsFFnR/QsUU3bqkuvHtb7u+UEIJxd
 2HQJgnYxNvMR42G6Q8uozh9FR4jXey86VfhsQO/grEelJeTnD+rtyRXSvQxEysyvT1sSqvDKq
 lG1OOsPrGn5mwDQHGHrbZWaqXGfVuCM2SqplAnLo0N2FVoAWq8XZEBa0dW5WNW33PEheDT9L1
 J04TS0Npus+qiII4tcAjQEdRAVaaxJAvqNL9m5HkkZd57G3s8GNl7Wx73D26baD632LFja3Z+
 Ou5+ote2Rp99OhcFduh5OZLItt1JTTby/dwq6pvw7wAYOSQTUoAtVx4/cNM6tHxSm40iEhx/B
 CPtyjW63bPVQErsJmi9gsJiBsN5L7c5lBy1
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 01, 2021 at 11:55:14PM +0000, Alexander Lobakin wrote:
> Hi,
>
> From: John Wood <john.wood@gmx.com>
> Date: Sat, 5 Jun 2021 17:04:00 +0200
>
> > +static int brute_task_execve(struct linux_binprm *bprm, struct file *=
file)
> > +{
> > +	struct dentry *dentry =3D file_dentry(bprm->file);
> > +	struct inode *inode =3D file_inode(bprm->file);
> > +	struct brute_stats stats;
> > +	int rc;
> > +
> > +	inode_lock(inode);
> > +	rc =3D brute_get_xattr_stats(dentry, inode, &stats);
> > +	if (WARN_ON_ONCE(rc && rc !=3D -ENODATA))
> > +		goto unlock;
>
> I think I caught a problem here. Have you tested this with
> initramfs?

No, it has not been tested with initramfs :(

> According to init/do_mount.c's
> init_rootfs()/rootfs_init_fs_context(), when `root=3D` cmdline
> parameter is not empty, kernel creates rootfs of type ramfs
> (tmpfs otherwise).
> The thing about ramfs is that it doesn't support xattrs.

It is a known issue that systems without xattr support are not
suitable for Brute (there are a note in the documentation).
However, the purpose is not to panic the system :(

> I'm running this v8 on a regular PC with initramfs and having
> `root=3D` in cmdline, and Brute doesn't allow the kernel to run
> any init processes (/init, /sbin/init, ...) with err =3D=3D -95
> (-EOPNOTSUPP) -- I'm getting a
>
> WARNING: CPU: 0 PID: 173 at brute_task_execve+0x15d/0x200
> <snip>
> Failed to execute /init (error -95)
>
> and so on (and a panic at the end).
>
> If I omit `root=3D` from cmdline, then the kernel runs init process
> just fine -- I guess because initramfs is then placed inside tmpfs
> with xattr support.
>
> As for me, this ramfs/tmpfs selection based on `root=3D` presence
> is ridiculous and I don't see or know any reasons behind that.
> But that's another story, and ramfs might be not the only one
> system without xattr support.
> I think Brute should have a fallback here, e.g. it could simply
> ignore files from xattr-incapable filesystems instead of such
> WARNING splats and stuff.

Ok, it seems reasonable to me: if the file system doesn't support
xattr, but Brute is enabled, Brute will do nothing and the system
will work normally.

I will work on it for the next version.
Thanks for the feedback.

John Wood
