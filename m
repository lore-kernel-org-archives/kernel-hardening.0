Return-Path: <SRS0=1TGt=25=lists.openwall.com=kernel-hardening-return-17551-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2A9C282DD
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jan 2020 16:05:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5457D20720
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jan 2020 16:05:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="GfawSWFB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5457D20720
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17551-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3352 invoked by uid 550); 8 Jan 2020 16:05:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3296 invoked from network); 8 Jan 2020 16:05:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=VoRmCxJEeZnwUuJSnSbPNUYRm+CcgOOD9shVR7BAJrU=;
        b=GfawSWFBUXpsFWGUJ86wvHsppbC/QgD83hK4WbLqf7iDS2lp1EtLu7lBQ3zctvn6dX
         jCFB2jVMKOXA3q4+ccpldvMAMQbtsaIn2KgEPTMdW7MIGTSMmdt3RioiF5Zo/KBHbRkX
         W1WOn9nih3/KeDPD0VeLDZcK/EYQDBtKwojBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=VoRmCxJEeZnwUuJSnSbPNUYRm+CcgOOD9shVR7BAJrU=;
        b=lzvMZlnu4Q0PzHINHZCblnm25NeeaLj76TeFwr05v0ovfSE4Lj1v0QCz5/I8gwtU75
         RD6z8eKUnRmRhukXrzpG9Pi8frS4307SmCLLERWbEcu844J0cxKd37F8oHH8FlWmXnGt
         N0wHCfK0rur8+xj2TqeBvKwp2z2Mx9tX5baEtYWBxsqXE8ymwOZ1o8reCoJUb6V0A2zp
         Zlt4kluPdAjzb7hU7Dvb84a0aAI0aXJyc0vKy16NluGZhAL606Pjb1iNIuylc9DwwdrH
         Oehi2eY0UgL0rZPsZ3p24WB/w1eMyMsTRtSPeRuQCi/2qNYvVA5s8ye0hKibuedD5mie
         irgA==
X-Gm-Message-State: APjAAAUICHd1JZo5fpdEg5Jusc6UyR71kXUp3vR+x6AZZvo+Nhl9sgsy
	8yvhWn+kc4kdr3E52lu3bLmv
X-Google-Smtp-Source: APXvYqwm9L4n4b8ZS4BmPWGzHMVClRzUdbBYMWqOz4Y0Sj4bsxVoF4tgDaz+j0yGwOd2NfRXcvmm1w==
X-Received: by 2002:a62:e908:: with SMTP id j8mr5695844pfh.55.1578499496056;
        Wed, 08 Jan 2020 08:04:56 -0800 (PST)
From: Tianlin Li <tli@digitalocean.com>
Message-Id: <45CCBFCA-AACA-4C5E-B554-9E511872EAB9@digitalocean.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_EFFD76B4-A6C1-4C7E-ABF5-9B049E9EE8C8"
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [PATCH 0/2] drm/radeon: have the callers of set_memory_*() check
 the return value
Date: Wed, 8 Jan 2020 10:04:54 -0600
In-Reply-To: <b5984995-7276-97d3-a604-ddacfb89bd89@amd.com>
Cc: kernel-hardening@lists.openwall.com,
 keescook@chromium.org,
 Alex Deucher <alexander.deucher@amd.com>,
 David1.Zhou@amd.com,
 David Airlie <airlied@linux.ie>,
 Daniel Vetter <daniel@ffwll.ch>,
 amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org
To: =?utf-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
References: <20200107192555.20606-1-tli@digitalocean.com>
 <b5984995-7276-97d3-a604-ddacfb89bd89@amd.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)


--Apple-Mail=_EFFD76B4-A6C1-4C7E-ABF5-9B049E9EE8C8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Jan 8, 2020, at 6:56 AM, Christian K=C3=B6nig =
<christian.koenig@amd.com> wrote:
>=20
> Am 07.01.20 um 20:25 schrieb Tianlin Li:
>> Right now several architectures allow their set_memory_*() family of
>> functions to fail, but callers may not be checking the return values.
>> If set_memory_*() returns with an error, call-site assumptions may be
>> infact wrong to assume that it would either succeed or not succeed at
>> all. Ideally, the failure of set_memory_*() should be passed up the
>> call stack, and callers should examine the failure and deal with it.
>>=20
>> Need to fix the callers and add the __must_check attribute. They also
>> may not provide any level of atomicity, in the sense that the memory
>> protections may be left incomplete on failure. This issue likely has =
a
>> few steps on effects architectures:
>> 1)Have all callers of set_memory_*() helpers check the return value.
>> 2)Add __must_check to all set_memory_*() helpers so that new uses do
>> not ignore the return value.
>> 3)Add atomicity to the calls so that the memory protections aren't =
left
>> in a partial state.
>>=20
>> This series is part of step 1. Make drm/radeon check the return value =
of
>> set_memory_*().
>=20
> I'm a little hesitate merge that. This hardware is >15 years old and =
nobody of the developers have any system left to test this change on.
>=20
> Would it be to much of a problem to just add something like: r =3D =
set_memory_*(); (void)r; /* Intentionally ignored */.

Thank you. I will fix that in patch 1 and remove patch 2 (since no need =
to fix the call sites to handle the retval).=20

Best regards,
Tianlin
> Apart from that certainly a good idea to add __must_check to the =
functions.
>=20
> Regards,
> Christian.
>=20
>>=20
>> Tianlin Li (2):
>>   drm/radeon: have the callers of set_memory_*() check the return =
value
>>   drm/radeon: change call sites to handle return value properly.
>>=20
>>  drivers/gpu/drm/radeon/r100.c        |  3 ++-
>>  drivers/gpu/drm/radeon/radeon.h      |  2 +-
>>  drivers/gpu/drm/radeon/radeon_gart.c | 22 ++++++++++++++++++----
>>  drivers/gpu/drm/radeon/rs400.c       |  3 ++-
>>  4 files changed, 23 insertions(+), 7 deletions(-)


--Apple-Mail=_EFFD76B4-A6C1-4C7E-ABF5-9B049E9EE8C8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; =
charset=3Dutf-8"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;" class=3D""><br =
class=3D""><div><blockquote type=3D"cite" class=3D""><div class=3D"">On =
Jan 8, 2020, at 6:56 AM, Christian K=C3=B6nig &lt;<a =
href=3D"mailto:christian.koenig@amd.com" =
class=3D"">christian.koenig@amd.com</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">Am 07.01.20 um 20:25 schrieb =
Tianlin Li:</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><blockquote type=3D"cite" style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D"">Right =
now several architectures allow their set_memory_*() family of<br =
class=3D"">functions to fail, but callers may not be checking the return =
values.<br class=3D"">If set_memory_*() returns with an error, call-site =
assumptions may be<br class=3D"">infact wrong to assume that it would =
either succeed or not succeed at<br class=3D"">all. Ideally, the failure =
of set_memory_*() should be passed up the<br class=3D"">call stack, and =
callers should examine the failure and deal with it.<br class=3D""><br =
class=3D"">Need to fix the callers and add the __must_check attribute. =
They also<br class=3D"">may not provide any level of atomicity, in the =
sense that the memory<br class=3D"">protections may be left incomplete =
on failure. This issue likely has a<br class=3D"">few steps on effects =
architectures:<br class=3D"">1)Have all callers of set_memory_*() =
helpers check the return value.<br class=3D"">2)Add __must_check to all =
set_memory_*() helpers so that new uses do<br class=3D"">not ignore the =
return value.<br class=3D"">3)Add atomicity to the calls so that the =
memory protections aren't left<br class=3D"">in a partial state.<br =
class=3D""><br class=3D"">This series is part of step 1. Make drm/radeon =
check the return value of<br class=3D"">set_memory_*().<br =
class=3D""></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">I'm a little hesitate merge that. This hardware is &gt;15 =
years old and nobody of the developers have any system left to test this =
change on.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">Would it be =
to much of a problem to just add something like: r =3D set_memory_*(); =
(void)r; /* Intentionally ignored */.</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""></div></blockquote><div><br =
class=3D""></div><div>Thank you. I will fix that in patch 1 and remove =
patch 2 (since no need to fix the call sites to handle the =
retval).&nbsp;</div><div><br class=3D""></div><div>Best =
regards,</div><div>Tianlin</div><blockquote type=3D"cite" class=3D""><div =
class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">Apart from =
that certainly a good idea to add __must_check to the =
functions.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" =
class=3D"">Regards,</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">Christian.</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><br class=3D"">Tianlin Li (2):<br =
class=3D"">&nbsp;&nbsp;drm/radeon: have the callers of set_memory_*() =
check the return value<br class=3D"">&nbsp;&nbsp;drm/radeon: change call =
sites to handle return value properly.<br class=3D""><br =
class=3D"">&nbsp;drivers/gpu/drm/radeon/r100.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;3 ++-<br =
class=3D"">&nbsp;drivers/gpu/drm/radeon/radeon.h =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;2 +-<br =
class=3D"">&nbsp;drivers/gpu/drm/radeon/radeon_gart.c | 22 =
++++++++++++++++++----<br class=3D"">&nbsp;drivers/gpu/drm/radeon/rs400.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;3 ++-<br class=3D"">&nbsp;4 =
files changed, 23 insertions(+), 7 =
deletions(-)</blockquote></div></blockquote></div><br =
class=3D""></body></html>=

--Apple-Mail=_EFFD76B4-A6C1-4C7E-ABF5-9B049E9EE8C8--
