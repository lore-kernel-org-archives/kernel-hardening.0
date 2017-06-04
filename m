Date: Sun, 4 Jun 2017 08:49:00 -0400
From: Brad Spengler <spender@grsecurity.net>
Message-ID: <20170604124900.GA7153@grsecurity.net>
References: <20170603113007.GA1544@grsecurity.net>
 <1496498027.22395.1.camel@gmail.com>
 <20170603142110.GA7578@grsecurity.net>
 <CA+DvKQ+1BRVgWRcg_anBdf-8cV4=mgu8J9Kf1xVcbZBVePHSsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <CA+DvKQ+1BRVgWRcg_anBdf-8cV4=mgu8J9Kf1xVcbZBVePHSsw@mail.gmail.com>
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Daniel Micay <danielmicay@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, pageexec@freemail.hu
List-ID: <kernel-hardening.lists.openwall.com>


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> comparable to where it came from. If they independently write the
> features without using your code as a reference (KSTACKOVERFLOW vs.
> VMAP_STACK

This is demonstrably false given Andy's own public statements:
https://lwn.net/Articles/692208/

> ARM memory domain PAN emulation

As posted in the other message, I emailed directly with the person
solely credited for ideas for that work, detailing everything
exactly and linking to the blog post about it.  I leave it up to
others to decide if they think it's at all likely if during discussions
of the topic, it never came in the head of that person that they had
discussed this very exact same thing a few years prior, while coming
up with the same solution.

> an issue with it. You weren't truly interested in being paid to
> upstream it yourself either, only to develop code downstream in a
> massive out-of-tree patch set.

Where's the evidence?  The PaX Team gave permission for anyone to publish
any private contracts and financial terms of real offers made.  Where are
they?  I don't recall if you and I ever had a real discussion about
upstreaming where I laid out the (what should be obvious) concerns --
namely that given that we have limited time, any paid upstreaming work,
being largely a waste of time and non-technical in nature, would need to
also ensure the continuity of the actual technical grsecurity work
and allow us to expand our pool of available hours.  Otherwise there's no
possibility for stable funding to continue any work and no time to do it,
which is exactly the short-sighted thinking I had mentioned to Kees since
the very beginning of the KSPP.  It's pointless to rehash it at this point
since again as mentioned, there is no evidence whatsoever that the
companies funding KSPP ever made any real offers to fund the work.  That
decision was made long ago, and we're simply continuing our work and doing
what needs to be done to ensure it continues.  As a reminder, upstreaming
doesn't solve all problems, and grsecurity would need to continue to exist
regardless of any upstreaming efforts.  You need look no further at the
100 or so KSPP emails about a single-line TIOCSTI change that not one
user has complained about in years.

> available patch. Sending me a legal threat over that tweet was
> ridiculous especially considering that the post linked to by that

You missed a step in there in your public portrayal of private messages
(it's not the first time, but I don't expect much else from someone
who needs to cultivate an image to fool the public into assisting him
with code his business depends on to sell).  Instead of replying to
or acknowledging my initial simple mail, you went on IRC to joke about
it publicly with other people.

-Brad

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJZNAG0AAoJEETRwPglJf5JI+QP/i1IcsJVpv5dT84YdhJKxiAw
1vAlkYuzdprL0RLHnmTqxZZ0Oi6pGdXWIG06jEoUazXqKLGCqg1h/j5cB642DoKz
gu5S04Cb1lvAr4h8Z/llkbS8Ut9IOlbMFJqQm0/Uvahuu73sVpYE1LnUPIUe93uU
kG7yRJ3zJDFfdotJShQ8g7IYNphKIPH/FPp/9QSbimM8AWE/DDWCyxyLa3okPUlm
r8PiHhQvZ5SvymhVJaUz+/1wZcCEBsBv5633B8dBKN8RUP2aIpIsnEAu/Ul2gycB
BG6wMKWaCk4wjUt0HEyKNpBD545tApg4XG16QnLsMTMwObUQpdf4B74gt3tfj5QX
EnQ9NxMpU0MaGCOHifPzG8U+puHF3gVADg2JLpjNkFhj0Vv29MhkUC34ZgIASZCP
b/y7s8+gSQagF5FssXK0HcvDE7JZQCfS+7DToBIBGvK3OogfKf6WghyQ/0fzJa6B
fMaK63A1XjEaTTh4WRknmdMwRTDdk8ljzgu67c1JULM/5XsRAziOHM8sfFn3Npjx
Yi5oT5E4MuJiu1lyR8O5E0Hk3JEDbKgEnJMN0KnuUYXB2gp1MHyUzCgCQgrIYkMP
XcTlhImEQjT6j0Le2rNmfLa5eg4vPNocWrUiGHOhpt3bWhAHK7Wmz4ntlDCN5HkW
4Y2jcWs898y0dJqczbcH
=Frmx
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
