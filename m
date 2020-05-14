Return-Path: <SRS0=k1NG=64=lists.openwall.com=kernel-hardening-return-18787-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3536DC433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 10:12:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 92A542065D
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 10:12:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92A542065D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18787-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5624 invoked by uid 550); 14 May 2020 10:12:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5604 invoked from network); 14 May 2020 10:12:49 -0000
X-MC-Unique: y0BDf4GNOjC8TdKy0usypQ-1
From: David Laight <David.Laight@ACULAB.COM>
To: 'Kees Cook' <keescook@chromium.org>, Stephen Smalley
	<stephen.smalley.work@gmail.com>
CC: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-kernel
	<linux-kernel@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, "Alexei
 Starovoitov" <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "Andy
 Lutomirski" <luto@kernel.org>, Christian Heimes <christian@python.org>,
	"Daniel Borkmann" <daniel@iogearbox.net>, Deven Bowers
	<deven.desai@linux.microsoft.com>, Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>, "Jan
 Kara" <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet
	<corbet@lwn.net>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>, =?iso-8859-1?Q?Micka=EBl_Sala=FCn?=
	<mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>,
	=?iso-8859-1?Q?Philippe_Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	"Scott Shell" <scottsh@microsoft.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, Steve Dower
	<steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, Thibaut Sautereau
	<thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel
	<vincent.strubel@ssi.gouv.fr>, "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "linux-api@vger.kernel.org"
	<linux-api@vger.kernel.org>, "linux-integrity@vger.kernel.org"
	<linux-integrity@vger.kernel.org>, LSM List
	<linux-security-module@vger.kernel.org>, Linux FS Devel
	<linux-fsdevel@vger.kernel.org>
Subject: RE: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec
 through O_MAYEXEC
Thread-Topic: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec
 through O_MAYEXEC
Thread-Index: AQHWKZyBpmhTpEnBl0+f5QrKafolWKinXOJQ
Date: Thu, 14 May 2020 10:12:34 +0000
Message-ID: <33eba9f60af54f1585ba82af73be4eb2@AcuMS.aculab.com>
References: <20200505153156.925111-1-mic@digikod.net>
 <20200505153156.925111-4-mic@digikod.net>
 <CAEjxPJ7y2G5hW0WTH0rSrDZrorzcJ7nrQBjfps2OWV5t1BUYHw@mail.gmail.com>
 <202005131525.D08BFB3@keescook> <202005132002.91B8B63@keescook>
In-Reply-To: <202005132002.91B8B63@keescook>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Kees Cook
> Sent: 14 May 2020 04:05
> On Wed, May 13, 2020 at 04:27:39PM -0700, Kees Cook wrote:
> > Like, couldn't just the entire thing just be:
> >
> > diff --git a/fs/namei.c b/fs/namei.c
> > index a320371899cf..0ab18e19f5da 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -2849,6 +2849,13 @@ static int may_open(const struct path *path, int=
 acc_mode, int flag)
> >  =09=09break;
> >  =09}
> >
> > +=09if (unlikely(mask & MAY_OPENEXEC)) {
> > +=09=09if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_MOUNT &&
> > +=09=09    path_noexec(path))
> > +=09=09=09return -EACCES;
> > +=09=09if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_FILE)
> > +=09=09=09acc_mode |=3D MAY_EXEC;
> > +=09}
> >  =09error =3D inode_permission(inode, MAY_OPEN | acc_mode);
> >  =09if (error)
> >  =09=09return error;
> >
>=20
> FYI, I've confirmed this now. Effectively with patch 2 dropped, patch 3
> reduced to this plus the Kconfig and sysctl changes, the self tests
> pass.
>=20
> I think this makes things much cleaner and correct.

And a summary of that would be right for the 0/n patch email.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

