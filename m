Reply-To: kernel-hardening@lists.openwall.com
From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Thu, 6 Oct 2016 14:59:54 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC561CD14812@ORSMSX103.amr.corp.intel.com>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
 <20161006133147.GA20206@infradead.org>
 <476DC76E7D1DF2438D32BFADF679FC561CD14651@ORSMSX103.amr.corp.intel.com>
 <20161006135612.GA21342@infradead.org>
In-Reply-To: <20161006135612.GA21342@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH] printk: introduce kptr_restrict level 3
To: Christoph Hellwig <hch@infradead.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "corbet@lwn.net" <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, October 6, 2016 9:56 AM
> To: Roberts, William C <william.c.roberts@intel.com>
> Cc: Christoph Hellwig <hch@infradead.org>; kernel-
> hardening@lists.openwall.com; corbet@lwn.net; linux-doc@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] printk: introduce kptr_restrict level 3
>=20
> On Thu, Oct 06, 2016 at 01:47:47PM +0000, Roberts, William C wrote:
> > Out of tree modules still affect core kernel security.
>=20
> So don't use them.
>=20
> > I would also bet money, that somewhere In-tree someone has put a %p
> > when they wanted a %pK.
>=20
> So fix them.

As Jann Horn points out, "And in total, there are 13578 matches for %p[^FfS=
sBRrhbMmIiEUVKNadCDgG] throughout the kernel. Reviewing all of those manual=
ly would suck."

>=20
> > So this method is just quite error
> > prone. We currently have a blacklist approach versus whitelist.
>=20
> Or fix the entire thing, get rid of %pK and always protect %p if you can =
show that
> it doesn't break anything.
>=20
> But stop posting patches with bullshit arguments like out of tree modules=
.

Ok perhaps the commit message sucks, and I should have included the large s=
pread usages of %p throughout
the kernel, I assumed those would just be known, I shouldn't have made that=
 assumption.

We should care about out-of-tree modules wrt security as they affect the se=
curity of the whole system, especially when the
modules are linking to core symbols like printing and string routines. Ther=
e are tons of %p usages throughout the
kernel as noted above.

This is pretty low hanging fruit and we should fix this, as Kees points out=
.
