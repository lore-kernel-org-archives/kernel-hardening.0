Return-Path: <SRS0=IAkm=LC=lists.openwall.com=kernel-hardening-return-21293-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18616C47082
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Jun 2021 23:19:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 238CB61178
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Jun 2021 23:19:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 238CB61178
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21293-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20124 invoked by uid 550); 8 Jun 2021 23:19:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20102 invoked from network); 8 Jun 2021 23:19:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UYnHXpjkxY6uN8Q/wAdT4oZuTb3kldbBA0o55ZnXLbI=;
        b=VDGAYt9zeOJIjafEo+B67uPbBGKQhrSGnf7Qo9Ch6H/mTASRST0oDv92Nf7ui6OeS8
         iB3NOQV0MMtCh2uBcA+Npibc6zFdC9xeu4KT1yRo8M0w7oGssOjX8MMlaVOz2EjWKrbi
         wCpTzbJv8yEONP8oFpas7EKEl1l7Ccqy2QOmo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UYnHXpjkxY6uN8Q/wAdT4oZuTb3kldbBA0o55ZnXLbI=;
        b=tLER5bKdAxOs6v17bkCtE7V4YosllyIqbWUsW3ZqR5vRXMXCfZgEX4UrX3+fmKFzrr
         g3kpTFSKzWgQ2TWZ5MvdRDbQCB+sdgQkXJ589kQiOfhfhN0G9WHOAOyL/RpDgVnEZ3Dk
         T6YckeXgaRP1UF1qku9WDa7sNtPrqDcjghxwoNt0EVuWwJLewUgJ6oBzUKoqoDqTEzHB
         VZREennph6DEX/dXd8Jn2CwhTLlVprq3MwnKOQg31MBPGLgLawf6SQINqRQMsaNRa1Na
         PiALLQEcIg3yW32wdpfhTX7kbYUy/ZbBoZYVxG9dtW7WwGmnMsoZzmS4eLKM22XaYOCW
         ABbg==
X-Gm-Message-State: AOAM533SWah64vAkDatZyqU6L6w+oaGT0lw8P9CsV2BPk0CHaidSHynd
	cdSL5em7/sTpj/eV8wzjlqw8uQ==
X-Google-Smtp-Source: ABdhPJy13j1j0ODNi7LI1+2LKQunbW8Wx/i0jcdBN55+DupC2NcBqv+Cq0yP0XhoUlI386xpojybKg==
X-Received: by 2002:a62:be03:0:b029:2e9:fe8c:effe with SMTP id l3-20020a62be030000b02902e9fe8ceffemr2325280pff.34.1623194373956;
        Tue, 08 Jun 2021 16:19:33 -0700 (PDT)
Date: Tue, 8 Jun 2021 16:19:31 -0700
From: Kees Cook <keescook@chromium.org>
To: John Wood <john.wood@gmx.com>
Cc: Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [PATCH v8 0/8] Fork brute force attack mitigation
Message-ID: <202106081616.EC17DC1D0D@keescook>
References: <20210605150405.6936-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210605150405.6936-1-john.wood@gmx.com>

On Sat, Jun 05, 2021 at 05:03:57PM +0200, John Wood wrote:
> [...]
> the kselftest to avoid the detection ;) ). So, in this version, to track
> all the statistical data (info related with application crashes), the
> extended attributes feature for the executable files are used. The xattr is
> also used to mark the executables as "not allowed" when an attack is
> detected. Then, the execve system call rely on this flag to avoid following
> executions of this file.

I have some concerns about this being actually usable and not creating
DoS situations. For example, let's say an attacker had found a hard-to-hit
bug in "sudo", and starts brute forcing it. When the brute LSM notices,
it'll make "sudo" unusable for the entire system, yes?

And a reboot won't fix it, either, IIUC.

It seems like there is a need to track "user" running "prog", and have
that be timed out. Are there use-cases here where that wouldn't be
sufficient?

-Kees

-- 
Kees Cook
