Return-Path: <SRS0=J9tp=64=lists.openwall.com=kernel-hardening-return-18786-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B760C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 08:14:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 652712065D
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 08:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S5Hfe/92"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 652712065D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18786-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30496 invoked by uid 550); 14 May 2020 08:14:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30467 invoked from network); 14 May 2020 08:14:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nW/L8VcZBCn80T+Kxyr4Dt/TzE3U0N3QD8lxLQvkAAk=;
        b=S5Hfe/92gHJ2Kc5wk3x43B4+o6swGaM2Z99CePQdyLGPJPMn30W1UreaPgeaV7cbVx
         6Ksj0zhjZIigUVz3G05Ipvagq3eQpb1Q/Q/Tx8tyQa+Y3+yu0Go8cUlgCEqV6W7Cl/13
         w0tULc6B16J+R+YpVtDBGL0dmKDdpkX/lRVs2dX0SK5Ff3zLv8WUeueCQedF96giMbNd
         /6pcYHqFmFrjBvh+QkmsZoYCmdDYs9frT687Ym8rCKaV5JeSURUb2M9GFNDf+CfgHlRj
         3gpOiN0aHTJt4SRY/3RyuY/0GLK+031DG3E9DyxAiHEq0GrDJ8iLgIcf7dZVSGgZlVW3
         7i/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nW/L8VcZBCn80T+Kxyr4Dt/TzE3U0N3QD8lxLQvkAAk=;
        b=ZQbszbXa7hLJS4aiWTqpXSolUWDMSlYog4iX1AvyjDlyPUrLAUY0jqVJ2o008HvPIP
         j6ZP8na6ovJ7+wJf0EZX7qjOfMjDzI5m/ebsoc3FRpQBdspcWPh7DB6qSQ+6yNXlDrRA
         HgJNZL5rqQCeAROhfmx///ja/QVaTY1dJ1Ioo3uI7goStvDcrZELdZH0s3ZE3ZQi2ORb
         BXQn1e7IuuTIP7a610QGfSnbNQmTcK/cwf90bsykjoXjcghEMypWeqSboRLFf9+7ZnEs
         zTqfneomy4UnNSbq2Z83UrBJlggSO/Ync8eJjc8BCf8eGHrfBPfS96Yn29lX2Yoebg/z
         PCCA==
X-Gm-Message-State: AOAM5318VTaJpdu6A37cwzR6GQ+Dwd5c7dVtylL37SARdJS5jjDwVoHs
	WbmMHo6T6VzYrscb4Nmpzyr7OyMxxsiaAL91xrc=
X-Google-Smtp-Source: ABdhPJxcM2ITNF+8krp3jsHuj5Njt/CXRsPi+FnkXodqYy9dz/7KlWDbKIAYy/B1u704BgQzZ5vke1Oax5ReAe5a8IA=
X-Received: by 2002:a92:84d6:: with SMTP id y83mr1157606ilk.73.1589444055744;
 Thu, 14 May 2020 01:14:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200505153156.925111-1-mic@digikod.net> <20200505153156.925111-3-mic@digikod.net>
 <202005121407.A339D31A@keescook>
In-Reply-To: <202005121407.A339D31A@keescook>
From: "Lev R. Oshvang ." <levonshe@gmail.com>
Date: Thu, 14 May 2020 11:14:04 +0300
Message-ID: <CAP22eLEWW+KjD5rHosZV8vSuBB4YBLh0BQ=4-=kJQt9o=Fx1ig@mail.gmail.com>
Subject: Re: [PATCH v5 2/6] fs: Add a MAY_EXECMOUNT flag to infer the noexec
 mount property
To: Kees Cook <keescook@chromium.org>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, 
	Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Deven Bowers <deven.desai@linux.microsoft.com>, 
	Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>, 
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, 
	Mimi Zohar <zohar@linux.ibm.com>, 
	=?UTF-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-integrity@vger.kernel.org, 
	LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2020 at 12:09 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, May 05, 2020 at 05:31:52PM +0200, Micka=C3=ABl Sala=C3=BCn wrote:
> > This new MAY_EXECMOUNT flag enables to check if the underlying mount
> > point of an inode is marked as executable.  This is useful to implement
> > a security policy taking advantage of the noexec mount option.
> >
Security policy is expressed by sysadmin by mount -noexec very clear,
I don't think there is a need
in sysctl, wish is system-wide

> > This flag is set according to path_noexec(), which checks if a mount
> > point is mounted with MNT_NOEXEC or if the underlying superblock is
> > SB_I_NOEXEC.
> >
> > Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> > Reviewed-by: Philippe Tr=C3=A9buchet <philippe.trebuchet@ssi.gouv.fr>
> > Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> > Cc: Aleksa Sarai <cyphar@cyphar.com>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > ---
> >  fs/namei.c         | 2 ++
> >  include/linux/fs.h | 2 ++
> >  2 files changed, 4 insertions(+)
> >
> > diff --git a/fs/namei.c b/fs/namei.c
> > index a320371899cf..33b6d372e74a 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -2849,6 +2849,8 @@ static int may_open(const struct path *path, int =
acc_mode, int flag)
> >               break;
> >       }
> >
> > +     /* Pass the mount point executability. */
> > +     acc_mode |=3D path_noexec(path) ? 0 : MAY_EXECMOUNT;
> >       error =3D inode_permission(inode, MAY_OPEN | acc_mode);
> >       if (error)
> >               return error;
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 313c934de9ee..79435fca6c3e 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -103,6 +103,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff=
_t offset,
> >  #define MAY_NOT_BLOCK                0x00000080
> >  /* the inode is opened with O_MAYEXEC */
> >  #define MAY_OPENEXEC         0x00000100
> > +/* the mount point is marked as executable */
> > +#define MAY_EXECMOUNT                0x00000200
> >
> >  /*
> >   * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must co=
rrespond
>
> I find this name unintuitive, but I cannot think of anything better,
> since I think my problem is that "MAY" doesn't map to the language I
> want to use to describe what this flag is indicating.
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> --
> Kees Cook


I think that the original patch was perfect, I quite it again
@@ -3167,6 +3167,14 @@ static int may_open(struct path *path, int
acc_mode, int flag)

+
+ if ((acc_mode & MAY_OPENEXEC)
+ && (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))
+ && (path->mnt && (path->mnt->mnt_flags & MNT_NOEXEC)))
+            return -EACCES;
+
+
+
error =3D inode_permission(inode, MAY_OPEN | acc_mode);

As I said in the inline comment above, sysadmin had already express
security policy in a very clear way,
mount -noexec !
I would only check inside inode_permission() whether the file mode is
any  ---x  permission and deny such
open when file is opened with O_MAYEXEC under MNT_NOEXEC mount point

New sysctl is indeed required to allow userspace that places scripts
or libs under noexec mounts.
fs.mnt_noexec_strict =3D0 (allow, e) , 1 (deny any file with --x
permission), 2 (deny when O_MAYEXEC absent), for any file with ---x
permissions)
