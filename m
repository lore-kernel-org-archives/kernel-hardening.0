Return-Path: <SRS0=ULFD=BU=lists.openwall.com=kernel-hardening-return-19584-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA463C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Aug 2020 23:04:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EF0CB2073E
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Aug 2020 23:04:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HiQBICnL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF0CB2073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19584-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12270 invoked by uid 550); 10 Aug 2020 23:03:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12237 invoked from network); 10 Aug 2020 23:03:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FD4/MDk5WwnURnuc/jZmQ+Kde4ex+xh6Ky7vtljOMA4=;
        b=HiQBICnLr5/84HZ02YSQlI9TIeEUtE9mvP2fW2c/4PW4LHtuIztNSCxNuDKx8calC7
         og0R4FG9eCyWjYfjN0z6wAv1wV+itYKxdNUdB7tEix2FZ/z7KabLVGcT+Mg4dxS88gXW
         Vx+BTyxoJ8HQZr50P7xJevopSsl0oe6TYyrREVsgEyDEYAtyICy12+zT1IZ2vWC32A8q
         pvB901XZsFKzsU1Tme77470++JHeCkrAsOpoB1Ugl2P2Am0NBP0X+0N+ZsoSNE2ijS1G
         4ui1hrzB8DtzFnAbcol1E5jBCrvtfI3Z14736AyU12BevqGTS3eBQ4w39G5Q5EwpOezP
         lC/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FD4/MDk5WwnURnuc/jZmQ+Kde4ex+xh6Ky7vtljOMA4=;
        b=nYNMjnsdgI+KjxcVtrfR/UszXAiCm1iLTpwrkOi/Mfbavh+pc5I54einFZ1po8XglV
         34rKl9zPUBYwynsaVrdrS8ubSyVLuuKd0oVfg0tmdUl/tpKYwwoJztJhIG2Viq8IBn9A
         HtdaayavE7/TMH0cNd29Q6+9gCVHqmmaF/szLgo97BrmKsBwMRH5lyjxZlpB+NjZpgy/
         D9EtUnO2JJTTPsJ5P/jZHgFsOVY4Sn7K/Qp5KYZs6y3OGTYQsWn7JXCqdRs29+3i+kJl
         uparDesLZ5CojzCwgH5NRHNsSHJ5H9Z+ulDfvuLXEwuqkiqh0/6x0cA4dbxT3OZRNvsy
         SHiw==
X-Gm-Message-State: AOAM531CKM81PAnEzTcYs9S/bwXxapngyfjbMCsQqrLyLoM9/EdyfImu
	1GuriQAhHts0dTIt0BTpcCQ0R70Gs/vXe0tLL3Piaw==
X-Google-Smtp-Source: ABdhPJzN6aVsD715ssYECTt8Tfze6fuWVzIL8WCFOarBDBk3pIfn+d4V0vju1dUN6WrcFeTZIPEUVQsGY5Hz30B6Iyk=
X-Received: by 2002:a2e:b058:: with SMTP id d24mr1685315ljl.265.1597100609834;
 Mon, 10 Aug 2020 16:03:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200723171227.446711-1-mic@digikod.net> <202007241205.751EBE7@keescook>
 <0733fbed-cc73-027b-13c7-c368c2d67fb3@digikod.net> <20200810202123.GC1236603@ZenIV.linux.org.uk>
 <917bb071-8b1a-3ba4-dc16-f8d7b4cc849f@digikod.net>
In-Reply-To: <917bb071-8b1a-3ba4-dc16-f8d7b4cc849f@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Tue, 11 Aug 2020 01:03:03 +0200
Message-ID: <CAG48ez0NAV5gPgmbDaSjo=zzE=FgnYz=-OHuXwu0Vts=B5gesA@mail.gmail.com>
Subject: Re: [PATCH v7 0/7] Add support for O_MAYEXEC
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kernel list <linux-kernel@vger.kernel.org>, 
	Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Christian Brauner <christian.brauner@ubuntu.com>, Christian Heimes <christian@python.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Deven Bowers <deven.desai@linux.microsoft.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>, 
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Matthew Garrett <mjg59@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, 
	=?UTF-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	Thibaut Sautereau <thibaut.sautereau@clip-os.org>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	linux-integrity@vger.kernel.org, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2020 at 12:43 AM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>=
 wrote:
> On 10/08/2020 22:21, Al Viro wrote:
> > On Mon, Aug 10, 2020 at 10:11:53PM +0200, Micka=C3=ABl Sala=C3=BCn wrot=
e:
> >> It seems that there is no more complains nor questions. Do you want me
> >> to send another series to fix the order of the S-o-b in patch 7?
> >
> > There is a major question regarding the API design and the choice of
> > hooking that stuff on open().  And I have not heard anything resembling
> > a coherent answer.
>
> Hooking on open is a simple design that enables processes to check files
> they intend to open, before they open them. From an API point of view,
> this series extends openat2(2) with one simple flag: O_MAYEXEC. The
> enforcement is then subject to the system policy (e.g. mount points,
> file access rights, IMA, etc.).
>
> Checking on open enables to not open a file if it does not meet some
> requirements, the same way as if the path doesn't exist or (for whatever
> reasons, including execution permission) if access is denied.

You can do exactly the same thing if you do the check in a separate
syscall though.

And it provides a greater degree of flexibility; for example, you can
use it in combination with fopen() without having to modify the
internals of fopen() or having to use fdopen().

> It is a
> good practice to check as soon as possible such properties, and it may
> enables to avoid (user space) time-of-check to time-of-use (TOCTOU)
> attacks (i.e. misuse of already open resources).

The assumption that security checks should happen as early as possible
can actually cause security problems. For example, because seccomp was
designed to do its checks as early as possible, including before
ptrace, we had an issue for a long time where the ptrace API could be
abused to bypass seccomp filters.

Please don't decide that a check must be ordered first _just_ because
it is a security check. While that can be good for limiting attack
surface, it can also create issues when the idea is applied too
broadly.

I don't see how TOCTOU issues are relevant in any way here. If someone
can turn a script that is considered a trusted file into an untrusted
file and then maliciously change its contents, you're going to have
issues either way because the modifications could still happen after
openat(); if this was possible, the whole thing would kind of fall
apart. And if that isn't possible, I don't see any TOCTOU.

> It is important to keep
> in mind that the use cases we are addressing consider that the (user
> space) script interpreters (or linkers) are trusted and unaltered (i.e.
> integrity/authenticity checked). These are similar sought defensive
> properties as for SUID/SGID binaries: attackers can still launch them
> with malicious inputs (e.g. file paths, file descriptors, environment
> variables, etc.), but the binaries can then have a way to check if they
> can extend their trust to some file paths.
>
> Checking file descriptors may help in some use cases, but not the ones
> motivating this series.

It actually provides a superset of the functionality that your
existing patches provide.

> Checking (already) opened resources could be a
> *complementary* way to check execute permission, but it is not in the
> scope of this series.
