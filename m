Return-Path: <SRS0=zQBb=XE=lists.openwall.com=kernel-hardening-return-16889-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D27DC4740A
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Sep 2019 15:49:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 68C1C2171F
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Sep 2019 15:49:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="pyj6eZzO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68C1C2171F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16889-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28409 invoked by uid 550); 9 Sep 2019 15:49:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28388 invoked from network); 9 Sep 2019 15:49:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TcpVRxPvSCJBDeMrd2YTMRp8Rl8PbIZu3n0i+gvGrs0=;
        b=pyj6eZzOMQKgCMAnu5hk7YcUQt/XRn56h4r0IMODI0hyM9G9CYPIi2I36Xh8bWAswe
         HQ69epbn6Uf9ynM4L80OZwNVT7+NKwhsVjbbBOdgZ3Sno+ciFri39Kli05LwVBVwXMO4
         WPQPuPR8PH4DNpoQm9XN6dklzcVFGdNXqpu0a1NtCG6oZM5UZY52+iEmc5U+69aWMSDD
         TtFXWImbrKRvBbStNAPXOn384l3qdIeXuF90JziftEWHMPomjRynDL5FJz+grsE1Ojux
         M7UMm0N5iJ2ogZ3iHxqnGcVPcNf5bXqHXW4l+fPAohZq2BPjtEtmzX37Gd63Ig1oZN85
         4jrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=TcpVRxPvSCJBDeMrd2YTMRp8Rl8PbIZu3n0i+gvGrs0=;
        b=cDSoJWb6YK7MiQZ6ktcVaYa8+sQ2V++H8Voc84z25yQutGchQ+m1Z+IPF4LDi6z1H4
         accwo9YA4H9qXpySfAHND2JC1zlaWzRbeeM3/lA7gNQuVjurubsJaq1svSi9KThWUhHJ
         xUU0rn1bIYSW+AQkEDWCgu/x+p1EV98tSBD7zVyvx95GDUfLSiBxWGkGTlCdpFXBb4mA
         yERHXCFyqBJjVA7h5ROtYMI5+VC005rVxzDj800o5EEYD7k41Ewipo+H2NLwrWfp5lUm
         l/SO0xG2LaaklAh559bW22EkaSfrOHyiDgeWkzJvdgVnJ6bTQ1niJFS8t07f2yENabGW
         DeAA==
X-Gm-Message-State: APjAAAVZeQJchGK+TdFZuOquvJHjhdxfdbVIUFb3QbOgwDhHb3GyYMha
	Nq4vkmmOCpHedn+JE2gf+ngM+w==
X-Google-Smtp-Source: APXvYqySGg+p3Dw7cgCsaiUZVu10eDMnz9rdqxHXA7Nhsj2dAxRpToTiDCtfq8sckKTaoarNWjC1Vw==
X-Received: by 2002:a63:df06:: with SMTP id u6mr21484642pgg.96.1568044176881;
        Mon, 09 Sep 2019 08:49:36 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
From: Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16G102)
In-Reply-To: <9e43ca3f-04c0-adba-1ab4-bbc8ed487934@ssi.gouv.fr>
Date: Mon, 9 Sep 2019 08:49:32 -0700
Cc: Jeff Layton <jlayton@kernel.org>, Florian Weimer <fweimer@redhat.com>,
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
Message-Id: <D3D3F165-F562-4090-831D-D8E39F9C5246@amacapital.net>
References: <20190906152455.22757-1-mic@digikod.net> <20190906152455.22757-2-mic@digikod.net> <87ef0te7v3.fsf@oldenburg2.str.redhat.com> <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr> <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org> <1fbf54f6-7597-3633-a76c-11c4b2481add@ssi.gouv.fr> <5a59b309f9d0603d8481a483e16b5d12ecb77540.camel@kernel.org> <D1212E06-773B-42B9-B7C3-C4C1C2A6111D@amacapital.net> <9e43ca3f-04c0-adba-1ab4-bbc8ed487934@ssi.gouv.fr>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>


> On Sep 9, 2019, at 2:18 AM, Micka=C3=ABl Sala=C3=BCn <mickael.salaun@ssi.g=
ouv.fr> wrote:
>=20
>=20
>> On 06/09/2019 20:41, Andy Lutomirski wrote:
>>=20
>>=20
>>>> On Sep 6, 2019, at 11:38 AM, Jeff Layton <jlayton@kernel.org> wrote:
>>>>=20
>>>>> On Fri, 2019-09-06 at 19:14 +0200, Micka=C3=ABl Sala=C3=BCn wrote:
>>>>>> On 06/09/2019 18:48, Jeff Layton wrote:
>>>>>>> On Fri, 2019-09-06 at 18:06 +0200, Micka=C3=ABl Sala=C3=BCn wrote:
>>>>>>> On 06/09/2019 17:56, Florian Weimer wrote:
>>>>>>> Let's assume I want to add support for this to the glibc dynamic loa=
der,
>>>>>>> while still being able to run on older kernels.
>>>>>>>=20
>>>>>>> Is it safe to try the open call first, with O_MAYEXEC, and if that f=
ails
>>>>>>> with EINVAL, try again without O_MAYEXEC?
>>>>>>=20
>>>>>> The kernel ignore unknown open(2) flags, so yes, it is safe even for
>>>>>> older kernel to use O_MAYEXEC.
>>>>>>=20
>>>>>=20
>>>>> Well...maybe. What about existing programs that are sending down bogus=

>>>>> open flags? Once you turn this on, they may break...or provide a way t=
o
>>>>> circumvent the protections this gives.
>>>>=20
>>>> Well, I don't think we should nor could care about bogus programs that
>>>> do not conform to the Linux ABI.
>>>>=20
>>>=20
>>> But they do conform. The ABI is just undefined here. Unknown flags are
>>> ignored so we never really know if $random_program may be setting them.
>>>=20
>>>>> Maybe this should be a new flag that is only usable in the new openat2=
()
>>>>> syscall that's still under discussion? That syscall will enforce that
>>>>> all flags are recognized. You presumably wouldn't need the sysctl if y=
ou
>>>>> went that route too.
>>>>=20
>>>> Here is a thread about a new syscall:
>>>> https://lore.kernel.org/lkml/1544699060.6703.11.camel@linux.ibm.com/
>>>>=20
>>>> I don't think it fit well with auditing nor integrity. Moreover using
>>>> the current open(2) behavior of ignoring unknown flags fit well with th=
e
>>>> usage of O_MAYEXEC (because it is only a hint to the kernel about the
>>>> use of the *opened* file).
>>>>=20
>>>=20
>>> The fact that open and openat didn't vet unknown flags is really a bug.
>>>=20
>>> Too late to fix it now, of course, and as Aleksa points out, we've
>>> worked around that in the past. Now though, we have a new openat2
>>> syscall on the horizon. There's little need to continue these sorts of
>>> hacks.
>>>=20
>>> New open flags really have no place in the old syscalls, IMO.
>>>=20
>>>>> Anyone that wants to use this will have to recompile anyway. If the
>>>>> kernel doesn't support openat2 or if the flag is rejected then you kno=
w
>>>>> that you have no O_MAYEXEC support and can decide what to do.
>>>>=20
>>>> If we want to enforce a security policy, we need to either be the syste=
m
>>>> administrator or the distro developer. If a distro ship interpreters
>>>> using this flag, we don't need to recompile anything, but we need to be=

>>>> able to control the enforcement according to the mount point
>>>> configuration (or an advanced MAC, or an IMA config). I don't see why a=
n
>>>> userspace process should check if this flag is supported or not, it
>>>> should simply use it, and the sysadmin will enable an enforcement if it=

>>>> makes sense for the whole system.
>>>>=20
>>>=20
>>> A userland program may need to do other risk mitigation if it sets
>>> O_MAYEXEC and the kernel doesn't recognize it.
>>>=20
>>> Personally, here's what I'd suggest:
>>>=20
>>> - Base this on top of the openat2 set
>>> - Change it that so that openat2() files are non-executable by default. A=
nyone wanting to do that needs to set O_MAYEXEC or upgrade the fd somehow.
>>> - Only have the openat2 syscall pay attention to O_MAYEXEC. Let open and=
 openat continue ignoring the new flag.
>>>=20
>>> That works around a whole pile of potential ABI headaches. Note that
>>> we'd need to make that decision before the openat2 patches are merged.
>>>=20
>>> Even better would be to declare the new flag in some openat2-only flag
>>> space, so there's no confusion about it being supported by legacy open
>>> calls.
>>>=20
>>> If glibc wants to implement an open -> openat2 wrapper in userland
>>> later, it can set that flag in the wrapper implicitly to emulate the old=

>>> behavior.
>>>=20
>>> Given that you're going to have to recompile software to take advantage
>>> of this anyway, what's the benefit to changing legacy syscalls?
>>>=20
>>>>>>> Or do I risk disabling this security feature if I do that?
>>>>>>=20
>>>>>> It is only a security feature if the kernel support it, otherwise it i=
s
>>>>>> a no-op.
>>>>>>=20
>>>>>=20
>>>>> With a security feature, I think we really want userland to aware of
>>>>> whether it works.
>>>>=20
>>>> If userland would like to enforce something, it can already do it
>>>> without any kernel modification. The goal of the O_MAYEXEC flag is to
>>>> enable the kernel, hence sysadmins or system designers, to enforce a
>>>> global security policy that makes sense.
>>>>=20
>>>=20
>>> I don't see how this helps anything if you can't tell whether the kernel=

>>> recognizes the damned thing. Also, our track record with global sysctl
>>> switches like this is pretty poor. They're an administrative headache as=

>>> well as a potential attack vector.
>>=20
>> I tend to agree. The sysctl seems like it=E2=80=99s asking for trouble. I=
 can see an ld.so.conf option to turn this thing off making sense.
>=20
> The sysctl is required to enable the adoption of this flag without
> breaking existing systems. Current systems may have "noexec" on mount
> points containing scripts. Without giving the ability to the sysadmin to
> control that behavior, updating to a newer version of an interpreter
> using O_MAYEXEC may break such systems.
>=20
> How would you do this with ld.so.conf ?
>=20

By telling user code not to use O_MAYEXEC?

Alternatively, you could allow O_MAYEXEC even on a noexec mount and have a s=
trong_noexec option that blocks it.=
