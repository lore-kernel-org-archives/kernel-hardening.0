Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dwindsor@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (1.0)
Date: Sun, 9 Oct 2016 10:04:03 -0400
Message-Id: <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
References: <1476016472.2329.38.camel@cvidal.org>
In-Reply-To: <1476016472.2329.38.camel@cvidal.org>
Subject: Re: [kernel-hardening] self introduction
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Colin,

If you're interested, the HARDENED_ATOMIC team is looking for people to help=
 porting the feature to other architectures.  ARM is a reasonable candidate f=
or someone new to the project.  I have begun this effort myself, but if you'=
d like to collaborate I'd be grateful. =20

It essentially involves porting the original arch-specific features from PAX=
_REFCOUNT into Elena Reshetova's official HARDENED_ATOMIC tree, which can be=
 found at https://github.com/esreshetova/linux-stable

Please contact me if you have any questions; I'd be glad to help!

Thanks,
David


> On Oct 9, 2016, at 8:34 AM, Colin Vidal <colin@cvidal.org> wrote:
>=20
> Hi all,
>=20
> My name is Colin Vidal. I am currently a PhD student in computer
> science. My researches  consist on building a dedicated specific
> language on top of JavaScript in order to handle asynchronous events in
> a synchronous style. Hence, with a direct relation between the control
> flow and the instruction flow.
>=20
> Beside my researches, I am taking up the Eudyptula Challenge (task 15
> submitted). It helps me to have a global view of the kernel
> (organization, tree, some features), but it is not enough to get
> involved in serious development. Therefore, I am looking for task I can
> accomplish to be involved into real kernel development!
>=20
> I still don't have yet a narrow idea about where I can begin. I like
> though the idea of kernel self protection. For instance, I find the VM-
> mapped stack to be really interesting, but I think it is an overkill as
> a beginning, and a lot of work have already been done on it. On the
> architecture point-of-view, I have a preference of x86 since I only
> have this hardware for now, but I can work on ARM and others with QEMU
> too.
>=20
> Thanks,
>=20
> Colin
