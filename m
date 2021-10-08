Return-Path: <SRS0=e7ja=O4=lists.openwall.com=kernel-hardening-return-21434-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7ACC433F5
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 Oct 2021 22:45:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A8D5C60F9E
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 Oct 2021 22:45:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A8D5C60F9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 26375 invoked by uid 550); 8 Oct 2021 22:45:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26259 invoked from network); 8 Oct 2021 22:45:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tZEn/oAYWz3OcPJexi2kL6PvuHBhh8RYYUTzGNKbmSU=;
        b=DhKhOYtI0pBL6NCNFhLl35WOj9Pbn0YptqtJC1eqqOh1krXIhDiyulLRdDnN09WxhN
         4ODUUIY2goSTSm/XDlA9aerxN9TrWKJwe4C0uO6BXyJUc/M0Rb4Qo34q+wo1Cs6Kdbrx
         wM6E7zu705f4gxd7Ly+0oFdjD/mjV9w3i9uaQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tZEn/oAYWz3OcPJexi2kL6PvuHBhh8RYYUTzGNKbmSU=;
        b=A9Gj/TsUt/B97zuvQpHCL1wt+cG9p9M4EnWZrCTMadYynMH+Uvj6aYVEiMiBtjrNLm
         cxGSofStqHpGcq31D1/ePgj9e/rEXi+FUWZlOkZr+HFvIv76FThCH0sGFSqaTzmc28lo
         cGE2A2R7MvA6uEmJIHIBpV6oRD0mVuTAdZ+8pBvRHlCsvMxq4cEkkFO/vdnHuGVOS+YO
         o9xj+Dy5jJeHddP4Vm5tYE0wFC9x0/6EoX2Y+wEwLQBszC73IKDKX8wuKkai3+XAzXGx
         7XWGNquySrGN5/2Wgf1WPpgM++6pd6jtaT2s8lkoHp+8VNOocDP9HE4QayMiDJdOxQAy
         gjBQ==
X-Gm-Message-State: AOAM530YoNLoH75jjjKUi9Vxbg0XjPV1blWjRSVyBXvJvZI2qINdoCgx
	dnWdop9BB1gfjRBWIy+PmzKKpg==
X-Google-Smtp-Source: ABdhPJzc82UFKnEHL2nXeW/1+UZrI2+VOZcKuFOfe0n0xCQmI8hpLGTGT0H7X/rjlFKvQ2WBHiiUwA==
X-Received: by 2002:a63:cc48:: with SMTP id q8mr6758353pgi.171.1633733091937;
        Fri, 08 Oct 2021 15:44:51 -0700 (PDT)
Date: Fri, 8 Oct 2021 15:44:51 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v14 3/3] selftest/interpreter: Add tests for
 trusted_for(2) policies
Message-ID: <202110081544.85B7DA3@keescook>
References: <20211008104840.1733385-1-mic@digikod.net>
 <20211008104840.1733385-4-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211008104840.1733385-4-mic@digikod.net>

On Fri, Oct 08, 2021 at 12:48:40PM +0200, Mickaël Salaün wrote:
> From: Mickaël Salaün <mic@linux.microsoft.com>
> 
> Test that checks performed by trusted_for(2) on file descriptors are
> consistent with noexec mount points and file execute permissions,
> according to the policy configured with the fs.trust_policy sysctl.
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>

Thanks for the adjustments!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
