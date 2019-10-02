Return-Path: <SRS0=681p=X3=lists.openwall.com=kernel-hardening-return-16984-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B017C10F14
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Oct 2019 21:12:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D69BC21848
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Oct 2019 21:12:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="O8BrNr27"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D69BC21848
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16984-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1427 invoked by uid 550); 2 Oct 2019 21:12:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1409 invoked from network); 2 Oct 2019 21:12:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q2JSS08Ms57UqEsZfow4fHq4+PEYXwM7+yB7IFgfXSw=;
        b=O8BrNr27QXvmNqQqCPd87Q34YcNRBGNZygSd5rEl8zhICGOlt34sSpk4usntjKcnug
         1/WbRDmOoshrLLvkZn51WuDY9r8Y4AMn3uAHHIjRkxy3t53U2Kias4Vl6Gv28bkF7bhf
         mmZZjI0YNbWDyo8B8eBw3LasbJo/z9WigOs51+Wtvb/rJdi7YqZzk8n84YPX1aDQbDvL
         sCLh/SHl2G56jiYm3WglyjdxCfb3sC9FTAPFlroY0Ki2oPYCAg4OspWbJbyYeT9nvSZ7
         Wy+Ks1SGgCdkNVLmdtISHAeoYCRv2u8eqtd4xSBsqSxjLE+/dfqbPJzE0NxYFuhkpOvp
         q3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q2JSS08Ms57UqEsZfow4fHq4+PEYXwM7+yB7IFgfXSw=;
        b=X8nvZ1ramtJkHHPuO0PI++vOutlp/e7EVpdMhtNUFL31geWOX35VDQnc5gE39ddyC7
         Jj0Yt3s5+bVQmctUpwAzhs/7AJA2ygpeZUZ2Ke+ZpAmR26pRNNMr/Uh1rBPEcZIeu0i4
         cINWSk3bnSBg2nuIOZLMr3nkhmmzZVu4KvpBGDGl2GTX/pqDV/OAGMz8f13JLvI1/Q55
         5qE7iYqb4JlIa9ptDfyixMx/zh34jJzHs23Npp6/ZKQIIzT+V8dsGYFejk6IMfSsZjbt
         3TSYapr4zFEALSg8u5sj0cuLFD9x3lPCFTVyL/zBnvIwR563t4+VyjxDJWJlKTmOj6Ck
         jhNw==
X-Gm-Message-State: APjAAAWMznaSxdfSTG5D7Rdn0xfLCdFR6+3IgqmrgEPHxD7h4tgMLh12
	ypBXaGS5hwinqBvl3SoqfFohYrWiaCOEqNqHDE8y
X-Google-Smtp-Source: APXvYqxLPUEu90fIr51j/ZlGZU7LVnF40q+p+8nV43id+zxjf17VYMDmWZtju1P5RtNnFnFv9JBQFsueA01CfQe020o=
X-Received: by 2002:a2e:5418:: with SMTP id i24mr3665540ljb.126.1570050732902;
 Wed, 02 Oct 2019 14:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <201910010945.CAABF57@keescook>
In-Reply-To: <201910010945.CAABF57@keescook>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 2 Oct 2019 17:12:01 -0400
Message-ID: <CAHC9VhTwyNsW5xVNsb+jXhgoLL86daZL1cWG9d+DVB0dQJAgMQ@mail.gmail.com>
Subject: Re: [PATCH v2] audit: Report suspicious O_CREAT usage
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?J=C3=A9r=C3=A9mie_Galarneau?= <jeremie.galarneau@efficios.com>, 
	s.mesoraca16@gmail.com, viro@zeniv.linux.org.uk, dan.carpenter@oracle.com, 
	akpm@linux-foundation.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	kernel-hardening@lists.openwall.com, linux-audit@redhat.com, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 1, 2019 at 12:48 PM Kees Cook <keescook@chromium.org> wrote:
>
> This renames the very specific audit_log_link_denied() to
> audit_log_path_denied() and adds the AUDIT_* type as an argument. This
> allows for the creation of the new AUDIT_ANOM_CREAT that can be used to
> report the fifo/regular file creation restrictions that were introduced
> in commit 30aba6656f61 ("namei: allow restricted O_CREAT of FIFOs and
> regular files"). Additionally further clarifies the existing
> "operations" strings.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
>  - fix build failure typo in CONFIG_AUDIT=n case
>  - improve operations naming (paul)
> ---
>  fs/namei.c                 |  8 ++++++--
>  include/linux/audit.h      |  5 +++--
>  include/uapi/linux/audit.h |  1 +
>  kernel/audit.c             | 11 ++++++-----
>  4 files changed, 16 insertions(+), 9 deletions(-)

Thanks for the update, but I think we need another respin, see below.

> diff --git a/fs/namei.c b/fs/namei.c
> index 671c3c1a3425..2d5d245ae723 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -925,7 +925,7 @@ static inline int may_follow_link(struct nameidata *nd)
>                 return -ECHILD;
>
>         audit_inode(nd->name, nd->stack[0].link.dentry, 0);
> -       audit_log_link_denied("follow_link");
> +       audit_log_path_denied(AUDIT_ANOM_LINK, "sticky_follow_link");

Maybe I should have been more clear in the last patch thread, but my
suggested name change was only for the new records you are adding; we
don't want to change the operation/op names for existing records.  In
the above change, "follow_link" should stay "follow_link".

> @@ -993,7 +993,7 @@ static int may_linkat(struct path *link)
>         if (safe_hardlink_source(inode) || inode_owner_or_capable(inode))
>                 return 0;
>
> -       audit_log_link_denied("linkat");
> +       audit_log_path_denied(AUDIT_ANOM_LINK, "unowned_linkat");

See above, this should stay as "linkat".

> @@ -1031,6 +1031,10 @@ static int may_create_in_sticky(struct dentry * const dir,
>             (dir->d_inode->i_mode & 0020 &&
>              ((sysctl_protected_fifos >= 2 && S_ISFIFO(inode->i_mode)) ||
>               (sysctl_protected_regular >= 2 && S_ISREG(inode->i_mode))))) {
> +               const char *operation = S_ISFIFO(inode->i_mode) ?
> +                                       "sticky_create_fifo" :
> +                                       "sticky_create_regular";
> +               audit_log_path_denied(AUDIT_ANOM_CREAT, operation);

This is a new record, so this is fine.  Thanks for changing this.

-- 
paul moore
www.paul-moore.com
