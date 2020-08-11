Return-Path: <SRS0=oZrz=BV=lists.openwall.com=kernel-hardening-return-19602-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAD_ENC_HEADER,BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A38A4C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Aug 2020 19:40:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C700B206DC
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Aug 2020 19:40:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C700B206DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19602-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11922 invoked by uid 550); 11 Aug 2020 19:40:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11897 invoked from network); 11 Aug 2020 19:40:29 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org,  Aleksa Sarai <cyphar@cyphar.com>,  Alexei
 Starovoitov <ast@kernel.org>,  Al Viro <viro@zeniv.linux.org.uk>,  Andrew
 Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,
  Christian Brauner <christian.brauner@ubuntu.com>,  Christian Heimes
 <christian@python.org>,  Daniel Borkmann <daniel@iogearbox.net>,  Deven
 Bowers <deven.desai@linux.microsoft.com>,  Dmitry Vyukov
 <dvyukov@google.com>,  Eric Biggers <ebiggers@kernel.org>,  Eric Chiang
 <ericchiang@google.com>,  Florian Weimer <fweimer@redhat.com>,  James
 Morris <jmorris@namei.org>,  Jan Kara <jack@suse.cz>,  Jann Horn
 <jannh@google.com>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook
 <keescook@chromium.org>,  Lakshmi Ramasubramanian
 <nramas@linux.microsoft.com>,  Matthew Garrett <mjg59@google.com>,
  Matthew Wilcox <willy@infradead.org>,  Michael Kerrisk
 <mtk.manpages@gmail.com>,  Mimi Zohar <zohar@linux.ibm.com>,  Philippe
 =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,  Scott Shell
 <scottsh@microsoft.com>,  Sean Christopherson
 <sean.j.christopherson@intel.com>,  Shuah Khan <shuah@kernel.org>,  Steve
 Dower <steve.dower@python.org>,  Steve Grubb <sgrubb@redhat.com>,  Tetsuo
 Handa <penguin-kernel@I-love.SAKURA.ne.jp>,  Thibaut Sautereau
 <thibaut.sautereau@clip-os.org>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-integrity@vger.kernel.org,
  linux-security-module@vger.kernel.org,  linux-fsdevel@vger.kernel.org
References: <20200723171227.446711-1-mic@digikod.net>
	<20200723171227.446711-4-mic@digikod.net>
Date: Tue, 11 Aug 2020 14:36:38 -0500
In-Reply-To: <20200723171227.446711-4-mic@digikod.net> (=?utf-8?Q?=22Micka?=
 =?utf-8?Q?=C3=ABl_Sala=C3=BCn=22's?=
	message of "Thu, 23 Jul 2020 19:12:23 +0200")
Message-ID: <87a6z1m0u1.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-XM-SPF: eid=1k5a7w-0004Qr-Ti;;;mid=<87a6z1m0u1.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18bRw6Qx631bJvZB6GAyvN2Z5/PhB9504A=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v7 3/7] exec: Move path_noexec() check earlier
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> writes:

> From: Kees Cook <keescook@chromium.org>
>
> The path_noexec() check, like the regular file check, was happening too
> late, letting LSMs see impossible execve()s. Check it earlier as well
> in may_open() and collect the redundant fs/exec.c path_noexec() test
> under the same robustness comment as the S_ISREG() check.
>
> My notes on the call path, and related arguments, checks, etc:

A big question arises, that I think someone already asked.

Why perform this test in may_open directly instead of moving
it into inode_permission.  That way the code can be shared with
faccessat, and any other code path that wants it?

That would look to provide a more maintainable kernel.

Eric


> do_open_execat()
>     struct open_flags open_exec_flags =3D {
>         .open_flag =3D O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
>         .acc_mode =3D MAY_EXEC,
>         ...
>     do_filp_open(dfd, filename, open_flags)
>         path_openat(nameidata, open_flags, flags)
>             file =3D alloc_empty_file(open_flags, current_cred());
>             do_open(nameidata, file, open_flags)
>                 may_open(path, acc_mode, open_flag)
>                     /* new location of MAY_EXEC vs path_noexec() test */
>                     inode_permission(inode, MAY_OPEN | acc_mode)
>                         security_inode_permission(inode, acc_mode)
>                 vfs_open(path, file)
>                     do_dentry_open(file, path->dentry->d_inode, open)
>                         security_file_open(f)
>                         open()
>     /* old location of path_noexec() test */
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Link: https://lore.kernel.org/r/20200605160013.3954297-4-keescook@chromiu=
m.org
> ---
>  fs/exec.c  | 12 ++++--------
>  fs/namei.c |  4 ++++
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index bdc6a6eb5dce..4eea20c27b01 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -147,10 +147,8 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
>  	 * and check again at the very end too.
>  	 */
>  	error =3D -EACCES;
> -	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
> -		goto exit;
> -
> -	if (path_noexec(&file->f_path))
> +	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
> +			 path_noexec(&file->f_path)))
>  		goto exit;
>=20=20
>  	fsnotify_open(file);
> @@ -897,10 +895,8 @@ static struct file *do_open_execat(int fd, struct fi=
lename *name, int flags)
>  	 * and check again at the very end too.
>  	 */
>  	err =3D -EACCES;
> -	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
> -		goto exit;
> -
> -	if (path_noexec(&file->f_path))
> +	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
> +			 path_noexec(&file->f_path)))
>  		goto exit;
>=20=20
>  	err =3D deny_write_access(file);
> diff --git a/fs/namei.c b/fs/namei.c
> index a559ad943970..ddc9b25540fe 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2863,6 +2863,10 @@ static int may_open(const struct path *path, int a=
cc_mode, int flag)
>  			return -EACCES;
>  		flag &=3D ~O_TRUNC;
>  		break;
> +	case S_IFREG:
> +		if ((acc_mode & MAY_EXEC) && path_noexec(path))
> +			return -EACCES;
> +		break;
>  	}
>=20=20
>  	error =3D inode_permission(inode, MAY_OPEN | acc_mode);
