Return-Path: <SRS0=a2Pj=XB=lists.openwall.com=kernel-hardening-return-16865-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C542C43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 20:06:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 566D0208C3
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 20:06:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="E0bpCavZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 566D0208C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16865-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9577 invoked by uid 550); 6 Sep 2019 20:06:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9557 invoked from network); 6 Sep 2019 20:06:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fA56nmfsZsnUsEfBRX6jWIQZ7RippmvM12LMrLjjbeM=;
        b=E0bpCavZc9w7bg3ldootyHw632dMvkQjPiTDyyD9E4nvHHA/R4hfUqQe7JLvWLoVI1
         ZzdmjRUZn1I/3UFIId9wru0Cc8NhUgmlZoWyxM/ETmiRdFCnjHslhNciqqND5mXeB2ql
         n2FNStFMy81oIyvmFuPfhqeBNzaKyrGa2txp4Fp60Why8ReO3XzcGfC7Iqb3t9OIfHFS
         hkuXHMI1y873af/967NcJKza/15DICLILQudnnZaxDY3hkSvNaemTLwpsFes4bFnAeGl
         yrMqylb/J5NUitzWqPaJmoR/oVtP6BgW0XPr9/NxQgR7ofco0GzSUDnNYnFHisgIXVU8
         A/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fA56nmfsZsnUsEfBRX6jWIQZ7RippmvM12LMrLjjbeM=;
        b=MbLRpI7b6i0tuWpVZXRkW+WU3sJj+Kz0oTxilBsEKZcVNl/kkzWZ5iEiPccuEu9/d/
         DuLuqhHaSbDBPHYVNL2RvHyKG4aLJioXL320jD7Xra1PAIHaXKHBrc3+AwpVJdI9LeTf
         tN5040xpeg79YmXxd76J0m9BjBkm9D6k/owpQrO3xOwpheqevOxk4WW0X9H3sy+Mj8cO
         R/zaCzWK7TTE+MDIRCA8cIfL/plI7xqPYnT4e5wveA3cyNleHiL9ncdI7sLVJnZtJTpB
         BKkpq+tWVDHBdhZWK/uepfU8sZjuem+BgWoIuSCgd4PK4yXqJnlOhwr/qp58GvhCjboS
         JxFA==
X-Gm-Message-State: APjAAAUKumT+T3E1Iivr6V79j9ugPrU8FQAkaLlOD8KSGnk/VbwjYvvB
	j8pNnpWnz6ZTMW92BFn7c+uRrw==
X-Google-Smtp-Source: APXvYqz56KYhH6DJKB5EGgZ1CB/vlaLiWum8K3dRnvpJQJJwnJqULKe23ljO87SF/jS0Eam/QGtA3w==
X-Received: by 2002:a62:3083:: with SMTP id w125mr12963792pfw.102.1567800362967;
        Fri, 06 Sep 2019 13:06:02 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
From: Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16G102)
In-Reply-To: <e1ac9428e6b768ac3145aafbe19b24dd6cf410b9.camel@kernel.org>
Date: Fri, 6 Sep 2019 13:06:00 -0700
Cc: Aleksa Sarai <cyphar@cyphar.com>,
 =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
 Florian Weimer <fweimer@redhat.com>,
 =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>,
 Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>,
 =?utf-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Song Liu <songliubraving@fb.com>,
 Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D2A57C7B-B0FD-424E-9F81-B858FFF21FF0@amacapital.net>
References: <20190906152455.22757-1-mic@digikod.net> <20190906152455.22757-2-mic@digikod.net> <87ef0te7v3.fsf@oldenburg2.str.redhat.com> <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr> <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org> <20190906171335.d7mc3no5tdrcn6r5@yavin.dot.cyphar.com> <e1ac9428e6b768ac3145aafbe19b24dd6cf410b9.camel@kernel.org>
To: Jeff Layton <jlayton@kernel.org>



> On Sep 6, 2019, at 12:43 PM, Jeff Layton <jlayton@kernel.org> wrote:
>=20
>> On Sat, 2019-09-07 at 03:13 +1000, Aleksa Sarai wrote:
>>> On 2019-09-06, Jeff Layton <jlayton@kernel.org> wrote:
>>>> On Fri, 2019-09-06 at 18:06 +0200, Micka=C3=ABl Sala=C3=BCn wrote:
>>>>> On 06/09/2019 17:56, Florian Weimer wrote:
>>>>> Let's assume I want to add support for this to the glibc dynamic loade=
r,
>>>>> while still being able to run on older kernels.
>>>>>=20
>>>>> Is it safe to try the open call first, with O_MAYEXEC, and if that fai=
ls
>>>>> with EINVAL, try again without O_MAYEXEC?
>>>>=20
>>>> The kernel ignore unknown open(2) flags, so yes, it is safe even for
>>>> older kernel to use O_MAYEXEC.
>>>>=20
>>>=20
>>> Well...maybe. What about existing programs that are sending down bogus
>>> open flags? Once you turn this on, they may break...or provide a way to
>>> circumvent the protections this gives.
>>=20
>> It should be noted that this has been a valid concern for every new O_*
>> flag introduced (and yet we still introduced new flags, despite the
>> concern) -- though to be fair, O_TMPFILE actually does have a
>> work-around with the O_DIRECTORY mask setup.
>>=20
>> The openat2() set adds O_EMPTYPATH -- though in fairness it's also
>> backwards compatible because empty path strings have always given ENOENT
>> (or EINVAL?) while O_EMPTYPATH is a no-op non-empty strings.
>>=20
>>> Maybe this should be a new flag that is only usable in the new openat2()=

>>> syscall that's still under discussion? That syscall will enforce that
>>> all flags are recognized. You presumably wouldn't need the sysctl if you=

>>> went that route too.
>>=20
>> I'm also interested in whether we could add an UPGRADE_NOEXEC flag to
>> how->upgrade_mask for the openat2(2) patchset (I reserved a flag bit for
>> it, since I'd heard about this work through the grape-vine).
>>=20
>=20
> I rather like the idea of having openat2 fds be non-executable by
> default, and having userland request it specifically via O_MAYEXEC (or
> some similar openat2 flag) if it's needed. Then you could add an
> UPGRADE_EXEC flag instead?
>=20
> That seems like something reasonable to do with a brand new API, and
> might be very helpful for preventing certain classes of attacks.
>=20
>=20

There are at least four concepts of executability here:

- Just check the file mode and any other relevant permissions. Return a norm=
al fd.  Makes sense for script interpreters, perhaps.

- Make the fd fexecve-able.

- Make the resulting fd mappable PROT_EXEC.

- Make the resulting fd upgradable.

I=E2=80=99m not at all convinced that the kernel needs to distinguish all th=
ese, but at least upgradability should be its own thing IMO.=
