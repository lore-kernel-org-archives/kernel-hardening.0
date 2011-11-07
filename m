Reply-To: kernel-hardening@lists.openwall.com
In-Reply-To: Your message of "Mon, 07 Nov 2011 11:18:32 PST."
             <4EB82F08.8060209@zytor.com>
From: Valdis.Kletnieks@vt.edu
References: <20111107174522.GA2317@albatros> <9718.1320689192@turing-police.cc.vt.edu> <20111107190112.GA3732@albatros>
            <4EB82F08.8060209@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1320696659_3773P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Nov 2011 15:10:59 -0500
Message-ID: <14202.1320696659@turing-police.cc.vt.edu>
Subject: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1320696659_3773P
Content-Type: text/plain; charset=us-ascii

On Mon, 07 Nov 2011 11:18:32 PST, "H. Peter Anvin" said:

> I would like to propose that we add a mount option to procfs, and
> possibly sysfs, called, say, admingrp.  These kinds of files then get
> restricted to the admingrp (defaulting to gid 0 if no admingrp is
> provided).  Historically on Unix there has been a group of people
> (usually "adm", but sometimes "log") who are allowed to read (but not
> write) the log files, which also contains potentially sensitive information.

Probably should be a two part - mount with 'gid=NNN', and then a
perm=027 or whatever, to be treated similar to a umask.  So 027
would allow root to do anything, would disable write for the gid= group,
and turn it off completely for others.  Less paranoid sites could mount
it with perm=002.

Does that cover most of the use cases?

> The current Linux trend seems to be do instead force those users to
> become root constantly, which is *not* helping the situation.

Amen, brother. ;)

--==_Exmh_1320696659_3773P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOuDtTcC3lWbTT17ARAqxRAJ99r5OzIYfVE+qTa4gWco++NmwLiACcDAWm
j3n5548nMvuBbCw2gcwS1OM=
=1HCC
-----END PGP SIGNATURE-----

--==_Exmh_1320696659_3773P--
