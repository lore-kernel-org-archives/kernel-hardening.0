Date: Sat, 3 Jun 2017 07:30:07 -0400
From: Brad Spengler <spender@grsecurity.net>
Message-ID: <20170603113007.GA1544@grsecurity.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
Subject: [kernel-hardening] Stop the plagiarism
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

http://www.openwall.com/lists/kernel-hardening/2017/06/03/11

Guys, this is your *last warning*.  This stops *now* or I'm sending lawyers
after you and the companies paying you to plagiarize our work and violate
our *registered* copyright (which for the record entitles us to punitive
damages which now are very easily provable).  It's time to get serious
about attribution -- what you are doing is completely unacceptable.  I'm
already in contact with lawyers to prepare for the next time this happens.
If any of this plagiarized and misattributed code actually made it into
the Linux kernel, you'd all be in a world of pain.

Matt -- did you not see in the directory the Kconfig file was copy+pasted
=66rom the following:

# grsecurity - access control and security hardening for Linux
# All code in this directory and various hooks located throughout the Linux=
 kernel are
# Copyright (C) 2001-2014 Bradley Spengler, Open Source Security, Inc.
# http://www.grsecurity.net spender@grsecurity.net
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 2
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,=
 USA.

Yet you are claiming copyright entirely over my work.  Your copy+pasted
Kconfig entry didn't even adjust for your renaming of my sysctl variables.
Search+replace of config and function names is not transformative, and
I dare to think how much of your tpe_lsm.c is copy+pasted from cormander's
LSM.

I know it must be hard for the KSPP, having no original ideas of its
own, but this is not security or development.  It's mindless plagiarism
and illegal.  Then to slap your own copyright over the whole copy+pasted
thing is a total insult and demonstrates the complete lack of respect
KSPP has for the work it can't accomplish anything without.  The KSPP
and the companies funding it wouldn't be able to show a shred of perceived
progress were it not for its ability to simply copy+paste portions of
our work, because every time you modify something you introduce bugs and
new vulnerabilities, demonstrating your cluelessness.

While I'm here:
http://openwall.com/lists/kernel-hardening/2017/06/02/3

"a value linux-hardened and grsecurity have used for a long time now"
Rik, you're giving credit to a project that didn't even exist a couple
weeks ago, yet they've somehow used it "for a long time", even though
it only exists there because it was copy+pasted from grsecurity?  Is
that what we do now, credit plagiarists instead of the actual authors of
the work?  Sorry, but the "work" of struggling to understand code that
isn't yours doesn't suddenly make it your code.

https://lwn.net/SubscriberLink/724319/830a4de15663b8dd/
over a dozen mentions of various forms of "Cook's implementation"
that was blindly copy+pasted from PaX (as evidenced by its bugs and
complete misunderstanding of how the original PaX code works since
it didn't copy+paste all the parts it needed).  And of course Kees
is nowhere to be found to correct the misattribution of the work because
it benefits him and his perceived security ability.  There's a word for
that: charlatan.

Or how about this one:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D2f48641cfc83c3e1fdc81204382e05edf182691a
First three copied directly from grsecurity, presumably you submitted
some patch series to a mailing list where only the 0/N cover mail mentioned
grsecurity, and now there's no mention whatsoever of where the changes
came from in the first place.  You guys are seriously playing with fire,
and it seems like an intentional act of revenge for being cut off from
our work (lest I remind you of the legal and financial consequences of
willful copyright infringement).

This is exactly how your plagiarism works.  This is exactly why you
no longer have access to our work -- do you not get how incredibly
infuriating this is?

This is your last warning.  This is not a new problem and it needs to
end completely, or I will make sure it ends.

-Brad


--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJZMp24AAoJEETRwPglJf5J4PoP/jVHlg4OgXnzpebNxxTEFRVa
uJEX/bVZyd6hTNR5pepqItZNYwtoL6VVFTDyu4wExrGlcYycQqUnmm5Oq6Dd9lie
8YK/XRs0+B6uefBWb7kYNnY46IFB+Gj/MvbKf1heL+R7dIVE/uSqkhs1nkhvE1L2
8WgpCqL1eBjSUTVdDtHQb2t8PcPiOAp+CQuMrPVVR6jn3KTIRylwYyeLyrJFB9MN
dpIo58/PtOeaICB/0f5faueHUBPU6l7JfM+TXSPg2OZ2rd4AHaobZT+WIFdYaZac
QF9d3/mAHeOT23klMO/bVXytKmvpE2yeSpdi30DePqaHJ8789I48QJExaE/xxtxE
F6eheyzJeefdWHwHt/VZ7RXKcXoY093yS1nm1ijds28fXgJchbIDQ1i3+8CF9NFB
MeFAZ6ZlTU1z9f4eq0AopvH/mQjsyCasBNA1UiMZLNMnDNXEdmmQJcwp2zmoENyv
lOkjy/xk/l9lipW5cfzqKo8dOVeFFSU/AiVc6wWu9Akfl/+oidyfzF9duG0SKldD
IHqhODgTQsQAic6+LLEJQMLdMHsG6spBdmyhmq49YUN7nYH3IEBYyI7YYhyQO1+m
qWR3HV7SDmIxyFjOCvOg2YOzj4SusyzLeRgtVHKObOts9wJsDqATCMYesK/NVEjG
j1oUyZ7XmMqKgS4dxiLv
=LJbp
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
