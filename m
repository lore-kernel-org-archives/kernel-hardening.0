Date: Sat, 3 Jun 2017 23:28:13 -0400
From: Brad Spengler <spender@grsecurity.net>
Message-ID: <20170604032813.GB25424@grsecurity.net>
References: <20170603113007.GA1544@grsecurity.net>
 <1496498027.22395.1.camel@gmail.com>
 <20170603142110.GA7578@grsecurity.net>
 <CA+DvKQ+1BRVgWRcg_anBdf-8cV4=mgu8J9Kf1xVcbZBVePHSsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <CA+DvKQ+1BRVgWRcg_anBdf-8cV4=mgu8J9Kf1xVcbZBVePHSsw@mail.gmail.com>
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Daniel Micay <danielmicay@gmail.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> That's what I said: at one point, it was mentioned in a changelog
> which was removed when grsecurity moved to the next major kernel
> version along with other cases. The attribution wasn't made in the
> patch and there isn't anything similar to the Linux kernel's Git
> history providing a long-term attribution. Only changelogs that were
> removed after each major release and are now entirely gone. It's as if
> you've taken ownership of the code. A third party archive of your
> changelogs hosted lesewhere and the fact that it can be found via a
> search doesn't really change that there isn't attribution in the
> patches either via available commit history or inline comments /
> documentation. I'm not saying that wrong. I'm saying that you're
> getting mad about something less than that.

What are you talking about?  This is like complaining that we don't
have a single file containing all 16 years of history, some 400MB download
if someone wanted to see what the latest changes are.  That commit message
was in changelog-stable.txt which you can still find online in the various
historical git repos and it's still present in the 3.14 changelog that
customers have access to now.  You seem to be blaming your own laziness
on me -- it'd be like me complaining I have to use extra means to find
out who authored something prior to git history.  And now you want to
use your laziness as a reason to try to claim that you don't know what
the authorship is of some code you copy and paste, so you choose to take
credit for it yourself:
https://twitter.com/CopperheadOS/status/871017018010595328
Have you ever even contacted either of us when you were unsure or too
lazy to look it up?  I know the answer to that question, and you know
the answer to that question, so quit with the BS.

> comparison with the last publicly available patch. You also took issue
> with a stack canary fix which you're adamant must have come from PaX
> but that's not what happened: it was noticed and fixed when adding a
> zero byte there to match the earlier changes changing userspace junk
> filling to zeroing and adding a zero byte to the heap canaries and
> stack canaries in userspace.

Cryptomnesia I guess, you looked at every other line of PaX to rip out
stuff like:
https://github.com/thestinger/linux-hardened/commit/e63d5e4db605e74b2d9631219dd58301be484bd7
https://github.com/thestinger/linux-hardened/commit/93b646fed97b51e62cb48e0a25c2664cc2f86e0b
but totally never saw that line that's been there ever since SSP existed
in the kernel.  It also doesn't mesh with your lengthy excuse on github
when I pointed it out to you.  Are the above changes your own work too?


> And how is grsecurity not entirely based on the work of others i.e.
> the Linux kernel, just as CopperheadOS is based on Android Open Source
> Project and all of the baseline functionality and security model
> provided by it?

These false equivalences of yours are nonsense -- anyone can look at
https://github.com/thestinger/linux-hardened/issues
and see how utterly dependent you are.  You are comparing apples and
oranges because you need to to justify your existence.  You didn't
contribute a line of code to our work in 16 years and now you're trying
to make a name for yourself off our work and reputation.  But you just
make a fool of yourself when on one hand you're desperately copy+pasting
and on the other trying to pretend you don't depend on it, or that your
dependence on copy+pasting our work is somehow equivalent to building on
top of whatever version of Linux that exists.

-Brad

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJZM35GAAoJEETRwPglJf5JAT4QAJUcWY13pu/0wES2nX/noPuy
nKMzE4j3PqmhaTvEqhscVzINhc0mXBXVLnZjLEC88FjlpStUcabAzNhRfXdbiKN8
gwMAjB6Hk8hXMlhOL3nJz/xQZoNsV2Nn4WnhAp9UtIVN3GpnxHsWIS/4aZHPdpbn
ugZr/X3co3gCUtDZoqhaFPkHyI7dAsLI8axqegh7rLccoVUv0v3O3N3l0Ac5NQbH
t6/P3xVKNBOjqb9tksGOlWJhm7jO4RqyIUb3hgqD63BTRVn7mp8a4ziCDlfrAkO4
lztJMs7NajrLILio5HRiTq4qvZacR2XtDf/vr5bTrEM64i7gFs4HIS7HkIEDydbY
EVhz+EZWvv9SDK/rXaR246+36X8wpmWUq8kg35ZWXgcZMOsW7ksY40j2iyIxUuLV
FJcGTb8aCPyeQjclgiPtFuwcf/gILyHL2Ek+70lbmgMhUwmjn4iYzNOVRtx+5z1u
ZakT7LvVfETm7T8C0inHFDRN9n2fWdUTUUm2z/BCnQTYzrWiHMjU0oUZjanwa9wR
ax1F+lelB0FH8+YiHzvWqzzloJAftGh+AOiCvM3YuHHaMIbYiaKWed52eka6YYTu
xDVUea7UbGK92QzQIWF80Zw7WZucHeeil9tuxUVYTT093kt5wifdeTo7wYo1c1aW
txtom1o65JQZaXK8KTHc
=tJ5I
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
