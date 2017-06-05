Date: Sun, 4 Jun 2017 20:12:25 -0400
From: Brad Spengler <spender@grsecurity.net>
Message-ID: <20170605001225.GA23953@grsecurity.net>
References: <20170603113007.GA1544@grsecurity.net>
 <1496498027.22395.1.camel@gmail.com>
 <20170603142110.GA7578@grsecurity.net>
 <CA+DvKQ+1BRVgWRcg_anBdf-8cV4=mgu8J9Kf1xVcbZBVePHSsw@mail.gmail.com>
 <20170604032813.GB25424@grsecurity.net>
 <1496585753.11788.1.camel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1496585753.11788.1.camel@gmail.com>
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Daniel Micay <danielmicay@gmail.com>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu
List-ID: <kernel-hardening.lists.openwall.com>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> And yes my "excuse" is consistent with what I said on GitHub. I became
> of the stack canary issue when Jann Horn told me about it months ago. I
> might have IRC logs from back then. I then assumed it was going to get
> fixed and promptly forgot about it as I do with pretty much every other
> specific bug. I noticed it again when making related changes in
> CopperheadOS but: that's a 3.18 LTS kernel and 3.10 LTS kernels for
> older devices, so it didn't occur to me than Jann might not have gotten
> it fixed in master, and arm64 doesn't use the per-task canaries so I
> didn't need to fix that or add the zero byte there yet. Not sure what is
> so hard to understand about that. I noticed it still wasn't fixed when
> first making linux-hardened by porting those changes ahead.

>=20
> If I *had* done research into the issue to point to when it had been
> first discovered by someone, I wouldn't have found PaX. You don't have

You wouldn't have found PaX eh?

Here's some more history then:
=46rom "months ago", October 2016:
https://patchwork.kernel.org/patch/9405499/
Here's a thread where Jann submitted the same patch as you, where he
mentions it's from PaX (just that PaX used pax_get_random_long()).
You participated in this thread, it's even in the reply context your
reply includes -- look for yourself.  Here's a direct link:
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1262143.html
Then you submitted it upstream and took credit for yourself:
https://marc.info/?l=3Dlinux-kernel&m=3D149390477311752&w=3D2

> You don't have
> patches uploaded on the site from before the earliest mailing list post
> that you pointed me at, which doesn't mention PaX.

There are no patches currently on the website that you can download at all,
does it mean it's fine to take credit for everything in PaX because of that?
Sorry but this is a really lame excuse.

You can agree that 2006 is < 2007 right?  I thought we had already
established that on github, but now you're claiming any amount of research
wouldn't have led to PaX.  So let me show you for future reference how
trivial this is:
https://github.com/linux-scraping/linux-grsecurity/blame/grsec-test/kernel/=
fork.c
ctrl+f get_random_long
note: "11 years ago" on the left
That took all of 10 seconds.

Again not that any of this matters, it's one of many stupid security
weaknesses upstream developers never cared to fix for years, but if
we're going to be making up stories as excuses, let's at least get it
right.  So can we agree it's a case of cryptomnesia, or at minimum you
remembered the facts wrong?

BTW while doing research I found:
http://linux-arm-kernel.infradead.narkive.com/mAf9QhdP/patch-1-5-random-sta=
ckprotect-introduce-get-random-canary-function
which credits "ascii armor" to execshield and PaX/grsecurity.
We've never done ascii armoring in PaX/grsecurity and the technique was
created by solar designer in 1997:
http://insecure.org/sploits/linux.libc.return.lpr.sploit.html
Exec Shield arrived at least 5 years later.

-Brad

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJZNKHhAAoJEETRwPglJf5J6RgQAITMKMjnuDNdMjn9TEEsD3E/
Kp8Wm7mW890zekL9+UqTMCdRhTGzpW6DU3iaD3Df/ZMizP0mNRHDnW0dTf+ql4TH
QgPKZA1EmE09TM6du6YmEiOZ1YLTfUYyBL8XqvFsPw3khNfe6xNmmF7uR1PRqFy2
3kIMCuEUEA++Xbcv4iiMjnTK5B10wQLeI0v7KTJORcFDd+HEAY3UTrbskuYvm8hW
BQaDJrGjYpdG0AZ3l9Ms0gtHhW13F9vx0zxBE82Tm2eqbyeat4zr3c5YXc3wCcWt
vIX0iT8+ndAUdAJet3VGq8vZ0MI0N5/UNR3IbandNB1uxkUoQ6odln9I6xmE9dUt
6cjqUYlSzX1ktXbuI3gAxVPE1ncHfSIlj0Yjlx3lzj18kqyq7sd0cp4yboFFjNB0
DWC5R9E0Rq9JsbjFbcNrf6JRPkYGFIhVyAafyaPGQSQWMlBt/oWFuvaLCmlQs4Xs
7A0jLcbhZRWH/YqY6ltBlv6apHm1JNR/Cf1MJA8hPUQMMvwgVvcZu/BJEBAzBKH1
BBdBYPhu9XdWv5d/gLpCidbQAo/qJrTt1d6Cn5Qi+Vx9ef2xuLo8HjRjMxYinrwU
ZKDj0HxdMENipfyXhL2GOLiz4x5JJ0ojYVGs4DO1eRkL7cb9yhr3PlcUqaTxx6pI
g3NewtgufghAAWFgsy0f
=rVDx
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
