Return-Path: <SRS0=hrJa=D2=lists.openwall.com=kernel-hardening-return-20223-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907EDC433E7
	for <kernel-hardening@archiver.kernel.org>; Mon, 19 Oct 2020 16:58:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 74FBF22269
	for <kernel-hardening@archiver.kernel.org>; Mon, 19 Oct 2020 16:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74FBF22269
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20223-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20371 invoked by uid 550); 19 Oct 2020 16:58:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20343 invoked from network); 19 Oct 2020 16:58:40 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hL7mfN1EupeS+kSdK5Vs5Sf+DfzTZOfmEItZgZZEYaA=;
        b=oymJ99x2wz9ZiEwPXhzvqoJ9vMUE44Uk5rh3Q/909+GmDY6Gl+VkcgVZ3UCCaYH0an
         IJJllfFT5+M8GLKjFQnRcwUKCaoDbtXhBlNeEKn3lrOgLsumZcyiWQsWeVEHmrEMbUdq
         gg1xmZvAqcPHN/baahbLwtAGwAbdcLSNuIvw9EitR9hXzoC9OBf6M2qvJCmpOrw9O5Ig
         vTknOHMY0rtAfq2eWyDhrAMGuRB4jk7OfmbYCKLQFCldjbL8E5ErZT02hvF5K/jlBm+4
         glfcvBw8n4mu+Sj6uBuW6fjaB1vbG46qldpnrNYKXeAOEicMp6SrTGQbzxfB1sAdHiUa
         soAA==
X-Gm-Message-State: AOAM530ukmTCihxgLwAowyu5TOC55d+kifwe2+2b4o6tKfxcgSVPDpDM
	MYRA+Oz8VqmKwkO3MwWofhZsI43T6TC04OjWV0s=
X-Google-Smtp-Source: ABdhPJwtsUP8OaqlrBo/FWg0iCrXu7PdM3v6/RshAxTARIxWSfsYxMhDPOLE743HjM1wPlbcpacytmQvt8D03nTnkIg=
X-Received: by 2002:a9d:3b76:: with SMTP id z109mr676938otb.250.1603126709134;
 Mon, 19 Oct 2020 09:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <20201019164932.1430614-1-mic@digikod.net> <20201019164932.1430614-3-mic@digikod.net>
In-Reply-To: <20201019164932.1430614-3-mic@digikod.net>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 19 Oct 2020 18:58:17 +0200
Message-ID: <CAMuHMdV6Ee0pU119akfK36FKEp1_XHO_ka0LFSE1Yn3qUjJ_0g@mail.gmail.com>
Subject: Re: [RESEND PATCH v11 2/3] arch: Wire up trusted_for(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
	Christian Brauner <christian.brauner@ubuntu.com>, Christian Heimes <christian@python.org>, 
	Deven Bowers <deven.desai@linux.microsoft.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, 
	Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, 
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matthew Garrett <mjg59@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	=?UTF-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@clip-os.org>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, 
	Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	linux-integrity <linux-integrity@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2020 at 6:50 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> From: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
>
> Wire up trusted_for(2) for all architectures.
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>

>  arch/m68k/kernel/syscalls/syscall.tbl       | 1 +

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

(haven't seen any other arch Acked-by tags yet?)

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
