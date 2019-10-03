Return-Path: <SRS0=BHLj=X4=lists.openwall.com=kernel-hardening-return-16987-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B464C10F14
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Oct 2019 18:29:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 595872086A
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Oct 2019 18:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="SqOVYIgy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 595872086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16987-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27986 invoked by uid 550); 3 Oct 2019 18:29:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27968 invoked from network); 3 Oct 2019 18:29:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2cO77cLY9Zi5R0T68SRSCW4d8IffVADLpJPQ8SXEy8c=;
        b=SqOVYIgy87r6YtFTTSo9IZe+fDrUsz6DGqmrCEZAnJwFB7tO2dmG/aN/PlwDaJNECn
         kpXEzPAlsE2a8m2uf1Jff+hFsdVmg5kJUzZe4/Q/9cI9cd2/P2y47+3YWC/gG8X9cuim
         Cla4F1XSGPdDS6kSLMnITzhr0WxlrK5UOkUd5ybXXi5S0ZAv+kLNviYNWAKS2RMqXJJi
         F8N3bi87ArMe5/5QwCfc1mk+QhmpYL3miNsati1Liw2wVhmJdDUkkQLYiYJQbWYGqCBQ
         YTjv6q42JzBtEvqCcZ35Wkg0gm4YV7zv0p9S4+cwtcq7gM35s1E+Zqw6VSVe3mNJnjAX
         4LzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2cO77cLY9Zi5R0T68SRSCW4d8IffVADLpJPQ8SXEy8c=;
        b=t/c2Ocs2qTtKkrPrP7hPg0bkIyPZnpgt1UpbUasdcRuZAv6xSDe1dy0cRNova/6/3a
         XldeRWcNWzM1p58Bxi2y6iWFsV5w0GVVQBOFqoTJWcDITU91liAwkI5sIMcGPxk6x0cB
         soUsQDYGX9tW00+lZNRqplOvWVuLJSoQrMfjh8GXHE7+e4XAGzIWO+ay2pkRLL+Ckyr2
         5kylT06Wr5sN4glU7f6LDaHOfS/7kuvzOfYf5UMul341ixYyAmEnAL8ilnDq1eQ8F1Y5
         ZZ6VWXWSGEN/TjlB60ORFXZ3lecqdXS3/LbO/C0Lsm+MMyIYK3kbvlfXUGFC/rlra2dy
         4VGw==
X-Gm-Message-State: APjAAAW2uvGZAtkx4/NxC1eipD6RMm6nn7amEoYWH3f1joqHG1z+uqIW
	5uVJYxmE8PwCRGulitHTNBng8bGGY3owhzF65bqv
X-Google-Smtp-Source: APXvYqziNAxWP+LWtRPmp0JQpUGI/15O8lUpsN9fOIt1PlWaVDDr0iDcTZbKN2QdCZ+ABWX+Rg5xj+YrJvdZNibPWds=
X-Received: by 2002:a2e:b4c5:: with SMTP id r5mr679986ljm.54.1570127367536;
 Thu, 03 Oct 2019 11:29:27 -0700 (PDT)
MIME-Version: 1.0
References: <201910021640.B01FA41@keescook>
In-Reply-To: <201910021640.B01FA41@keescook>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 3 Oct 2019 14:29:17 -0400
Message-ID: <CAHC9VhQKyHAvNhuquVEYXP9U7ix2pDwXGnRO6QaxYTUKA08=UQ@mail.gmail.com>
Subject: Re: [PATCH v3] audit: Report suspicious O_CREAT usage
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, 
	=?UTF-8?Q?J=C3=A9r=C3=A9mie_Galarneau?= <jeremie.galarneau@efficios.com>, 
	s.mesoraca16@gmail.com, viro@zeniv.linux.org.uk, dan.carpenter@oracle.com, 
	akpm@linux-foundation.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	kernel-hardening@lists.openwall.com, linux-audit@redhat.com, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Oct 2, 2019 at 7:42 PM Kees Cook <keescook@chromium.org> wrote:
>
> This renames the very specific audit_log_link_denied() to
> audit_log_path_denied() and adds the AUDIT_* type as an argument. This
> allows for the creation of the new AUDIT_ANOM_CREAT that can be used to
> report the fifo/regular file creation restrictions that were introduced
> in commit 30aba6656f61 ("namei: allow restricted O_CREAT of FIFOs and
> regular files").
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v3:
>  - retain existing operation names (paul)
> v2:
>  - fix build failure typo in CONFIG_AUDIT=n case
>  - improve operations naming (paul)
> ---
>  fs/namei.c                 |  8 ++++++--
>  include/linux/audit.h      |  5 +++--
>  include/uapi/linux/audit.h |  1 +
>  kernel/audit.c             | 11 ++++++-----
>  4 files changed, 16 insertions(+), 9 deletions(-)

Merged into audit/next - thanks!

-- 
paul moore
www.paul-moore.com
