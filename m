Return-Path: <kernel-hardening-return-21531-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id EE0EAC433EF
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Jan 2022 19:23:14 +0000 (UTC)
Received: (qmail 22366 invoked by uid 550); 13 Jan 2022 19:23:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22340 invoked from network); 13 Jan 2022 19:23:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sempervictus-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:user-agent:in-reply-to:references:message-id
         :mime-version:content-transfer-encoding;
        bh=qa9iMToEvOmc5zJwjMu/kR/GUAQvF0+qXdbjtRdZmXU=;
        b=M13J/i4hDOqGS1ZHuw4ZYblR19Ou3n9Cpb2FlEbHHPCRlThhWJgs1oxqC1aWR3Pv1l
         iUJuQZqfEuKT9w7rKC9rEIIh5HIwcy/xiqXa+K4MbZ46L6832nGqjVFsY22ZQ0IuXgff
         KTxtZ6g3Hz6TCc/EEl3iKejIwskVd+fj/JX9aFbpcP07cvd7X4so7dONYW/haCeDP5Ai
         o8i9OZHsJYhdnIaKBJ0ckVXeLrPn4fc8n/1P8H/4VELidztt0oOaBEyiY2p9dBFuGEOs
         4Ra2Jkf6HIvMisITemfqPbs0V2efS+0FxY56XxpkRbiFej+fAzOSiMoaN1jOAOMZOXHO
         s6Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=qa9iMToEvOmc5zJwjMu/kR/GUAQvF0+qXdbjtRdZmXU=;
        b=gy47g1Zb+8sWSShTkqyQZJkj+EnKa1zmZnaLawEus6uuzsRnOIpdv1nA3imsAnIRbV
         QAxQTbLOAur5+SA/6CzRa3mIK3RwN4RUIHoxhwSuD1bav+B0P6P+Y1GZW0a7DOcOYh/v
         HXtURez+HMIa8PAKVUmothmogR32WI6aN0CRHY872jRYWG6RIw7aZ5jwlc06tfmcFxm+
         6GzDvafPqcpdWMY7KugES83FH4MDti/G+J/oajM2A5k1jpBe/Vdl07tCZXe9CBgpRIjY
         nb34MhVst4w+uAPs3Y3c9yRd2bDBeQ/4SdiX4QhkCtqeOyf18pI67Y4bw6SoS9+F5nic
         CPHw==
X-Gm-Message-State: AOAM5308rJalI+EYjmVdHdtkYADKXBCcrzn/o79J4edlNvywz0jiBwPR
	ZO7q7z1/3N5TL1ZjDqOBjDS9Lyh4LN0Fyf1K
X-Google-Smtp-Source: ABdhPJxrYrXuzayRF8haTBL1Onx6sIhQZP9Xvw8e/DDALcYUHlYirRU1nQF8tETj5YR5yhERBsWyNg==
X-Received: by 2002:ac8:7fc2:: with SMTP id b2mr4913030qtk.114.1642101770868;
        Thu, 13 Jan 2022 11:22:50 -0800 (PST)
Date: Thu, 13 Jan 2022 14:22:48 -0500
From: Boris Lukashev <blukashev@sempervictus.com>
To: kernel-hardening@lists.openwall.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_1/3=5D_x86=3A_Implement_arch=5Fprct?= =?US-ASCII?Q?l=28ARCH=5FVSYSCALL=5FCONTROL=29_to_disable_vsyscall?=
User-Agent: K-9 Mail for Android
In-Reply-To: <874k67zguk.fsf@oldenburg.str.redhat.com>
References: <3a1c8280967b491bf6917a18fbff6c9b52e8df24.1641398395.git.fweimer@redhat.com> <874k67zguk.fsf@oldenburg.str.redhat.com>
Message-ID: <8652E0AC-BE79-418E-BDA2-DCEFFEC45932@sempervictus.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary=----OSQQE4UDE9BAYLXGO7I25WYBJAECXE
Content-Transfer-Encoding: 7bit

------OSQQE4UDE9BAYLXGO7I25WYBJAECXE
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Publish an LPE abusing the problem - Linus can move fast if there is bad PR=
 to be had from not doing so=2E Unfortunately security in upstream tends to=
 be a reactive function=2E=20

-Boris


On January 13, 2022 12:27:15 PM EST, Florian Weimer <fweimer@redhat=2Ecom>=
 wrote:
>* Florian Weimer:
>
>> Distributions struggle with changing the default for vsyscall
>> emulation because it is a clear break of userspace ABI, something
>> that should not happen=2E
>>
>> The legacy vsyscall interface is supposed to be used by libcs only,
>> not by applications=2E  This commit adds a new arch_prctl request,
>> ARCH_VSYSCALL_CONTROL, with one argument=2E  If the argument is 0,
>> executing vsyscalls will cause the process to terminate=2E  Argument 1
>> turns vsyscall back on (this is mostly for a largely theoretical
>> CRIU use case)=2E
>>
>> Newer libcs can use a zero ARCH_VSYSCALL_CONTROL at startup to disable
>> vsyscall for the process=2E  Legacy libcs do not perform this call, so
>> vsyscall remains enabled for them=2E  This approach should achieves
>> backwards compatibility (perfect compatibility if the assumption that
>> only libcs use vsyscall is accurate), and it provides full hardening
>> for new binaries=2E
>>
>> The chosen value of ARCH_VSYSCALL_CONTROL should avoid conflicts
>> with other x86-64 arch_prctl requests=2E  The fact that with
>> vsyscall=3Demulate, reading the vsyscall region is still possible
>> even after a zero ARCH_VSYSCALL_CONTROL is considered limitation
>> in the current implementation and may change in a future kernel
>> version=2E
>>
>> Future arch_prctls requests commonly used at process startup can imply
>> ARCH_VSYSCALL_CONTROL with a zero argument, so that a separate system
>> call for disabling vsyscall is avoided=2E
>>
>> Signed-off-by: Florian Weimer <fweimer@redhat=2Ecom>
>> Acked-by: Andrei Vagin <avagin@gmail=2Ecom>
>> ---
>> v3: Remove warning log message=2E  Split out test=2E
>> v2: ARCH_VSYSCALL_CONTROL instead of ARCH_VSYSCALL_LOCKOUT=2E  New test=
s
>>     for the toggle behavior=2E  Implement hiding [vsyscall] in
>>     /proc/PID/maps and test it=2E  Various other test fixes cleanups
>>     (e=2Eg=2E, fixed missing second argument to gettimeofday)=2E
>>
>> arch/x86/entry/vsyscall/vsyscall_64=2Ec | 7 ++++++-
>>  arch/x86/include/asm/mmu=2Eh            | 6 ++++++
>>  arch/x86/include/uapi/asm/prctl=2Eh     | 2 ++
>>  arch/x86/kernel/process_64=2Ec          | 7 +++++++
>>  4 files changed, 21 insertions(+), 1 deletion(-)
>
>Hello,
>
>sorry to bother you again=2E  What can I do to move this forward?
>
>Thanks,
>Florian
>

------OSQQE4UDE9BAYLXGO7I25WYBJAECXE
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body>Publish an LPE abusing the problem - Linus can mov=
e fast if there is bad PR to be had from not doing so=2E Unfortunately secu=
rity in upstream tends to be a reactive function=2E <br><br>-Boris<br><br><=
br><div class=3D"gmail_quote">On January 13, 2022 12:27:15 PM EST, Florian =
Weimer &lt;fweimer@redhat=2Ecom&gt; wrote:<blockquote class=3D"gmail_quote"=
 style=3D"margin: 0pt 0pt 0pt 0=2E8ex; border-left: 1px solid rgb(204, 204,=
 204); padding-left: 1ex;">
<pre dir=3D"auto" class=3D"k9mail">* Florian Weimer:<br><br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin: 0pt 0pt 1ex 0=2E8ex; border-left: 1px =
solid #729fcf; padding-left: 1ex;"> Distributions struggle with changing th=
e default for vsyscall<br> emulation because it is a clear break of userspa=
ce ABI, something<br> that should not happen=2E<br><br> The legacy vsyscall=
 interface is supposed to be used by libcs only,<br> not by applications=2E=
  This commit adds a new arch_prctl request,<br> ARCH_VSYSCALL_CONTROL, wit=
h one argument=2E  If the argument is 0,<br> executing vsyscalls will cause=
 the process to terminate=2E  Argument 1<br> turns vsyscall back on (this i=
s mostly for a largely theoretical<br> CRIU use case)=2E<br><br> Newer libc=
s can use a zero ARCH_VSYSCALL_CONTROL at startup to disable<br> vsyscall f=
or the process=2E  Legacy libcs do not perform this call, so<br> vsyscall r=
emains enabled for them=2E  This approach should achieves<br> backwards com=
patibility (perfect compatibility if the assumption that<br> only libcs use=
 vsyscall is accurate), and it provides full hardening<br> for new binaries=
=2E<br><br> The chosen value of ARCH_VSYSCALL_CONTROL should avoid conflict=
s<br> with other x86-64 arch_prctl requests=2E  The fact that with<br> vsys=
call=3Demulate, reading the vsyscall region is still possible<br> even afte=
r a zero ARCH_VSYSCALL_CONTROL is considered limitation<br> in the current =
implementation and may change in a future kernel<br> version=2E<br><br> Fut=
ure arch_prctls requests commonly used at process startup can imply<br> ARC=
H_VSYSCALL_CONTROL with a zero argument, so that a separate system<br> call=
 for disabling vsyscall is avoided=2E<br><br> Signed-off-by: Florian Weimer=
 &lt;fweimer@redhat=2Ecom&gt;<br> Acked-by: Andrei Vagin &lt;avagin@gmail=
=2Ecom&gt;<hr> v3: Remove warning log message=2E  Split out test=2E<br> v2:=
 ARCH_VSYSCALL_CONTROL instead of ARCH_VSYSCALL_LOCKOUT=2E  New tests<br>  =
   for the toggle behavior=2E  Implement hiding [vsyscall] in<br>     /proc=
/PID/maps and test it=2E  Various other test fixes cleanups<br>     (e=2Eg=
=2E, fixed missing second argument to gettimeofday)=2E<br><br> arch/x86/ent=
ry/vsyscall/vsyscall_64=2Ec | 7 ++++++-<br>  arch/x86/include/asm/mmu=2Eh  =
          | 6 ++++++<br>  arch/x86/include/uapi/asm/prctl=2Eh     | 2 ++<br=
>  arch/x86/kernel/process_64=2Ec          | 7 +++++++<br>  4 files changed=
, 21 insertions(+), 1 deletion(-)<br></blockquote><br>Hello,<br><br>sorry t=
o bother you again=2E  What can I do to move this forward?<br><br>Thanks,<b=
r>Florian<br><br></pre></blockquote></div></body></html>
------OSQQE4UDE9BAYLXGO7I25WYBJAECXE--
