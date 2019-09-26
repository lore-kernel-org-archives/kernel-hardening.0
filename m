Return-Path: <SRS0=1eI5=XV=lists.openwall.com=kernel-hardening-return-16944-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC30C4360C
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Sep 2019 14:58:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 59B8121D6C
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Sep 2019 14:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="dQ4KGAlq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59B8121D6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16944-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24003 invoked by uid 550); 26 Sep 2019 14:58:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23967 invoked from network); 26 Sep 2019 14:58:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=T3VqGOCmzJa9c2MrngBfc8orzNTiHATwCSnZvWWV67U=;
        b=dQ4KGAlqjaMbJmW7wbCsCgqOyHw7DfIzNPFZUcahOCtBh57I6RZZqoqXw++hnmpCg6
         e8HvwvusK9/h0ZWSWT1iWtFeUxMKWWbdTl99UvVUbbHbg8KKZhNxdwB4VmHOMBCBIM9M
         Miy5UwqtEkE/Yu8hRWBB1Xyi6xVHN3AYkHywA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=T3VqGOCmzJa9c2MrngBfc8orzNTiHATwCSnZvWWV67U=;
        b=soRHO6rWKMy8dlrzDKwE6Mi/F1v03VGuOH6TrmXORgP/I5XegXgPEyw0raIb7RRnKY
         fnr4wuLY2zjPaU3ROvWhSmZlvwUoG+UC17o+p+Uw47Mm+CRLZLp/ZkXGbNt2iTPIqSXo
         +CE5E28p9kSPkuZOaoxIzvsfF1HfNuH6M6dF6lz5d04VJuVQeCFh1tLDpiEOy95BzH0H
         ZeKtHRUDVw89IRu0oIzEmVUlTGrRVMZZWLgNGiN4FIi0qycivXMstHYiVO6jCzwOb2rQ
         xY65hEAJzAg1gKSxUpkGNeZTlauZziyrnXexs1N2wkCIi+YNQJInjVzPOMx5vaRY3Hf0
         ZF7Q==
X-Gm-Message-State: APjAAAULGDBGqnDmphiAdbYi7lSmYuLDqStggE1Hx0GejutMXajfsA2W
	a+vGQRQotSnfJDnt/Vij7stU
X-Google-Smtp-Source: APXvYqyeqyVt5KBvShQyO2M5RUzbIoBgTQgW9nQCu0n6cwIWqE2Rs12HhvrcpCx5kRF6YDXqFO6S6g==
X-Received: by 2002:a17:902:9305:: with SMTP id bc5mr4349777plb.63.1569509882489;
        Thu, 26 Sep 2019 07:58:02 -0700 (PDT)
From: Tianlin Li <tli@digitalocean.com>
Message-Id: <7D98C4BB-62FA-4393-B24A-E213FB340A94@digitalocean.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_72EE6B8D-BD83-4218-AAD7-5E9400D440E4"
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: Introduction and get involved
Date: Thu, 26 Sep 2019 09:57:58 -0500
In-Reply-To: <201909241604.C4B6686@keescook>
Cc: kernel-hardening@lists.openwall.com
To: Kees Cook <keescook@chromium.org>
References: <19962016-19D9-40F8-A2A0-B7188614A263@digitalocean.com>
 <201909241604.C4B6686@keescook>
X-Mailer: Apple Mail (2.3445.104.11)


--Apple-Mail=_72EE6B8D-BD83-4218-AAD7-5E9400D440E4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Sep 24, 2019, at 6:12 PM, Kees Cook <keescook@chromium.org> wrote:
>=20
> On Fri, Sep 20, 2019 at 01:59:57PM -0500, Tianlin Li wrote:
>> Hello everyone,
>=20
> Hello!
>=20
>> My name is Tina. I am working at DigitalOcean Systems/kernel team, =
focusing on kernel security. I would like to get involved with Kernel =
Self Protection Project.=20
>> As a new hire, I don=E2=80=99t have much industry experience yet. But =
I have some research experience about memory virtualization.=20
>=20
> What kinds of things keep you up at night? :) Or rather, what have you
> seen that you think needs fixing?

I don=E2=80=99t have many ideas yet. :)=20

> What exactly do you mean by "memory virtualization"? That seems like =
it
> could be a lot of stuff. :) As far as the kernel's memory management
> system goes, there's lots of areas to poke at. Is there any portion
> you're specifically interested in?

I did some research about tracking memory footprint in VMs/Containers, =
so I played with page tables/EPT/page fault handlers

>> Is there any initial task that I can start with?=20
>> It is going to be a learning exercise for me at the beginning, but I =
will learn fast and start contributing value to the project.=20
>=20
> There has been some recent work on trying to replace dangerous (or
> easily misused) APIs in the kernel with safer alternatives. (See the
> recent stracpy() API that was proposed[1].)
>=20
> [1] https://www.openwall.com/lists/kernel-hardening/2019/07/23/16
>=20
> I've been keeping a (rather terse) TODO list here:
> =
https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Work#Spe=
cific_TODO_Items
>=20
> But I'd like to turn that into an actual bug list on github or the =
like.
>=20
> I wonder if working on something like this:
> - set_memory_*() needs __must_check and/or atomicity
> would be interesting?
>=20
> The idea there is that set_memory_*() calls can fail, so callers =
should
> likely be handling errors correctly. Adding the "__must_check" =
attribute
> and fixing all the callers would be nice (and certainly touches the
> memory management code!)

This is a great starting task for me. So for this task, basically I need =
to add __must_check attribute to set_memory_*() functions and fix all =
the callers to make sure they check the return values. Do I understand =
correctly?

Also I have some other questions:
Is there any requirement for the patches? e.g. based on which kernel =
version? how many individual patches?

Thanks,
Tina

> Welcome!
>=20
> -Kees
>=20
> --=20
> Kees Cook


--Apple-Mail=_72EE6B8D-BD83-4218-AAD7-5E9400D440E4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; =
charset=3Dutf-8"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;" class=3D""><br =
class=3D""><div><br class=3D""><blockquote type=3D"cite" class=3D""><div =
class=3D"">On Sep 24, 2019, at 6:12 PM, Kees Cook &lt;<a =
href=3D"mailto:keescook@chromium.org" =
class=3D"">keescook@chromium.org</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div class=3D""><div class=3D"">On =
Fri, Sep 20, 2019 at 01:59:57PM -0500, Tianlin Li wrote:<br =
class=3D""><blockquote type=3D"cite" class=3D"">Hello everyone,<br =
class=3D""></blockquote><br class=3D"">Hello!<br class=3D""><br =
class=3D""><blockquote type=3D"cite" class=3D"">My name is Tina. I am =
working at DigitalOcean Systems/kernel team, focusing on kernel =
security. I would like to get involved with Kernel Self Protection =
Project. <br class=3D"">As a new hire, I don=E2=80=99t have much =
industry experience yet. But I have some research experience about =
memory virtualization. <br class=3D""></blockquote><br class=3D"">What =
kinds of things keep you up at night? :) Or rather, what have you<br =
class=3D"">seen that you think needs fixing?<br =
class=3D""></div></div></blockquote><div><br class=3D""></div>I don=E2=80=99=
t have many ideas yet. :)&nbsp;</div><div><br class=3D""><blockquote =
type=3D"cite" class=3D""><div class=3D""><div class=3D"">What exactly do =
you mean by "memory virtualization"? That seems like it<br =
class=3D"">could be a lot of stuff. :) As far as the kernel's memory =
management<br class=3D"">system goes, there's lots of areas to poke at. =
Is there any portion<br class=3D"">you're specifically interested in?<br =
class=3D""></div></div></blockquote><div><br class=3D""></div><span =
style=3D"color: rgb(34, 34, 34); font-family: Arial, Helvetica, =
sans-serif; font-size: small; font-variant-ligatures: normal; orphans: =
2; widows: 2; background-color: rgb(255, 255, 255);" class=3D"">I did =
some research about tracking memory footprint in VMs/Containers, so I =
played with page tables/EPT/page fault handlers</span></div><div><div =
style=3D"orphans: 2; widows: 2;" class=3D""><font color=3D"#222222" =
face=3D"Arial, Helvetica, sans-serif" size=3D"2" class=3D""><span =
style=3D"caret-color: rgb(34, 34, 34); background-color: rgb(255, 255, =
255);" class=3D""><br class=3D""></span></font></div><blockquote =
type=3D"cite" class=3D""><div class=3D""><div class=3D""><blockquote =
type=3D"cite" class=3D"">Is there any initial task that I can start =
with? <br class=3D"">It is going to be a learning exercise for me at the =
beginning, but I will learn fast and start contributing value to the =
project. <br class=3D""></blockquote><br class=3D"">There has been some =
recent work on trying to replace dangerous (or<br class=3D"">easily =
misused) APIs in the kernel with safer alternatives. (See the<br =
class=3D"">recent stracpy() API that was proposed[1].)<br class=3D""><br =
class=3D"">[1] <a =
href=3D"https://www.openwall.com/lists/kernel-hardening/2019/07/23/16" =
class=3D"">https://www.openwall.com/lists/kernel-hardening/2019/07/23/16</=
a><br class=3D""><br class=3D"">I've been keeping a (rather terse) TODO =
list here:<br class=3D""><a =
href=3D"https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/=
Work#Specific_TODO_Items" =
class=3D"">https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Proje=
ct/Work#Specific_TODO_Items</a><br class=3D""><br class=3D"">But I'd =
like to turn that into an actual bug list on github or the like.<br =
class=3D""><br class=3D"">I wonder if working on something like this:<br =
class=3D"">- set_memory_*() needs __must_check and/or atomicity<br =
class=3D"">would be interesting?<br class=3D""><br class=3D"">The idea =
there is that set_memory_*() calls can fail, so callers should<br =
class=3D"">likely be handling errors correctly. Adding the =
"__must_check" attribute<br class=3D"">and fixing all the callers would =
be nice (and certainly touches the<br class=3D"">memory management =
code!)<br class=3D""></div></div></blockquote><div><br =
class=3D""></div><span style=3D"color: rgb(34, 34, 34); font-family: =
Arial, Helvetica, sans-serif; font-size: small; font-variant-ligatures: =
normal; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);" =
class=3D"">This is a great starting task for me. So for this task, =
basically I need to add __must_check attribute to set_memory_*() =
functions and fix all the callers to make sure they check the return =
values. Do I understand correctly?</span><br style=3D"color: rgb(34, 34, =
34); font-family: Arial, Helvetica, sans-serif; font-size: small; =
font-variant-ligatures: normal; orphans: 2; widows: 2; background-color: =
rgb(255, 255, 255);" class=3D""><br style=3D"color: rgb(34, 34, 34); =
font-family: Arial, Helvetica, sans-serif; font-size: small; =
font-variant-ligatures: normal; orphans: 2; widows: 2; background-color: =
rgb(255, 255, 255);" class=3D""><span style=3D"color: rgb(34, 34, 34); =
font-family: Arial, Helvetica, sans-serif; font-size: small; =
font-variant-ligatures: normal; orphans: 2; widows: 2; background-color: =
rgb(255, 255, 255);" class=3D"">Also I have some other =
questions:</span><br style=3D"color: rgb(34, 34, 34); font-family: =
Arial, Helvetica, sans-serif; font-size: small; font-variant-ligatures: =
normal; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);" =
class=3D""><span style=3D"color: rgb(34, 34, 34); font-family: Arial, =
Helvetica, sans-serif; font-size: small; font-variant-ligatures: normal; =
orphans: 2; widows: 2; background-color: rgb(255, 255, 255);" =
class=3D"">Is there any requirement for the patches? e.g. based on which =
kernel version? how many individual patches?</span><br style=3D"color: =
rgb(34, 34, 34); font-family: Arial, Helvetica, sans-serif; font-size: =
small; font-variant-ligatures: normal; orphans: 2; widows: 2; =
background-color: rgb(255, 255, 255);" class=3D""><br style=3D"color: =
rgb(34, 34, 34); font-family: Arial, Helvetica, sans-serif; font-size: =
small; font-variant-ligatures: normal; orphans: 2; widows: 2; =
background-color: rgb(255, 255, 255);" class=3D""><span style=3D"color: =
rgb(34, 34, 34); font-family: Arial, Helvetica, sans-serif; font-size: =
small; font-variant-ligatures: normal; orphans: 2; widows: 2; =
background-color: rgb(255, 255, 255);" class=3D"">Thanks,</span><br =
style=3D"color: rgb(34, 34, 34); font-family: Arial, Helvetica, =
sans-serif; font-size: small; font-variant-ligatures: normal; orphans: =
2; widows: 2; background-color: rgb(255, 255, 255);" class=3D""><span =
style=3D"color: rgb(34, 34, 34); font-family: Arial, Helvetica, =
sans-serif; font-size: small; font-variant-ligatures: normal; orphans: =
2; widows: 2; background-color: rgb(255, 255, 255);" =
class=3D"">Tina</span></div><div><div style=3D"orphans: 2; widows: 2;" =
class=3D""><font color=3D"#222222" face=3D"Arial, Helvetica, sans-serif" =
size=3D"2" class=3D""><span style=3D"caret-color: rgb(34, 34, 34); =
background-color: rgb(255, 255, 255);" class=3D""><br =
class=3D""></span></font></div><blockquote type=3D"cite" class=3D""><div =
class=3D""><div class=3D"">Welcome!<br class=3D""><br class=3D"">-Kees<br =
class=3D""><br class=3D"">-- <br class=3D"">Kees Cook<br =
class=3D""></div></div></blockquote></div><br class=3D""></body></html>=

--Apple-Mail=_72EE6B8D-BD83-4218-AAD7-5E9400D440E4--
