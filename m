Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20111107232750.GA4854@kroah.com>
Date: Mon, 7 Nov 2011 18:40:13 -0500
Content-Transfer-Encoding: quoted-printable
Message-Id: <4BA97845-BA47-47F3-A923-9B24AB7306E9@mit.edu>
References: <4EB82F08.8060209@zytor.com> <20111107192915.GA4690@albatros> <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com> <4EB83674.3040207@zytor.com> <20111107201120.GA5775@albatros> <4EB843FF.5080201@zytor.com> <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com> <4EB84F05.1000704@zytor.com> <CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com> <20111107232132.2c6880a5@lxorguk.ukuu.org.uk> <20111107232750.GA4854@kroah.com>
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
To: Greg KH <greg@kroah.com>
Cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Vasiliy Kulikov <segoon@openwall.com>, Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


On Nov 7, 2011, at 6:27 PM, Greg KH wrote:
>=20
> So, what do we really need revoke() for these days?

As I mentioned at the kernel summit, I'd like revoke along with a formal =
notification from block devices that get ejected to the file system =
layer, and the file system should be able to call a VFS library function =
which revokes all open file descriptor on the ejected block device.  It =
would result in much cleaner handling at the file system level when a =
USB storage device gets pulled.

> But that's getting away from the original topic here, sorry=85

Yup.   But if revoke has come up, I'd like to remind folks that there =
are good uses of it besides just tty devices that receive hangup events. =
  Having the modem connection disappear and the USB device disappear =
isn't all that different from a conceptual point of view.

-- Ted
=20=
