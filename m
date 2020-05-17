Return-Path: <SRS0=U04o=67=lists.openwall.com=kernel-hardening-return-18825-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C4FC433DF
	for <kernel-hardening@archiver.kernel.org>; Sun, 17 May 2020 16:58:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 373C220674
	for <kernel-hardening@archiver.kernel.org>; Sun, 17 May 2020 16:58:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oFbmdXoJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 373C220674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18825-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16169 invoked by uid 550); 17 May 2020 16:58:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16149 invoked from network); 17 May 2020 16:58:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=altgAbX5kmqCSE/VnAq/k8WHhDiX7o4bWc9rHmz5wOo=;
        b=oFbmdXoJ7IKhXz/adk3cWUH02iVLEMbiWPS3oYco9rZQ/I26wyRUSLKaWf24g+fmgM
         0qhq7O2DIUF1Fhk8wDI097fDcjaHjfzIJizUGrWQRXS+4abA7AQP8BA28vbJbHrmAfGO
         XkSjfV7rVvsmFLSl+e1PMrZMYMEMTFax3aKxcsTGkJU3tfeUC9DAiPBYb2u7Xg2ypZuk
         MA4Zpt1cTWT2dI3a0VrQkrK2A89zZAnM1zaEULhYiV+MmlR4kaxnEiXDq+hnDNnofPzl
         F44myrooS17gGNTOq4w+l9JADdcPZhQ1Cb2mWVBLxhNG8vgwHIJ3wPBunDL4edBhA2KH
         4DOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=altgAbX5kmqCSE/VnAq/k8WHhDiX7o4bWc9rHmz5wOo=;
        b=mpnyn78ASCGZy6huEhONM2D4UWLn9dheIgZj0AoOLugtCOQksJmgCj57s2pkTuNOVV
         Fomw7imFSL3Cx2cju4VJS71odn4MhcWamdjDZAA+6PEHeIXgzjVoIsZOK0/6azMeP72n
         vdhWSkWQNe4CxEIMBxYM3IUuln/rt0PfzS4RAWg5J8+iWXlF5oT4RCpGFTuwUO/NSNxl
         p5f3EkTMcDAfTTV0gvOOFMiLj8xg7UIhht90OipJktesjltKsqXela8rAl8tg81KSPNP
         d71MFoodvx5eR7IikkvC4A6GYQyNP1EBH99sq+96pKV7xTjn5j+x2SK6MJA66MJ9ikAC
         xBCw==
X-Gm-Message-State: AOAM5317/Y0IxQW1y7jMbtKpVgH6bfCi8xy0uT2ebN7c+qbn0fKmt/a7
	+fLJBaumgeVxJICJZ+DyZOV+A/gIYrysGXT6VhQ=
X-Google-Smtp-Source: ABdhPJzkS2SOWSJO0UWnl+/Jz2U+Hdy/n0LyIdKaxfJBksl9CvPkj0zWT07DTkmBhBac8VhhDnTeZ/MnxGHqCUexLPc=
X-Received: by 2002:a02:a58b:: with SMTP id b11mr11916189jam.56.1589734682438;
 Sun, 17 May 2020 09:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200505153156.925111-1-mic@digikod.net> <20200505153156.925111-3-mic@digikod.net>
 <202005121407.A339D31A@keescook> <CAP22eLEWW+KjD5rHosZV8vSuBB4YBLh0BQ=4-=kJQt9o=Fx1ig@mail.gmail.com>
 <202005140845.16F1CDC@keescook>
In-Reply-To: <202005140845.16F1CDC@keescook>
From: "Lev R. Oshvang ." <levonshe@gmail.com>
Date: Sun, 17 May 2020 19:57:51 +0300
Message-ID: <CAP22eLEy5nc4u6gPHtY56afrvF9oTNBwRwNAc7Le=Y_8V49nqQ@mail.gmail.com>
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

On Thu, May 14, 2020 at 6:48 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, May 14, 2020 at 11:14:04AM +0300, Lev R. Oshvang . wrote:
> > New sysctl is indeed required to allow userspace that places scripts
> > or libs under noexec mounts.
>
> But since this is a not-uncommon environment, we must have the sysctl
> otherwise this change would break those systems.
>
 But I proposed sysctl on a line below.

> > fs.mnt_noexec_strict =1 (allow, e) , 1 (deny any file with --x
> > permission), 2 (deny when O_MAYEXEC absent), for any file with ---x
> > permissions)
>
> I don't think we want another mount option -- this is already fully
> expressed with noexec and the system-wide sysctl.
>
> --

The intended use of proposed sysctl is to ebable sysadmin to decide
whar is desired semantics  mount with NO_EXEC option.

fs.mnt_noexec_scope =0 |1|2|3
0  - means old behaviour i.e do nor run executables and scripts (default)
1 - deny any file with --x permissions, i.e executables , script and libs
2 - deny any file when O_MAYEXEC is present.

I think this is enough to handle all use cases and to not break
current sysadmin file mounts setting
I oppose the new O_MAY_EXECMOUNT flag, kernel already has MNT_NO_EXEC,
SB_NOEXEC and SB_I_NOEXEC and I frankly do not understand why so many
variants exist.
Lev
