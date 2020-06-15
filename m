Return-Path: <SRS0=8kJI=74=lists.openwall.com=kernel-hardening-return-18981-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FA5C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 16:25:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ED345207DA
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 16:25:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GWDefzid"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED345207DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18981-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28447 invoked by uid 550); 15 Jun 2020 16:24:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15549 invoked from network); 15 Jun 2020 16:22:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : message-id :
 content-type : mime-version : subject : date : in-reply-to : cc : to :
 references; s=corp-2020-01-29;
 bh=9LPSGGeBHXZlI3mrDl11xSAyahEZRFnjRlfXvOp90rc=;
 b=GWDefzidqVC2brxh0WZ3BGv+lh9SaJibEB6XXXxy2sL7OaZ40fA/VnAXniUJaDb2gaM0
 Xwj7QVdaun1tZYVMybjnzyekweavZr8nAXjscgFvk7s2NiIZvOMF/UB/iMqnDsgdwbeA
 RuzTwdBqjHlq73celgtaC97LyUFdnTlecx10KisqhUI8UiHAo8yren4tbhN5bTJbyh17
 Xke5C46mrV6hox4mDesf8ltppp5BYCARQRJKSmszeUOQuXp6+jckSvIngOFxptwDq8BT
 Rfu9rSdNlqzlyJ5kATvbU4eNnlSskbxM5uX/JTmo6dR8exoG8byklEZDlteCk6YESe7J xA== 
From: John Haxby <john.haxby@oracle.com>
Message-Id: <206DB19C-0117-4F4B-AFF7-212E40CB8C75@oracle.com>
Content-Type: multipart/signed;
	boundary="Apple-Mail=_79F4D81D-D509-4941-8339-0DAC46A53B1C";
	protocol="application/pgp-signature";
	micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [oss-security] lockdown bypass on mainline kernel for loading
 unsigned modules
Date: Mon, 15 Jun 2020 17:22:27 +0100
In-Reply-To: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
Cc: linux-security-module@vger.kernel.org, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        kernel-hardening@lists.openwall.com,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>
To: oss-security@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 clxscore=1034 mlxscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 cotscore=-2147483648 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006150127


--Apple-Mail=_79F4D81D-D509-4941-8339-0DAC46A53B1C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi Jason,


> On 15 Jun 2020, at 11:26, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>=20
> Hi everyone,
>=20
> Yesterday, I found a lockdown bypass in Ubuntu 18.04's kernel using
> ACPI table tricks via the efi ssdt variable [1]. Today I found another
> one that's a bit easier to exploit and appears to be unpatched on
> mainline, using acpi_configfs to inject an ACPI table. The tricks are
> basically the same as the first one, but this one appears to be
> unpatched, at least on my test machine. Explanation is in the header
> of the PoC:
>=20
> =
https://git.zx2c4.com/american-unsigned-language/tree/american-unsigned-la=
nguage-2.sh
>=20
> I need to get some sleep, but if nobody posts a patch in the
> meanwhile, I'll try to post a fix tomorrow.
>=20
> Jason
>=20
> [1] https://www.openwall.com/lists/oss-security/2020/06/14/1


This looks CVE-worthy.   Are you going to ask for a CVE for it?

jch

--Apple-Mail=_79F4D81D-D509-4941-8339-0DAC46A53B1C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iHUEAREIAB0WIQT+pxvb11CFWUkNSOVFC7t+lC+jyAUCXuegQwAKCRBFC7t+lC+j
yItsAQCs9qh0q24Rr/pL5VTN/Nt6fJj38GzSCQNVyCcBs8X55gD+OdD6c88Q91b/
tFCKvrk8joQsG5RiFiqNQpod8AORs+s=
=x0MT
-----END PGP SIGNATURE-----

--Apple-Mail=_79F4D81D-D509-4941-8339-0DAC46A53B1C--
