Reply-To: kernel-hardening@lists.openwall.com
From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Thu, 6 Oct 2016 13:47:47 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC561CD14651@ORSMSX103.amr.corp.intel.com>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
 <20161006133147.GA20206@infradead.org>
In-Reply-To: <20161006133147.GA20206@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH] printk: introduce kptr_restrict level 3
To: Christoph Hellwig <hch@infradead.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "corbet@lwn.net" <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, October 6, 2016 9:32 AM
> To: Roberts, William C <william.c.roberts@intel.com>
> Cc: kernel-hardening@lists.openwall.com; corbet@lwn.net; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] printk: introduce kptr_restrict level 3
>=20
> On Wed, Oct 05, 2016 at 02:04:46PM -0400, william.c.roberts@intel.com wro=
te:
> > From: William Roberts <william.c.roberts@intel.com>
> >
> > Some out-of-tree modules do not use %pK and just use %p, as it's the
> > common C paradigm for printing pointers. Because of this,
> > kptr_restrict has no affect on the output and thus, no way to contain
> > the kernel address leak.
>=20
> So what?  We a) don't care about out of tree modules and b) you could jus=
t triviall
> fix them up if you care.

Out of tree modules still affect core kernel security. I would also bet mon=
ey, that somewhere
In-tree someone has put a %p when they wanted a %pK. So this method is just=
 quite error
prone. We currently have a blacklist approach versus whitelist.

>=20
> No need to bloat the kernel with crap like this.

It's unconstructive comments like this that do the whole community harm. No=
tice how
responses from Kees Cook were aimed at finding a different solution to the =
problem and were
very constructive. As far as "bloating" goes, it really didn't change a who=
le lot, most of it was moved
lines, and adds maybe a few lines of code.
