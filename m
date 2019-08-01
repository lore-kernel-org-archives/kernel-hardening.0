Return-Path: <SRS0=Poz0=V5=lists.openwall.com=kernel-hardening-return-16689-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1225C19759
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 20:06:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0B336206B8
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 20:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="DDLD7s6E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B336206B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=outlook.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16689-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28120 invoked by uid 550); 1 Aug 2019 20:06:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25844 invoked from network); 1 Aug 2019 20:00:46 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxURkdrvkA8YTYBdp0YAFJoW3eiy8QDiLrboLQw2PvpzO5IVHStvk7tWQrjJh8scWA+w2HA1yujRyAaWeVQ5Y80nUUeRkASpdXZsY7FmmVKinHg/yX7QRt1flKlJw2pz/FvbpLoDSJxBoCL5AahRgZjjyFxbRJMiUk7665jqLbSJh7VHBq10proc0e10u7C7FACUKR/gNidNMKhChWuwP6KvlPmf4zp9ghV1FdRz40o3kfceBjKE2ilEF0dwDi3+UH09ylQfylEIyVj7x1NC4qp4wdtWCK0e4JCCSvCBa7Erh4knh9fG0ejooD32dsKkIsMGWUssx/bS6Ewii6i92w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1IVvQPRdFNZ89kXRsXkioPpdNL1mfma2IURaQMnO5Y=;
 b=O9Xeiml5LyFWTOy3N76JZUlxk6HTm4XIIf4jz1phAW1doHCnTFTw6/k10f0N/c6C9lgmobZSqMT5oRcczX4C/jo4fQnmwzF+R/crAHfQ3gqGPRUmD1039Ar3ydH9V3xqX7Y/OPI4jklorBOeirrrRgzM897DK6vrf2aoVPL5a8HfwhS8Yzll4KtyMDv9VwXdpjADh5Z5indCFuCxlDfY7qReFBd6ap0ePXMSc9OF1Y3fPtwkpqiUk94xTLwKgYcfi+VfM0jugsECgZVWau8FuFWSeeciEf1nH+AnIcoYQCvhPHWVekWIPEWAqjYy/UauT8JrwjijIqJx+/563unRWA==
ARC-Authentication-Results: i=1; mx.microsoft.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1IVvQPRdFNZ89kXRsXkioPpdNL1mfma2IURaQMnO5Y=;
 b=DDLD7s6EbNkB3wFjaWxgZsujSS0TT1lWVOXszYOjkQGc33in+Jb6FuSI8bN2p+CCpU4tyV5sQvkPKSgejwK9UuVJtz+Fke/bRYqJFAbyXA829wv6OAhdC+jcdgzymfTaqJZON1hKET4l+gqiUa8uObY7gQcPb6iz3SiAxeM1Q/yBpkkI4a3/yVQVJi+5ytSQtRjv/cBT2UjR9n6sh87V0pmgnlDe8NLXc1Tu94EcjylvhZAIoTyeH+IZ4fKzi503T238OJZLtvzhI4eCuo78RHu0Dbm044r82rg+oL4CIhj9Gjskoqt2oGkpfRR2VaNkXPzEHT/4vR1BhVtNaoTKLg==
From: Rick Mark <rickmark@outlook.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "keescook@chromium.org"
	<keescook@chromium.org>
Subject: Re: Hello Kernel Hardening
Thread-Topic: Hello Kernel Hardening
Thread-Index: AQHVR0Nydh2VCNrgZESrXztbaUphuabkc0AAgAC8yYCAAJyHgIAA6721
Date: Thu, 1 Aug 2019 20:00:33 +0000
Message-ID:
 <BYAPR07MB57828912977C33ABC45E4E10DADE0@BYAPR07MB5782.namprd07.prod.outlook.com>
References: <20190731091818.GB29294@kroah.com>
 <BYAPR07MB5782A0925C97FBCB172BD3C0DADF0@BYAPR07MB5782.namprd07.prod.outlook.com>,<20190801055413.GA24062@kroah.com>
In-Reply-To: <20190801055413.GA24062@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-incomingtopheadermarker:
 OriginalChecksum:B4A1B7C320A46DA7B812607642E004AFFAA5E8725BF7A789CDE5F8E993FFE20B;UpperCasedChecksum:B8BEBA5435EAC727070AE5A8C33CEFB54F7E68A229F15CCC2F8DBB5D6BFF7B0D;SizeAsReceived:6888;Count:44
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [AYNF7afQFAyaJgzC5PWDBVb03NoD/BGA]
x-ms-publictraffictype: Email
x-incomingheadercount: 44
x-eopattributedmessage: 0
x-microsoft-antispam:
 BCL:0;PCL:0;RULEID:(2390118)(5050001)(7020095)(20181119110)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031322404)(2017031323274)(2017031324274)(1601125500)(1603101475)(1701031045);SRVR:BL2NAM02HT177;
x-ms-traffictypediagnostic: BL2NAM02HT177:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-message-info:
 UmAHM1UA6rcjv1TsywS99xZEpf4fADiM9BkC2LQx8oFLCZCsL7lwpF8Z/4/ujtHCGygtdV+Ntm3jmlR9BgUxWLAjaDWfFXoxqku4QAttw1jB2+39r/3jIq263fL49virp8IstzfcKIhwqaMShe/uHgJkU13R5r52blla/RNDTwMuQQGy1gH/o50lq/0ZbqYI
Content-Type: multipart/alternative;
	boundary="_000_BYAPR07MB57828912977C33ABC45E4E10DADE0BYAPR07MB5782namp_"
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ecb9c5f-1ecc-4176-5e79-08d716bae95f
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 20:00:33.0254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2NAM02HT177

--_000_BYAPR07MB57828912977C33ABC45E4E10DADE0BYAPR07MB5782namp_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Awesome,

Thanks Greg for the advice and welcome.

I'm already starting to put together one with Linaro / OP-TEE cross compile=
d for QEMU ARMv8.  I'll send it back out when it's working / not shameful e=
nough to actually `git push` to a fork.

As an aside for the rest of the mailing list, hope to see you all at BSides=
/DEFCON/QueerCon in a week.

R
________________________________
From: Greg KH <gregkh@linuxfoundation.org>
Sent: Wednesday, July 31, 2019 10:54 PM
To: Rick Mark <rickmark@outlook.com>
Cc: kernel-hardening@lists.openwall.com <kernel-hardening@lists.openwall.co=
m>
Subject: Re: Hello Kernel Hardening

On Wed, Jul 31, 2019 at 08:33:59PM +0000, Rick Mark wrote:
> Sorry, didn=92t realize the Dropbox link shortener required login.  Full =
link:
>
>
> https://paper.dropbox.com/doc/Security-Critical-Kernel-Object-Confidentia=
lity-and-Integrity-akFs9yNQ8YxLKP3BEaHZ8

That works better, thanks!

As always, why not knock up a working prototype of your idea first and
post it?  That's how we work with kernel development.  Lots of people
have random ideas, but to see if they actually work you need a working
patch.

good luck!

greg k-h

--_000_BYAPR07MB57828912977C33ABC45E4E10DADE0BYAPR07MB5782namp_
Content-Type: text/html; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DWindows-1=
252">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);">
Awesome,</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);">
Thanks&nbsp;Greg for the advice and welcome.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);">
I'm already starting to put together one with Linaro / OP-TEE cross compile=
d for QEMU ARMv8.&nbsp; I'll send it back out when it's working / not shame=
ful enough to actually `git push` to a fork.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);">
As an aside for the rest of the mailing list, hope to see you all at BSides=
/DEFCON/QueerCon in a week.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);">
R</div>
<div id=3D"appendonsend"></div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>From:</b> Greg KH &lt;gregkh@li=
nuxfoundation.org&gt;<br>
<b>Sent:</b> Wednesday, July 31, 2019 10:54 PM<br>
<b>To:</b> Rick Mark &lt;rickmark@outlook.com&gt;<br>
<b>Cc:</b> kernel-hardening@lists.openwall.com &lt;kernel-hardening@lists.o=
penwall.com&gt;<br>
<b>Subject:</b> Re: Hello Kernel Hardening</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">On Wed, Jul 31, 2019 at 08:33:59PM &#43;0000, Rick=
 Mark wrote:<br>
&gt; Sorry, didn=92t realize the Dropbox link shortener required login.&nbs=
p; Full link:<br>
&gt; <br>
&gt; <br>
&gt; <a href=3D"https://paper.dropbox.com/doc/Security-Critical-Kernel-Obje=
ct-Confidentiality-and-Integrity-akFs9yNQ8YxLKP3BEaHZ8">
https://paper.dropbox.com/doc/Security-Critical-Kernel-Object-Confidentiali=
ty-and-Integrity-akFs9yNQ8YxLKP3BEaHZ8</a><br>
<br>
That works better, thanks!<br>
<br>
As always, why not knock up a working prototype of your idea first and<br>
post it?&nbsp; That's how we work with kernel development.&nbsp; Lots of pe=
ople<br>
have random ideas, but to see if they actually work you need a working<br>
patch.<br>
<br>
good luck!<br>
<br>
greg k-h<br>
</div>
</span></font></div>
</body>
</html>

--_000_BYAPR07MB57828912977C33ABC45E4E10DADE0BYAPR07MB5782namp_--
