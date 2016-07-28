Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <87mvl8tn93.fsf@gmail.com>
References: <cover.1468270393.git.luto@kernel.org> <cover.1468270393.git.luto@kernel.org> <fb3254e25e38790c538cca0f46c4a7a714c77ddf.1468270393.git.luto@kernel.org> <5741.1469162592@turing-police.cc.vt.edu> <4b028b92-81f3-362f-c5be-b7a35cedf5ee@kernel.org> <8376.1469251283@turing-police.cc.vt.edu>
 <87mvl8tn93.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1469698007_4839P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 28 Jul 2016 05:26:47 -0400
Message-ID: <16850.1469698007@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] [PATCH v5 03/32] x86/cpa: In populate_pgd, don't set the pgd entry until it's populated
To: Nicolai Stange <nicstange@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1469698007_4839P
Content-Type: text/plain; charset=us-ascii

On Sat, 23 Jul 2016 16:58:16 +0200, Nicolai Stange said:
> Valdis.Kletnieks@vt.edu writes:

> The reason the patch didn't work for Valdis might be that there is
> another issue in next-20150722 with the same symptoms (provided you
> don't watch the serial console). Valdis, did you apply the provided
> patch on top of next?

Sorry, am on vacation, and no option for a serial console, that's why
I missed the part about there being *two* issues...

> The "other issue" is:
>
> (...)
>  [<ffffffffb6055487>] load_microcode.isra.1.constprop.12+0x37/0xa0

> I bisected this one to 21ef9a5c3164 ("Merge branch 'x86/microcode'"). Both
> of its parents do not exhibit that behaviour.  This merge's author is
> Ingo Molnar, so I added him to the CC list.

Confirming that I'm up and running on next-20160727 plus Borislav's patch:

Subject: [PATCH -v2 2/2] x86/microcode/intel: Fix initrd loading with  CONFIG_RANDOMIZE_MEMORY

with USERCOPY, Andy Lutomirski's stack/thread cleanup work, and microcode loading
from initramfs all working....




--==_Exmh_1469698007_4839P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBV5nP1wdmEQWDXROgAQLW9Q/+IDHjTFFsV+V7Q7bbyXVGiNume5W7ruWY
y+mhckRcX6hU5ZyFOYTDXDJCb3tRFjWmfqmxO8I8VCo6z1bTkkbEFPUxRYlqGdNA
iea0Qn9VcMiwS757JR6VIlGvnQbNizLK18FltCNnSHUw0E8P3n8sIvZ0c9N39rDH
0UV53Ak3Z0/Ix/TV4Nr2SpO7HLPSR027gi2xLZ9ArlcjYKtXDXTmJt2kctTUEaYH
O6przlJFzrx6HzsApBgpTzJ3rtsyjsgXw16DouqXMlMHdftKrw7z34x+5PN/pkOj
P7iCmFOQrEtH83Lui+CB9mW1sn2L6m8Oqaml1xtoVc6HVcGsBTZMh8m2F/iUE5tW
TM016SU1wDhPlP+nwjPiK4nQA+0A+fD5rCj4P0wW081cLppeJGW6OOBRtc+FtWqA
GRXJuYSqdrqmNCOcvNO08/tAnXW1JYEO5AGAVnl27HG0u+LhZ1jq0mLIJGRjVqFu
hpbk9Dz9+8paHzqEODGTSx72XvEEgS0SVFZDSRqqj0dN0Mg+fz1XW1GxEibOaUGd
RFcbb5rA0pQwkHQtqjidPb9xPUBN12Xud95fUaJ0C+Jtw+Pu1UdaVQpdOzKw2v7H
xw0Ipfi/7BC1ApFMRadHwr9436GBkX7//+8iHsAJrWKjTX4AF/jcJNsPG0At6+3L
/51sVWJ0B5w=
=zpBj
-----END PGP SIGNATURE-----

--==_Exmh_1469698007_4839P--
