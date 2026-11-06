Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 3E1DC606A32D
	for <kernel-hardening@archiver.kernel.org>; Sat,  7 Nov 2026 01:30:45 +0000 (UTC)
Received: (qmail 7659 invoked by uid 550); 7 Nov 2026 01:28:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9582 invoked from network); 6 Nov 2026 19:25:43 -0000
Date: Fri, 6 Nov 2026 14:25:19 -0500
From: hackman@yuhu.biz
To: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	kernel-hardening@lists.openwall.com, mic@digikod.net,
	paul@paul-moore.com
Message-ID: <20b68774-8985-40cd-bf99-5174d6475356@yuhu.biz>
In-Reply-To: <1cd0f5e304584ab9d0a595a5d35b5649dc232fb2.camel@kjb.biglobe.ne.jp>
References: <ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp> <2026110611-tassel-bubble-dc09@gregkh> <1cd0f5e304584ab9d0a595a5d35b5649dc232fb2.camel@kjb.biglobe.ne.jp>
Subject: Re: [RFC idea] Kernel API Firewall (kaf): subsystem-level attack
 surface reduction for the post-AI-CVE era
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/alternative; 
	boundary="----=_Part_36_132160978.1793993119145"
X-Correlation-ID: <20b68774-8985-40cd-bf99-5174d6475356@yuhu.biz>
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

------=_Part_36_132160978.1793993119145
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The users can also use the livepatch kernel infrastructure for rapid patchi=
ng.
A lot of these issues are solved with small and not very complex patches, t=
hat do come quite fast with the release of the CVEs. Converting a patch to =
a live patch is not that hard these days.

So the users(admins) actually have more than they need to protect them self=
.
On the other hand, if they want to directly disable certain kernel subsyste=
ms, they can build their custom kernel by basing it on the distro kernel th=
ey currently use.
So my argument here is that these knobs that you want to add to the kernel =
are already there. Just there is no runtime configuration for all of them, =
but there is build configuration for them.

Marian

Nov 6, 2026 2:07:59=E2=80=AFp.m. Nakashima Seiichi <s-nakashima@kjb.biglobe=
.ne.jp>:

>=20
>>=20
>> Pick a better distro.=C2=A0 Seriously, if the distro you are paying for
>> isn't
>> keeping it up to date and secure, what are you paying them for?=C2=A0
>> Seems
>> like an odd choice to stick with them given you have a contract
>> saying
>> they need to abide by it...
>>=20
>> good luck!
>>=20
>> greg k-h
>=20
>=20
> Thank you for your comment. Given the high volume of vulnerability-
> related issues lately, I simply shared some ideas in the hope that they
> might help with improvements.

------=_Part_36_132160978.1793993119145
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html>
 <head>
  <meta name=3D"viewport" content=3D"width=3Ddevice-width, initial-scale=3D=
1.0">
 </head>
 <body>
  <span dir=3D"ltr" style=3D"margin-top:0; margin-bottom:0;">The users can =
also use the livepatch kernel infrastructure for rapid patching. </span>
  <br>
  <span dir=3D"ltr" style=3D"margin-top:0; margin-bottom:0;">A lot of these=
 issues are solved with small and not very complex patches, that do come qu=
ite fast with the release of the CVEs. Converting a patch to a live patch i=
s not that hard these days. </span>
  <br>
  <br>
  <span dir=3D"ltr" style=3D"margin-top:0; margin-bottom:0;">So the users(a=
dmins) actually have more than they need to protect them self.</span>
  <br>
  <span dir=3D"ltr" style=3D"margin-top:0; margin-bottom:0;">On the other h=
and, if they want to directly disable certain kernel subsystems, they can b=
uild their custom kernel by basing it on the distro kernel they currently u=
se. </span>
  <br>
  <span dir=3D"ltr" style=3D"margin-top:0; margin-bottom:0;">So my argument=
 here is that these knobs that you want to add to the kernel are already th=
ere. Just there is no runtime configuration for all of them, but there is b=
uild configuration for them. </span>
  <br>
  <br>
  <span dir=3D"ltr" style=3D"margin-top:0; margin-bottom:0;">Marian</span>
  <br>
  <div class=3D"fairemail_quote">
   <div dir=3D"ltr">
    <p>Nov 6, 2026 2:07:59=E2=80=AFp.m. Nakashima Seiichi &lt;s-nakashima@k=
jb.biglobe.ne.jp&gt;:</p>
   </div>
   <blockquote style=3D"margin:0;border-left:3px solid #ccc; padding-left:1=
0px;" type=3D"cite">
    <div>
     <br>
     <blockquote style=3D"margin:0;border-left:3px solid #ccc; padding-left=
:10px;" type=3D"cite">
      <br>
      Pick a better distro.&nbsp; Seriously, if the distro you are paying f=
or
      <br>
      isn't
      <br>
      keeping it up to date and secure, what are you paying them for?&nbsp;
      <br>
      Seems
      <br>
      like an odd choice to stick with them given you have a contract
      <br>
      saying
      <br>
      they need to abide by it...
      <br>
      <br>
      good luck!
      <br>
      <br>
      greg k-h
      <br>
     </blockquote>
     <br>
     <br>
     Thank you for your comment. Given the high volume of vulnerability-
     <br>
     related issues lately, I simply shared some ideas in the hope that the=
y
     <br>
     might help with improvements.
     <br>
    </div>
   </blockquote>
  </div>
 </body>
</html>
------=_Part_36_132160978.1793993119145--
