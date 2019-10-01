Return-Path: <SRS0=bMCM=X2=lists.openwall.com=kernel-hardening-return-16979-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D0FC388F3
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Oct 2019 05:38:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 803C421783
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Oct 2019 05:38:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="No55bwmG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 803C421783
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16979-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32489 invoked by uid 550); 1 Oct 2019 05:38:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32462 invoked from network); 1 Oct 2019 05:38:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a+1iZ6wS7UmVYZ5VqPhsnf3EVMkX+PkLBru96WlvsJc=;
        b=No55bwmG/L3BtmQiCDl24RyHnFVFpkgAKrDjLGbvq1NfTtAOkrykGkj6Imi9ZnHyXa
         EiNq6uW0Nm9WNHePE1W7du6eNPRxhtGDghLypTe3iULUwZftnmW35zxZ3XkmHDBkqvvW
         /RPPUPeB9Nu0Ogi9PrtPxQrUIEVvELc5RLq4MjS2+p7R+/FDEeZpnXdoU1qJuaE52Hze
         NTtHO2EJUMeM+iXZT6U7/+eGoKEu8JB4wsVRqiB+hndY+CxidLc4V/hDDuDrYChX/PGM
         YYK9C4p77VymqVtn5l/ER6MXhoCVNF4DzJ8MDYjBiew2cHUWBVmiEkgGCeasXo2YIzvi
         DzLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a+1iZ6wS7UmVYZ5VqPhsnf3EVMkX+PkLBru96WlvsJc=;
        b=SbweMPsIpMCcO3dZFGITzaoOAw4eHix5ELwngv83P8srYHU+mWlmceRYJFY/fjuuHy
         LThD8Hqmjs2gbFKOmaHjfPvvaeh7/c+mVFAVsulMg0Wn3iHpI1+0eXShXt+Nrpe1w69k
         WZEkiV9CuUNBwt4oTR7d56Jl+gUJgS8TE2xJMWenr2NE3psCZke3lBJp5NI1Zdnp0a4z
         TWJ5s/CHy1wvIXOzxfstih9W7Btj2Mq3kH4OCXJBiH4MRvWuPTjwtF7RwWWt1FUp/uhv
         vEq/ZhN9TBlhMlfjoxF/8+MLgCGFfC5KEmeHd1WcoYHwyCJcq4FLnA/oE93GAanEBSJr
         fm1Q==
X-Gm-Message-State: APjAAAX0S57Za4EwXbkjSdE5P5oUasy2TIqH4qMbuDhqkOYM32HeGvCj
	APoJMzKfcKLYebI6lugNaLK5jBURvOPfFbCe4bRB
X-Google-Smtp-Source: APXvYqy/yAx/jAVUndYWQYKxPBhFnrOpQXpPdMFCCav/qlkLpgYJVFIVF2+aoOudD+nt/Qyd7Dj4SpqfugOAcxDaE04=
X-Received: by 2002:a19:6517:: with SMTP id z23mr7656913lfb.31.1569908291445;
 Mon, 30 Sep 2019 22:38:11 -0700 (PDT)
MIME-Version: 1.0
References: <201909251348.A1542A52@keescook>
In-Reply-To: <201909251348.A1542A52@keescook>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 1 Oct 2019 01:37:59 -0400
Message-ID: <CAHC9VhQGAVejYvkvDQ_-egvMYn7VvY9WtdCZvANhmkDswBL8YA@mail.gmail.com>
Subject: Re: [PATCH] audit: Report suspicious O_CREAT usage
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?J=C3=A9r=C3=A9mie_Galarneau?= <jeremie.galarneau@efficios.com>, 
	s.mesoraca16@gmail.com, viro@zeniv.linux.org.uk, dan.carpenter@oracle.com, 
	akpm@linux-foundation.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	kernel-hardening@lists.openwall.com, linux-audit@redhat.com, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2019 at 5:02 PM Kees Cook <keescook@chromium.org> wrote:
>
> This renames the very specific audit_log_link_denied() to
> audit_log_path_denied() and adds the AUDIT_* type as an argument. This
> allows for the creation of the new AUDIT_ANOM_CREAT that can be used to
> report the fifo/regular file creation restrictions that were introduced
> in commit 30aba6656f61 ("namei: allow restricted O_CREAT of FIFOs and
> regular files"). Without this change, discovering that the restriction
> is enabled can be very challenging:
> https://lore.kernel.org/lkml/CA+jJMxvkqjXHy3DnV5MVhFTL2RUhg0WQ-XVFW3ngDQO=
dkFq0PA@mail.gmail.com
>
> Reported-by: J=C3=A9r=C3=A9mie Galarneau <jeremie.galarneau@efficios.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This is not a complete fix because reporting was broken in commit
> 15564ff0a16e ("audit: make ANOM_LINK obey audit_enabled and
> audit_dummy_context")
> which specifically goes against the intention of these records: they
> should _always_ be reported. If auditing isn't enabled, they should be
> ratelimited.
>
> Instead of using audit, should this just go back to using
> pr_ratelimited()?
> ---
>  fs/namei.c                 |  7 +++++--
>  include/linux/audit.h      |  5 +++--
>  include/uapi/linux/audit.h |  1 +
>  kernel/audit.c             | 11 ++++++-----
>  4 files changed, 15 insertions(+), 9 deletions(-)

...

> diff --git a/fs/namei.c b/fs/namei.c
> index 671c3c1a3425..0e60f81e1d5a 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1031,6 +1031,9 @@ static int may_create_in_sticky(struct dentry * con=
st dir,
>             (dir->d_inode->i_mode & 0020 &&
>              ((sysctl_protected_fifos >=3D 2 && S_ISFIFO(inode->i_mode)) =
||
>               (sysctl_protected_regular >=3D 2 && S_ISREG(inode->i_mode))=
))) {
> +               audit_log_path_denied(AUDIT_ANOM_CREAT,
> +                                     S_ISFIFO(inode->i_mode) ? "fifo"
> +                                                             : "regular"=
);
>                 return -EACCES;

Other callers typically pass an operation value more closely tied to
the syscall/function name, and that somewhat makes sense since the
syscall/function name is often verb-ish.  The code above, while
helpful in the sense that it distinguishes between types of inodes, it
doesn't give much indication about the "operation" which failed.  I'm
open to suggestions, but something like "sticky_create_fifo" seems
more consistent which current usage.  Thoughts?

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index aee3dc9eb378..b3715e2ee1c5 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -217,7 +218,7 @@ static inline void audit_log_d_path(struct audit_buff=
er *ab,
>  { }
>  static inline void audit_log_key(struct audit_buffer *ab, char *key)
>  { }
> -static inline void audit_log_link_denied(const char *string)
> +static inline void audit_log_path_denied(int type, const char *string);
>  { }

I probably wouldn't make you respin just for this, but since you may
need to respin this anyway, you might as well fix the above.

--=20
paul moore
www.paul-moore.com
