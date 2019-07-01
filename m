Return-Path: <SRS0=lIjY=U6=lists.openwall.com=kernel-hardening-return-16328-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17553C0650E
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Jul 2019 08:43:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6DAAE20665
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Jul 2019 08:43:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DAAE20665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16328-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23720 invoked by uid 550); 1 Jul 2019 08:42:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23682 invoked from network); 1 Jul 2019 08:42:55 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,438,1557212400"; 
   d="scan'208";a="190179067"
From: "Gote, Nitin R" <nitin.r.gote@intel.com>
To: Kees Cook <keescook@chromium.org>
CC: "jannh@google.com" <jannh@google.com>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: RE: [PATCH] checkpatch: Added warnings in favor of strscpy().
Thread-Topic: [PATCH] checkpatch: Added warnings in favor of strscpy().
Thread-Index: AQHVLahxh0Ae9DcKwUaM2mlMiQSq1aawyP6AgASX1uA=
Date: Mon, 1 Jul 2019 08:42:39 +0000
Message-ID: <12356C813DFF6F479B608F81178A561586C2AC@BGSMSX101.gar.corp.intel.com>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
 <201906280739.9CD1E4B@keescook>
In-Reply-To: <201906280739.9CD1E4B@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZmI5YmIxYTQtY2E5YS00Zjk5LWEyMTUtZGQ0ZTgzZmQ5YTQzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiV0NxZDc3VDJEelJsYkhYMnN1aWlQbUxwMFJ6YWNiK2NLRDZXTThEY0J6eTBPSGdLS1RyeG1OazgwMEVjRzBUTCJ9
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

Hi Kees,

As per my understanding, I have updated strncpy() section in Documentation/=
process/deprecated.rst for strscpy_pad() case. Other two cases of strncpy()=
 are already explained.=20

Also updated checkpatch for __nonstring case.

Could you please give your inputs on below diff changes ? If this looks goo=
d, I will send the patch.

Diff changes :

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/d=
eprecated.rst
index 49e0f64..6ab05ac 100644
--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -102,6 +102,9 @@ still be used, but destinations should be marked with t=
he `__nonstring
 <https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html>`_
 attribute to avoid future compiler warnings.

+If a caller is using NUL-terminated strings, and destination needing
+trailing NUL, then the safe replace is :c:func:`strscpy_pad()`.
+
 strlcpy()
 ---------
 :c:func:`strlcpy` reads the entire source buffer first, possibly exceeding
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 342c7c7..d3c0587 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -595,6 +595,10 @@ our %deprecated_apis =3D (
        "rcu_barrier_sched"                     =3D> "rcu_barrier",
        "get_state_synchronize_sched"           =3D> "get_state_synchronize=
_rcu",
        "cond_synchronize_sched"                =3D> "cond_synchronize_rcu"=
,
+       "strcpy"                                =3D> "strscpy",
+       "strlcpy"                               =3D> "strscpy",
+       "strncpy"                               =3D> "strscpy, strscpy_pad =
Or for non-NUL-terminated strings,
+        strncpy() can still be used, but destinations should be marked wit=
h the __nonstring",
 );

Thanks and Regards,
Nitin Gote

-----Original Message-----
From: Kees Cook [mailto:keescook@chromium.org]=20
Sent: Friday, June 28, 2019 8:16 PM
To: Gote, Nitin R <nitin.r.gote@intel.com>
Cc: jannh@google.com; kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().

On Fri, Jun 28, 2019 at 05:25:48PM +0530, Nitin Gote wrote:
> Added warnings in checkpatch.pl script to :
>=20
> 1. Deprecate strcpy() in favor of strscpy().
> 2. Deprecate strlcpy() in favor of strscpy().
> 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
>=20
> Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>

Excellent, yes. Can you also add a bit to the strncpy() section in Document=
ation/process/deprecated.rst so that all three cases of strncpy() are expla=
ined:

- strncpy() into NUL-terminated target should use strscpy()
- strncpy() into NUL-terminated target needing trailing NUL: strscpy_pad()
- strncpy() into non-NUL-terminated target should have target marked
  with __nonstring.

(and probably mention the __nonstring case in checkpatch too)

-Kees

> ---
>  scripts/checkpatch.pl | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl index=20
> 342c7c7..bb0fa11 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -595,6 +595,9 @@ our %deprecated_apis =3D (
>  	"rcu_barrier_sched"			=3D> "rcu_barrier",
>  	"get_state_synchronize_sched"		=3D> "get_state_synchronize_rcu",
>  	"cond_synchronize_sched"		=3D> "cond_synchronize_rcu",
> +	"strcpy"				=3D> "strscpy",
> +	"strlcpy"				=3D> "strscpy",
> +	"strncpy"				=3D> "strscpy or strscpy_pad",
>  );
>=20
>  #Create a search pattern for all these strings to speed up a loop=20
> below
> --
> 2.7.4
>=20

--
Kees Cook
