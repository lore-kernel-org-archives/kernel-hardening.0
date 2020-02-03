Return-Path: <SRS0=ld7s=3X=lists.openwall.com=kernel-hardening-return-17660-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FCFC35247
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Feb 2020 20:45:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D9B9720658
	for <kernel-hardening@archiver.kernel.org>; Mon,  3 Feb 2020 20:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="FMECbffE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9B9720658
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17660-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27911 invoked by uid 550); 3 Feb 2020 20:45:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27870 invoked from network); 3 Feb 2020 20:45:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=va5DBE6oZtmvrnAxbgrJjKkUp22YgwiCAYX6nZ8Ahbk=;
        b=FMECbffE6XFv4e+f0oDgakKul4lKZHsnhycGgsdjDbTz61LHoPNVd0lPLruipb0Opn
         t5M173BhvTST3xEbvKMK5O+CnLCJIOSPmcX/Jhe2PBaFVSvmW/pUDXhvrNJBFGhKMrUr
         Yhmr/0fWcqqCtV5lboiBcaG4FXW9+TJVrvdRU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=va5DBE6oZtmvrnAxbgrJjKkUp22YgwiCAYX6nZ8Ahbk=;
        b=HmQuPGkypJAWyEpp+0DfLoF/LN/mp83EUhXoS9PPJqsa9e1UDBojBd4edhv5pVa1rC
         vBqJrcx9nag1m5mpLeTjSODLAy99tgRs4d0MmEVmSWCyjrVl1vO3Jgup5Ej8JyLnoru6
         OVn02IorJD0bZwMiYZGAtn5iEgt+KIc82sP2ZarJi5IZBh7vq8eONb3C/y2swiZhpQim
         quaVLf6HZeDC2d7E4iZ5cegmwRP7qeyreOqxCi3AHM0yX9qyq/cAx5dBACGTdaxsdLeS
         YarOtvEbylhpjxRxHs54XUpvYb1nGybdFkiQxiSRHvlKyBrwmpT/4vPDZmBQGUejk5az
         WKuw==
X-Gm-Message-State: APjAAAXmszGITmu/oCcR3S1enRypLC6siF39spBNSzjf13/fhma29+kM
	8JRNAC37Ods7cZwoAGOdyfpE
X-Google-Smtp-Source: APXvYqzZpXEsyt4pvTHVh1uxIuR5rrATIyfVTcWfjFnitmTgd5tUG7ISVv4dN8rUa40hom62fDhmPQ==
X-Received: by 2002:a63:7515:: with SMTP id q21mr27921141pgc.63.1580762698349;
        Mon, 03 Feb 2020 12:44:58 -0800 (PST)
From: Tianlin Li <tli@digitalocean.com>
Message-Id: <D9D0C673-E931-46D2-A0F2-48F46901EA20@digitalocean.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_FA0004EA-541F-4FCC-8B3B-CDCAD16BAC91"
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v2] drm/radeon: have the callers of set_memory_*() check
 the return value
Date: Mon, 3 Feb 2020 14:44:56 -0600
In-Reply-To: <6e5a18f6-b7f6-c401-c845-fe24b183f348@amd.com>
Cc: kernel-hardening@lists.openwall.com,
 Kees Cook <keescook@chromium.org>,
 Alex Deucher <alexander.deucher@amd.com>,
 David1.Zhou@amd.com,
 David Airlie <airlied@linux.ie>,
 Daniel Vetter <daniel@ffwll.ch>,
 amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org
To: =?utf-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
References: <20200203161827.768-1-tli@digitalocean.com>
 <6e5a18f6-b7f6-c401-c845-fe24b183f348@amd.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)


--Apple-Mail=_FA0004EA-541F-4FCC-8B3B-CDCAD16BAC91
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Feb 3, 2020, at 11:16 AM, Christian K=C3=B6nig =
<christian.koenig@amd.com> wrote:
>=20
> Am 03.02.20 um 17:18 schrieb Tianlin Li:
>> Right now several architectures allow their set_memory_*() family of
>> functions to fail,
>=20
> Oh, that is a detail I previously didn't recognized. Which =
architectures are that?
>=20
> Cause the RS400/480, RS690 and RS740 which are affected by this are =
integrated in the south-bridge.

At least x86 is.=20
Some details: =
https://lore.kernel.org/netdev/20180628213459.28631-4-daniel@iogearbox.net=
/ =
<https://lore.kernel.org/netdev/20180628213459.28631-4-daniel@iogearbox.ne=
t/>

>>  but callers may not be checking the return values.
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
>>=20
>> Signed-off-by: Tianlin Li <tli@digitalocean.com>
>=20
> Reviewed-by: Christian K=C3=B6nig <christian.koenig@amd.com =
<mailto:christian.koenig@amd.com>>
>=20
>> ---
>> v2:
>> The hardware is too old to be tested on and the code cannot be simply
>> removed from the kernel, so this is the solution for the short term.
>> - Just print an error when something goes wrong
>> - Remove patch 2.
>> v1:
>> =
https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.k=
ernel.org%2Flkml%2F20200107192555.20606-1-tli%40digitalocean.com%2F&amp;da=
ta=3D02%7C01%7Cchristian.koenig%40amd.com%7Cba2176d2ca834214e6b108d7a8c4bb=
1d%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637163435227030235&amp;sda=
ta=3DmDhUEi3vmxahjsdrZOr83OEIWNBHefO8lkXST%2FW32CE%3D&amp;reserved=3D0 =
<https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.=
kernel.org%2Flkml%2F20200107192555.20606-1-tli%40digitalocean.com%2F&amp;d=
ata=3D02%7C01%7Cchristian.koenig%40amd.com%7Cba2176d2ca834214e6b108d7a8c4b=
b1d%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637163435227030235&amp;sd=
ata=3DmDhUEi3vmxahjsdrZOr83OEIWNBHefO8lkXST%2FW32CE%3D&amp;reserved=3D0>
>> ---
>>  drivers/gpu/drm/radeon/radeon_gart.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/drivers/gpu/drm/radeon/radeon_gart.c =
b/drivers/gpu/drm/radeon/radeon_gart.c
>> index f178ba321715..a2cc864aa08d 100644
>> --- a/drivers/gpu/drm/radeon/radeon_gart.c
>> +++ b/drivers/gpu/drm/radeon/radeon_gart.c
>> @@ -80,8 +80,9 @@ int radeon_gart_table_ram_alloc(struct =
radeon_device *rdev)
>>  #ifdef CONFIG_X86
>>  	if (rdev->family =3D=3D CHIP_RS400 || rdev->family =3D=3D =
CHIP_RS480 ||
>>  	    rdev->family =3D=3D CHIP_RS690 || rdev->family =3D=3D =
CHIP_RS740) {
>> -		set_memory_uc((unsigned long)ptr,
>> -			      rdev->gart.table_size >> PAGE_SHIFT);
>> +		if (set_memory_uc((unsigned long)ptr,
>> +			      rdev->gart.table_size >> PAGE_SHIFT))
>> +			DRM_ERROR("set_memory_uc failed.\n");
>>  	}
>>  #endif
>>  	rdev->gart.ptr =3D ptr;
>> @@ -106,8 +107,9 @@ void radeon_gart_table_ram_free(struct =
radeon_device *rdev)
>>  #ifdef CONFIG_X86
>>  	if (rdev->family =3D=3D CHIP_RS400 || rdev->family =3D=3D =
CHIP_RS480 ||
>>  	    rdev->family =3D=3D CHIP_RS690 || rdev->family =3D=3D =
CHIP_RS740) {
>> -		set_memory_wb((unsigned long)rdev->gart.ptr,
>> -			      rdev->gart.table_size >> PAGE_SHIFT);
>> +		if (set_memory_wb((unsigned long)rdev->gart.ptr,
>> +			      rdev->gart.table_size >> PAGE_SHIFT))
>> +			DRM_ERROR("set_memory_wb failed.\n");
>>  	}
>>  #endif
>>  	pci_free_consistent(rdev->pdev, rdev->gart.table_size,


--Apple-Mail=_FA0004EA-541F-4FCC-8B3B-CDCAD16BAC91
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; =
charset=3Dutf-8"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;" =
class=3D""><div><br class=3D""><blockquote type=3D"cite" class=3D""><div =
class=3D"">On Feb 3, 2020, at 11:16 AM, Christian K=C3=B6nig &lt;<a =
href=3D"mailto:christian.koenig@amd.com" =
class=3D"">christian.koenig@amd.com</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">Am 03.02.20 um 17:18 schrieb =
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
class=3D"">functions to fail,<br class=3D""></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">Oh, that is a detail I =
previously didn't recognized. Which architectures are that?</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">Cause the RS400/480, RS690 and =
RS740 which are affected by this are integrated in the =
south-bridge.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""></div></blockquote><br class=3D""></div><div>At least =
x86 is.&nbsp;</div><div>Some details:&nbsp;<a =
href=3D"https://lore.kernel.org/netdev/20180628213459.28631-4-daniel@iogea=
rbox.net/" =
class=3D"">https://lore.kernel.org/netdev/20180628213459.28631-4-daniel@io=
gearbox.net/</a></div><div><br class=3D""><blockquote type=3D"cite" =
class=3D""><div class=3D""><blockquote type=3D"cite" style=3D"font-family:=
 Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px; text-decoration: none;" =
class=3D"">&nbsp;but callers may not be checking the return values.<br =
class=3D"">If set_memory_*() returns with an error, call-site =
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
check the return value of<br class=3D"">set_memory_*().<br class=3D""><br =
class=3D"">Signed-off-by: Tianlin Li &lt;<a =
href=3D"mailto:tli@digitalocean.com" =
class=3D"">tli@digitalocean.com</a>&gt;<br class=3D""></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">Reviewed-by: Christian K=C3=B6nig =
&lt;</span><a href=3D"mailto:christian.koenig@amd.com" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px;" =
class=3D"">christian.koenig@amd.com</a><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">&gt;</span><br style=3D"caret-color: rgb(0, 0, 0); =
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
text-decoration: none;" class=3D"">---<br class=3D"">v2:<br class=3D"">The=
 hardware is too old to be tested on and the code cannot be simply<br =
class=3D"">removed from the kernel, so this is the solution for the =
short term.<br class=3D"">- Just print an error when something goes =
wrong<br class=3D"">- Remove patch 2.<br class=3D"">v1:<br class=3D""><a =
href=3D"https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%=
2Flore.kernel.org%2Flkml%2F20200107192555.20606-1-tli%40digitalocean.com%2=
F&amp;amp;data=3D02%7C01%7Cchristian.koenig%40amd.com%7Cba2176d2ca834214e6=
b108d7a8c4bb1d%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C63716343522703=
0235&amp;amp;sdata=3DmDhUEi3vmxahjsdrZOr83OEIWNBHefO8lkXST%2FW32CE%3D&amp;=
amp;reserved=3D0" =
class=3D"">https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%=
2F%2Flore.kernel.org%2Flkml%2F20200107192555.20606-1-tli%40digitalocean.co=
m%2F&amp;amp;data=3D02%7C01%7Cchristian.koenig%40amd.com%7Cba2176d2ca83421=
4e6b108d7a8c4bb1d%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C63716343522=
7030235&amp;amp;sdata=3DmDhUEi3vmxahjsdrZOr83OEIWNBHefO8lkXST%2FW32CE%3D&a=
mp;amp;reserved=3D0</a><br class=3D"">---<br =
class=3D"">&nbsp;drivers/gpu/drm/radeon/radeon_gart.c | 10 ++++++----<br =
class=3D"">&nbsp;1 file changed, 6 insertions(+), 4 deletions(-)<br =
class=3D""><br class=3D"">diff --git =
a/drivers/gpu/drm/radeon/radeon_gart.c =
b/drivers/gpu/drm/radeon/radeon_gart.c<br class=3D"">index =
f178ba321715..a2cc864aa08d 100644<br class=3D"">--- =
a/drivers/gpu/drm/radeon/radeon_gart.c<br class=3D"">+++ =
b/drivers/gpu/drm/radeon/radeon_gart.c<br class=3D"">@@ -80,8 +80,9 @@ =
int radeon_gart_table_ram_alloc(struct radeon_device *rdev)<br =
class=3D"">&nbsp;#ifdef CONFIG_X86<br class=3D"">&nbsp;<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(rdev-&gt;family =3D=3D CHIP_RS400 || rdev-&gt;family =3D=3D CHIP_RS480 =
||<br class=3D"">&nbsp;<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;rdev-&gt;fa=
mily =3D=3D CHIP_RS690 || rdev-&gt;family =3D=3D CHIP_RS740) {<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>set_memory_uc((unsigned long)ptr,<br class=3D"">-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;rdev-&gt;gart.table_size &gt;&gt; PAGE_SHIFT);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(set_memory_uc((unsigned long)ptr,<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;rdev-&gt;gart.table_size &gt;&gt; PAGE_SHIFT))<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>DRM_ERROR("set_memory_uc failed.\n");<br class=3D"">&nbsp;<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>}<br =
class=3D"">&nbsp;#endif<br class=3D"">&nbsp;<span class=3D"Apple-tab-span"=
 style=3D"white-space: pre;">	</span>rdev-&gt;gart.ptr =3D ptr;<br =
class=3D"">@@ -106,8 +107,9 @@ void radeon_gart_table_ram_free(struct =
radeon_device *rdev)<br class=3D"">&nbsp;#ifdef CONFIG_X86<br =
class=3D"">&nbsp;<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>if (rdev-&gt;family =3D=3D CHIP_RS400 || rdev-&gt;family =
=3D=3D CHIP_RS480 ||<br class=3D"">&nbsp;<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;rdev-&gt;fa=
mily =3D=3D CHIP_RS690 || rdev-&gt;family =3D=3D CHIP_RS740) {<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>set_memory_wb((unsigned long)rdev-&gt;gart.ptr,<br =
class=3D"">-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;rdev-&gt;gart.table_size &gt;&gt; PAGE_SHIFT);<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(set_memory_wb((unsigned long)rdev-&gt;gart.ptr,<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;rdev-&gt;gart.table_size &gt;&gt; PAGE_SHIFT))<br class=3D"">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>DRM_ERROR("set_memory_wb failed.\n");<br class=3D"">&nbsp;<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>}<br =
class=3D"">&nbsp;#endif<br class=3D"">&nbsp;<span class=3D"Apple-tab-span"=
 style=3D"white-space: pre;">	=
</span>pci_free_consistent(rdev-&gt;pdev, =
rdev-&gt;gart.table_size,</blockquote></div></blockquote></div><br =
class=3D""></body></html>=

--Apple-Mail=_FA0004EA-541F-4FCC-8B3B-CDCAD16BAC91--
