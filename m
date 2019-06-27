Return-Path: <SRS0=R2Bm=U2=lists.openwall.com=kernel-hardening-return-16283-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464CEC48BD6
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 10:23:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 721DD208CB
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 10:23:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 721DD208CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16283-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30674 invoked by uid 550); 27 Jun 2019 10:23:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28397 invoked from network); 27 Jun 2019 10:19:57 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,423,1557212400"; 
   d="scan'208,217";a="189009795"
From: "Gote, Nitin R" <nitin.r.gote@intel.com>
To: Kees Cook <keescook@chromium.org>
CC: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>
Subject: Re: Regarding have kfree() (and related) set the pointer to NULL too
Thread-Topic: Re: Regarding have kfree() (and related) set the pointer to
 NULL too
Thread-Index: AdUsykFtUud3fmLZSQCAsXJ9Yw2gPA==
Date: Thu, 27 Jun 2019 10:19:40 +0000
Message-ID: <12356C813DFF6F479B608F81178A561586BDFE@BGSMSX101.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWEwOWQzZDAtYzI4Zi00ZmVkLWI0MWUtZDBmZGI2Nzk3MjVkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSXZNK2xWT3RsNHFvdUVHUkwySWpERW5MemtJU1JVNVlCelZoZG12N3dmVkxjQVM4YmQ0QzRHalZ0MnRZdVpNXC8ifQ==
x-originating-ip: [10.223.10.10]
Content-Type: multipart/alternative;
	boundary="_000_12356C813DFF6F479B608F81178A561586BDFEBGSMSX101garcorpi_"
MIME-Version: 1.0

--_000_12356C813DFF6F479B608F81178A561586BDFEBGSMSX101garcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I'm looking  into "have kfree() (and related) set the pointer to NULL too" =
task.

As per my understanding, I did below changes :
Could you please provide some points on below ways ?

diff --git a/mm/slab.c b/mm/slab.c
index f7117ad..a6e3d1b 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3754,6 +3754,7 @@ void kfree(const void *objp)
        debug_check_no_obj_freed(objp, c->object_size);
        __cache_free(c, (void *)objp, _RET_IP_);
        local_irq_restore(flags);
+       objp =3D NULL;
}
EXPORT_SYMBOL(kfree);

diff --git a/mm/slob.c b/mm/slob.c
index 84aefd9..dcdb815 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -523,6 +523,8 @@ void kfree(const void *block)
                slob_free(m, *m + align);
        } else
                __free_pages(sp, compound_order(sp));
+
+       block =3D NULL;
}
EXPORT_SYMBOL(kfree);

diff --git a/mm/slub.c b/mm/slub.c
index cd04dbd..7cc400a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3947,6 +3947,8 @@ void kfree(const void *x)
                return;
        }
        slab_free(page->slab_cache, page, object, NULL, 1, _RET_IP_);
+
+       x =3D NULL;
}
EXPORT_SYMBOL(kfree);

--_000_12356C813DFF6F479B608F81178A561586BDFEBGSMSX101garcorpi_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;
	mso-fareast-language:EN-US;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;
	mso-fareast-language:EN-US;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-IN" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I&#8217;m looking &nbsp;into &#8220;have kfree() (an=
d related) set the pointer to NULL too&#8221; task. &nbsp;<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">As per my understanding, I did below changes :<o:p><=
/o:p></p>
<p class=3D"MsoNormal">Could you please provide some points on below ways ?=
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">diff --git a/mm/slab.c b/mm/slab.c<o:p></o:p></p>
<p class=3D"MsoNormal">index f7117ad..a6e3d1b 100644<o:p></o:p></p>
<p class=3D"MsoNormal">--- a/mm/slab.c<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;&#43;&#43; b/mm/slab.c<o:p></o:p></p>
<p class=3D"MsoNormal">@@ -3754,6 &#43;3754,7 @@ void kfree(const void *obj=
p)<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; debug_che=
ck_no_obj_freed(objp, c-&gt;object_size);<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __cache_f=
ree(c, (void *)objp, _RET_IP_);<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; local_irq=
_restore(flags);<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; objp =3D N=
ULL;<o:p></o:p></p>
<p class=3D"MsoNormal">}<o:p></o:p></p>
<p class=3D"MsoNormal">EXPORT_SYMBOL(kfree);<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">diff --git a/mm/slob.c b/mm/slob.c<o:p></o:p></p>
<p class=3D"MsoNormal">index 84aefd9..dcdb815 100644<o:p></o:p></p>
<p class=3D"MsoNormal">--- a/mm/slob.c<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;&#43;&#43; b/mm/slob.c<o:p></o:p></p>
<p class=3D"MsoNormal">@@ -523,6 &#43;523,8 @@ void kfree(const void *block=
)<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; slob_free(m, *m &#43; align);<o:p></=
o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } else<o:=
p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __free_pages(sp, compound_order(sp))=
;<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; block =3D =
NULL;<o:p></o:p></p>
<p class=3D"MsoNormal">}<o:p></o:p></p>
<p class=3D"MsoNormal">EXPORT_SYMBOL(kfree);<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">diff --git a/mm/slub.c b/mm/slub.c<o:p></o:p></p>
<p class=3D"MsoNormal">index cd04dbd..7cc400a 100644<o:p></o:p></p>
<p class=3D"MsoNormal">--- a/mm/slub.c<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;&#43;&#43; b/mm/slub.c<o:p></o:p></p>
<p class=3D"MsoNormal">@@ -3947,6 &#43;3947,8 @@ void kfree(const void *x)<=
o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o=
:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; slab_free=
(page-&gt;slab_cache, page, object, NULL, 1, _RET_IP_);<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; x =3D NULL=
;<o:p></o:p></p>
<p class=3D"MsoNormal">}<o:p></o:p></p>
<p class=3D"MsoNormal">EXPORT_SYMBOL(kfree);<o:p></o:p></p>
</div>
</body>
</html>

--_000_12356C813DFF6F479B608F81178A561586BDFEBGSMSX101garcorpi_--
