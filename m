Return-Path: <SRS0=Uv3R=XB=lists.openwall.com=kernel-hardening-return-16851-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F6CC43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 18:42:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8321B20693
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 18:42:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="QgzFKOnY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8321B20693
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16851-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9258 invoked by uid 550); 6 Sep 2019 18:41:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8152 invoked from network); 6 Sep 2019 18:41:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=JvlWU0UT+h1e8eYt8VTSoJdog30UO8ZjjS29sbSOM00=;
        b=QgzFKOnYqQJYoi4tGp2f8sSuxLoNYyrOeVT7Q4ZuG8NQo17DCbatkIECl7Glw+FQ5P
         1KNfI9Yv/Sj5Dv1RBNP1wdtRfZVeGfgs7yvkhVx4vq/28sr2/eXXMRq/3TOlBo0DrU3J
         b97772QNiCYjvIHQ4Szi5FYIz4aP+sjf4fX5cIe5Y7X3fhLviB9sqU+j6BQfS/iBx9sK
         X5buUDqNHmo0WCvwN0+/Obe1c6zgLk4DDJ0lS4wxCIdXSHj2bjYcE5F9o9A3+tIjRXIm
         HHYxS/HImqduUDLZ9SurJe3K7GvjekoQPERSW4KtQdlG+X5ZLITINRe+1YFsK/2IDcRH
         Byng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=JvlWU0UT+h1e8eYt8VTSoJdog30UO8ZjjS29sbSOM00=;
        b=OK/Nbxmy+VU2hzRkH0tWMGJOPQ5+5GYnqOX739dSL+mX9o1kklMRkFYC8iKiJDXM7Z
         1/pJmzDI6OvDwtXT3eJGHyDtzO38igpkJIZZGQMLZIs00C06cHprxM1cfLEYhX+F2w80
         AEpUwc1AZi1nbnAJrdwVbFyVTXfKSHxhAA7Sv4yyuyd709WwWC6GG8A1yvI4XBG/wQnj
         gUG7F8nw1g3RGC/6FYFguDAn/C9kdOn0QUiFC7j1s0GxhfvQtkbgbyzNY2e2HKCWSfK/
         eUkekJcfae/iGeHbc8J/S0UtDGqIK/ydjWspRVgeYYU/LlOkl05WXVTua85BlPZ/xiyv
         RuVw==
X-Gm-Message-State: APjAAAUYxalBedqdlFk7JdWA5RvvvsVloVNWzuuIzHg3WZYjmheozuPL
	hLGXrOldK3l8XL+AH1M2kVMRJg==
X-Google-Smtp-Source: APXvYqyAHY9XchLinQG7hPxfto5d6hN4kNzr0hShwTSwr37onEde5jKVH0mWtgFAYvbPNU9Fcg2j9Q==
X-Received: by 2002:a63:e84a:: with SMTP id a10mr9606982pgk.274.1567795268183;
        Fri, 06 Sep 2019 11:41:08 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
From: Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16G102)
In-Reply-To: <5a59b309f9d0603d8481a483e16b5d12ecb77540.camel@kernel.org>
Date: Fri, 6 Sep 2019 11:41:06 -0700
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
 Florian Weimer <fweimer@redhat.com>,
 =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
 Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>,
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
Message-Id: <D1212E06-773B-42B9-B7C3-C4C1C2A6111D@amacapital.net>
References: <20190906152455.22757-1-mic@digikod.net> <20190906152455.22757-2-mic@digikod.net> <87ef0te7v3.fsf@oldenburg2.str.redhat.com> <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr> <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org> <1fbf54f6-7597-3633-a76c-11c4b2481add@ssi.gouv.fr> <5a59b309f9d0603d8481a483e16b5d12ecb77540.camel@kernel.org>
To: Jeff Layton <jlayton@kernel.org>



> On Sep 6, 2019, at 11:38 AM, Jeff Layton <jlayton@kernel.org> wrote:
>=20
>> On Fri, 2019-09-06 at 19:14 +0200, Micka=C3=ABl Sala=C3=BCn wrote:
>>> On 06/09/2019 18:48, Jeff Layton wrote:
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
>> Well, I don't think we should nor could care about bogus programs that
>> do not conform to the Linux ABI.
>>=20
>=20
> But they do conform. The ABI is just undefined here. Unknown flags are
> ignored so we never really know if $random_program may be setting them.
>=20
>>> Maybe this should be a new flag that is only usable in the new openat2()=

>>> syscall that's still under discussion? That syscall will enforce that
>>> all flags are recognized. You presumably wouldn't need the sysctl if you=

>>> went that route too.
>>=20
>> Here is a thread about a new syscall:
>> https://lore.kernel.org/lkml/1544699060.6703.11.camel@linux.ibm.com/
>>=20
>> I don't think it fit well with auditing nor integrity. Moreover using
>> the current open(2) behavior of ignoring unknown flags fit well with the
>> usage of O_MAYEXEC (because it is only a hint to the kernel about the
>> use of the *opened* file).
>>=20
>=20
> The fact that open and openat didn't vet unknown flags is really a bug.
>=20
> Too late to fix it now, of course, and as Aleksa points out, we've
> worked around that in the past. Now though, we have a new openat2
> syscall on the horizon. There's little need to continue these sorts of
> hacks.
>=20
> New open flags really have no place in the old syscalls, IMO.
>=20
>>> Anyone that wants to use this will have to recompile anyway. If the
>>> kernel doesn't support openat2 or if the flag is rejected then you know
>>> that you have no O_MAYEXEC support and can decide what to do.
>>=20
>> If we want to enforce a security policy, we need to either be the system
>> administrator or the distro developer. If a distro ship interpreters
>> using this flag, we don't need to recompile anything, but we need to be
>> able to control the enforcement according to the mount point
>> configuration (or an advanced MAC, or an IMA config). I don't see why an
>> userspace process should check if this flag is supported or not, it
>> should simply use it, and the sysadmin will enable an enforcement if it
>> makes sense for the whole system.
>>=20
>=20
> A userland program may need to do other risk mitigation if it sets
> O_MAYEXEC and the kernel doesn't recognize it.
>=20
> Personally, here's what I'd suggest:
>=20
> - Base this on top of the openat2 set
> - Change it that so that openat2() files are non-executable by default. An=
yone wanting to do that needs to set O_MAYEXEC or upgrade the fd somehow.
> - Only have the openat2 syscall pay attention to O_MAYEXEC. Let open and o=
penat continue ignoring the new flag.
>=20
> That works around a whole pile of potential ABI headaches. Note that
> we'd need to make that decision before the openat2 patches are merged.
>=20
> Even better would be to declare the new flag in some openat2-only flag
> space, so there's no confusion about it being supported by legacy open
> calls.
>=20
> If glibc wants to implement an open -> openat2 wrapper in userland
> later, it can set that flag in the wrapper implicitly to emulate the old
> behavior.
>=20
> Given that you're going to have to recompile software to take advantage
> of this anyway, what's the benefit to changing legacy syscalls?
>=20
>>>>> Or do I risk disabling this security feature if I do that?
>>>>=20
>>>> It is only a security feature if the kernel support it, otherwise it is=

>>>> a no-op.
>>>>=20
>>>=20
>>> With a security feature, I think we really want userland to aware of
>>> whether it works.
>>=20
>> If userland would like to enforce something, it can already do it
>> without any kernel modification. The goal of the O_MAYEXEC flag is to
>> enable the kernel, hence sysadmins or system designers, to enforce a
>> global security policy that makes sense.
>>=20
>=20
> I don't see how this helps anything if you can't tell whether the kernel
> recognizes the damned thing. Also, our track record with global sysctl
> switches like this is pretty poor. They're an administrative headache as
> well as a potential attack vector.

I tend to agree. The sysctl seems like it=E2=80=99s asking for trouble. I ca=
n see an ld.so.conf option to turn this thing off making sense.


