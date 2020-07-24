Return-Path: <SRS0=Z7vA=BD=lists.openwall.com=kernel-hardening-return-19447-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20659C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 19:04:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 73F5F206D8
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 19:04:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YJdzU2vs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73F5F206D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19447-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9719 invoked by uid 550); 24 Jul 2020 19:04:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9698 invoked from network); 24 Jul 2020 19:04:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LrMXrDf7YIZaoWeBKOjSOSMpqfT8SAqX0JXj+wrASIM=;
        b=YJdzU2vsfQm7AZSEbQDHOGAXkb0FDmlYvGdDHcCBV0Mb+I/0YGXEnNHZP0ITEGdZnq
         rMUzebIoCugRClDH5RJXQ2VNELpwlavB8ApMKzNJeTwVnKrJanhG9XCaDVo5IwEReNVE
         3/qzt3XofNbnyZe3522KpHnb11vBLC4noGHZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LrMXrDf7YIZaoWeBKOjSOSMpqfT8SAqX0JXj+wrASIM=;
        b=CetKLjtX6BYywED1JttJhr05FhGFMFBJrb3O1IrzEqDXGwK3TtpRZZanHwPhH78aUi
         cxgUZoUm3izeGlntWo52TwGru5P+qrg67UsVFzlOhdL17upQVgtvd5LKsgNvjsr20rNv
         TKnZ0ZtSjLRCuEYPYJoI59IszJwsXLHm3eDz3Ox9pxQS+r1krPbpTWuSVj0gdAMz2xDJ
         Nqenk+g2br8B1sNUz/bASOOBwWlWjV+rV2WX2CKt7Wk2+forpDEiUnG4duNJu5DbtJki
         8fCJRcrICuYBxHBMBn4btO24x48cZAAbzGgQKMki1MkJMpsFI2trI3/cvvt6qF8q85FS
         R13w==
X-Gm-Message-State: AOAM5325JWjlcHui6VAoKMzUCoSTdp0WByWNAxX3KTvNxCUm6OjbZwfb
	pn1pNzPSVQl0opv70ozZjCT+0Q==
X-Google-Smtp-Source: ABdhPJwByOH/4ROCOy3QCc3kWU3xI1XY75NRzmOAdHNrzalnVxff+4jx3AjnVMN92eX9iE8obAmE4g==
X-Received: by 2002:a62:5297:: with SMTP id g145mr10327624pfb.28.1595617479754;
        Fri, 24 Jul 2020 12:04:39 -0700 (PDT)
Date: Fri, 24 Jul 2020 12:04:38 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 7/7] ima: add policy support for the new file open
 MAY_OPENEXEC flag
Message-ID: <202007241204.3DD9B905E@keescook>
References: <20200723171227.446711-1-mic@digikod.net>
 <20200723171227.446711-8-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200723171227.446711-8-mic@digikod.net>

On Thu, Jul 23, 2020 at 07:12:27PM +0200, Mickaël Salaün wrote:
> From: Mimi Zohar <zohar@linux.ibm.com>
> 
> The kernel has no way of differentiating between a file containing data
> or code being opened by an interpreter.  The proposed O_MAYEXEC
> openat2(2) flag bridges this gap by defining and enabling the
> MAY_OPENEXEC flag.
> 
> This patch adds IMA policy support for the new MAY_OPENEXEC flag.
> 
> Example:
> measure func=FILE_CHECK mask=^MAY_OPENEXEC
> appraise func=FILE_CHECK appraise_type=imasig mask=^MAY_OPENEXEC
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>

^^^ this S-o-b should the last in the fields.

> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> Reviewed-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> Link: https://lore.kernel.org/r/1588167523-7866-3-git-send-email-zohar@linux.ibm.com

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
