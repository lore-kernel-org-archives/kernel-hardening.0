Return-Path: <SRS0=7rj4=6O=lists.openwall.com=kernel-hardening-return-18684-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FB9C8300A
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Apr 2020 11:01:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1D9422078D
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Apr 2020 11:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f5VuDmhy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D9422078D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18684-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1097 invoked by uid 550); 30 Apr 2020 11:01:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1065 invoked from network); 30 Apr 2020 11:01:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lFFxK4DtytcE6RpAFl8YJiEBCoYUrJi5EC/p8/Y25iA=;
        b=f5VuDmhyUjEspScUeszN5n8DPGcEiF/Kok9r2XQcaRe8HDfwuUTjWP4f00L9FgVpR6
         NwrnkORD6lm6KvLluh5w59qQbKGxSAS44/NqciSnz039zIu/mHcI+vU5AHQsV+NmkfVr
         2wk0iYhDyLiGTZFSRNC7xo8I9oxNI1yh7E8bUl9fe+UMfMfdBO5QFMqgwxpgtqJixBIJ
         nzKHb0khXvNE1r3a2NF9Ib5NUDnWpC51UlhYpkPtdJXUcSg/2kdiJzqetXJ7v7YWlZr/
         RRuw/gMakeQ5lAPHyVeiUFgbvw9ZfIwxNWNJ87QjflMf7FFzL6O7O7DWFFSgP58BUTAu
         l+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lFFxK4DtytcE6RpAFl8YJiEBCoYUrJi5EC/p8/Y25iA=;
        b=YCEHgMYMVScqD5j1GaoDc7QWoEvMvAAHlLCN8MeAFF1l66rqCyBqpDPUjYj7IyhUFB
         sQD4WzdeR3wmDpfNiyK2xL4HbJ8MAfW/at8q4KmFuAhz2vVnc7hlEL5iFcwKfphJGub/
         CfEKYTWXZ80YPcXnrSRTg1/0FFjC+0B8wfeLMWyqnA28WI5+wEPvJuVL63kOUoE6ihyf
         zv0YdL9TMyRHfhWel4STWSqVCEWGjww+IMY17I0k/yEdqhDHbptL8nUaG1znA/kiJ9Rz
         CFher7i+LlI/e1Vp5BHRad6IGt+2BQ/NNd3QJvo26PwStSaGTQhYF/XVAPhuozACyNGs
         Codw==
X-Gm-Message-State: AGi0PuZf+sIxUTQ55TBPyMmxJY/BNzCtyimB/c92DO5LSdCHRXMHAJIN
	Q5BG2AufKCnswEi3NykqxBkB4p5cDg0+2Ej2KYQ=
X-Google-Smtp-Source: APiQypLouP4lVbKqpnSX7OlYl+j6EOSiT1pw349EOnWeumTX5PjyI+H/ngeTt/eryzVdA1cq5n6/uYXQL49LzeEGesE=
X-Received: by 2002:a1c:a512:: with SMTP id o18mr2301640wme.138.1588244491958;
 Thu, 30 Apr 2020 04:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200428175129.634352-1-mic@digikod.net> <20200430015429.wuob7m5ofdewubui@yavin.dot.cyphar.com>
In-Reply-To: <20200430015429.wuob7m5ofdewubui@yavin.dot.cyphar.com>
From: "Lev R. Oshvang ." <levonshe@gmail.com>
Date: Thu, 30 Apr 2020 14:01:21 +0300
Message-ID: <CAP22eLE6DA5P+Cx6aVP=eq3tKRGz=+P+w8omk3CcEXVo0f1Nfg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Add support for RESOLVE_MAYEXEC
To: Aleksa Sarai <cyphar@cyphar.com>, viro@zeniv.linux.org.uk
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Eric Chiang <ericchiang@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, 
	Mimi Zohar <zohar@linux.ibm.com>, kernel-hardening@lists.openwall.com, 
	LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2020 at 4:55 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
>
> On 2020-04-28, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> wrote:
> > The goal of this patch series is to enable to control script execution
> > with interpreters help.  A new RESOLVE_MAYEXEC flag, usable through
> > openat2(2), is added to enable userspace script interpreter to delegate
> > to the kernel (and thus the system security policy) the permission to
> > interpret/execute scripts or other files containing what can be seen as
> > commands.
> >
> > This third patch series mainly differ from the previous one by relying
> > on the new openat2(2) system call to get rid of the undefined behavior
> > of the open(2) flags.  Thus, the previous O_MAYEXEC flag is now replace=
d
> > with the new RESOLVE_MAYEXEC flag and benefits from the openat2(2)
> > strict check of this kind of flags.
>
> My only strong upfront objection is with this being a RESOLVE_ flag.
>
> RESOLVE_ flags have a specific meaning (they generally apply to all
> components, and affect the rules of path resolution). RESOLVE_MAYEXEC
> does neither of these things and so seems out of place among the other
> RESOLVE_ flags.
>
> I would argue this should be an O_ flag, but not supported for the
> old-style open(2). This is what the O_SPECIFIC_FD patchset does[1] and I
> think it's a reasonable way of solving such problems.
>
> --
> Aleksa Sarai
> Senior Software Engineer (Containers)
> SUSE Linux GmbH
> <https://www.cyphar.com/>

I see that we discuss here the problem which was originated due to the
lack of flags checks at open()
As a newbie in kernel I want to propose maybe naive approach - add
missing flag cheeks to open().
In order to not break badly coded  application at once (applications
hat pass full u32 number I propose to introduce
2 new sysctls:
fs.verify_open_flags =3D BITMASK of flags open() uses in this kernel,
i.r O_CREAT||O_RDOBLY|O_RDWR,,
fs.verify_open_flags_action =3D NONE|WARN
1) fs.verify_open_flags  and flags_action  knobs will allow
distributions and package maintainers to detect and fix bad code. On
the other hand, it will allow to finally verify flags. passed to open
2) It will show kernel ABI to libc

3) The semantics of O_MAYEXEC is clear and is long waited for.
I think that O_MAYEXEC pretty well describes the intention of
application to treat the file as the source of actions, whether it is
ELF or script or another format. (not necessary Posix permissions
case)
This intention is passed to the kernel and then to LSM, IMA.

4) since we need to rewrite interpretersin order to use this flag, we
can also query fs.verify_open_flags to see whether it is available.

I hope I added my 2 cents.
