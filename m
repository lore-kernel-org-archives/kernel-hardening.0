Date: Sun, 4 Jun 2017 07:43:21 -0400
From: Brad Spengler <spender@grsecurity.net>
Message-ID: <20170604114320.GA1437@grsecurity.net>
References: <20170603113007.GA1544@grsecurity.net>
 <CAGXu5j+YGaczVB7xE9t_M83dcGJjmQsr=weQwEG3NHsmHrK7SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <CAGXu5j+YGaczVB7xE9t_M83dcGJjmQsr=weQwEG3NHsmHrK7SA@mail.gmail.com>
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, pageexec@freemail.hu
List-ID: <kernel-hardening.lists.openwall.com>


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 04, 2017 at 12:16:43AM -0700, Kees Cook wrote:
> (Hilariously, this email was detected as spam and never hit my inbox.
> Dug it out now...)

I'm glad you're taking this so seriously that you find it all hilarious.
It really sets a great example for the rest of the KSPP and demonstrates
the great deal of respect for the work your entire career has been based of=
f.

> There have been a few cases of grsecurity's copyright notice going
> missing from things it shouldn't have, and it got corrected. People
> make mistakes, especially those that are new to upstream Linux kernel
> work. You've pointed the mistakes out before, and I've asked that
> people contact you when there is question about how to do attribution:
> http://www.openwall.com/lists/kernel-hardening/2016/05/20/6
>=20
> Perhaps a more prominent FAQ entry is needed on the KSPP Wiki?
That might help, and also self-policing so that we don't need to be the
ones monitoring every commit and having to bring these issues up again
and again.  For the record, to my knowledge I don't know of anyone
who has contributed code to the KSPP who has emailed us to ask how to
do that attribution.  Copyright attribution is a legal mandate, questions
about how to do that are better suited for a lawyer.  Attribution of
ideas/"inspired" code etc is a moral issue (and this is where plagiarism
comes into play).

The problem is that there are two issues here, there's the use of
the grsecurity trademark and the verbatim lifting of code, use of ideas
and various other "inspiration".  Frankly, the KSPP code quality and
security understanding is so poor that I wish we weren't associated with
it in any way at all.  But since there's so much marketing happening
by KSPP-funding companies, we need to make sure that people understand
both where the original work comes from, the extent to which that work
is verbatim, and that we have nothing to do with the bugs and omissions
resulting from non-skilled non-security-expert understanding of that code.

As far as what would make us happy, something like this would be perfect,
especially if the changelog makes certain claims about larger features.
Obviously it's overkill for smaller changes, but since you asked:

Blah is verbatim/modified from Brad Spengler/PaX Team's code in the last
public patch of grsecurity/PaX based on my understanding of the code.  Chan=
ges
or omissions from the original code are mine and don't reflect the original
grsecurity/PaX code.

But if you also want to know how to attribute, there's the Linux kernel's
own DCO, which you and the rest of the KSPP are violating left and right.
Here are some select quotes:
"  If you are a subsystem or branch maintainer, sometimes you need to sligh=
tly
   modify patches you receive in order to merge them, because the code is n=
ot
   exactly the same in your tree and the submitters'. If you stick strictly=
 to
   rule (c), you should ask the submitter to rediff, but this is a totally
   counter-productive waste of time and energy. Rule (b) allows you to adju=
st
   the code, but then it is very impolite to change one submitter's code and
   make him endorse your bugs. To solve this problem, it is recommended that
   you add a line between the last Signed-off-by header and yours, indicati=
ng
   the nature of your changes. While there is nothing mandatory about this,=
 it
   seems like prepending the description with your mail and/or name, all
   enclosed in square brackets, is noticeable enough to make it obvious that
   you are responsible for last-minute changes.
"

"  Note that under no circumstances can you change the author's identity=20
   (the From header), as it is the one which appears in the changelog.
"

"  The canonical patch message body contains the following:

   - A ``from`` line specifying the patch author (only needed if the person
     sending the patch is not the author).
"

"  From: Original Author <author@example.com>

   The ``from`` line specifies who will be credited as the author of the
   patch in the permanent changelog.  If the ``from`` line is missing,
   then the ``From:`` line from the email header will be used to determine
   the patch author in the changelog.
"

As far as I know, none of these rules have ever been followed for our code.
Further, the author field has been used in the past (eg. by James Bottomley)
as "proof" of our lack of authorship of code in the Linux kernel:
https://lwn.net/Articles/663629/
"
  > as for getting code upstream, how about you check the kernel git logs
  > (minus the stuff that was not properly credited)?
  jejb@jarvis> git log|grep -i 'Author: pax.*team'|wc -l
  1
  Stellar, I must say.
"

> > https://lwn.net/SubscriberLink/724319/830a4de15663b8dd/
> > over a dozen mentions of various forms of "Cook's implementation"
>=20
> Let's see, the paragraph in the article that talks about the proposal
> credits PaX/grsecurity. Clicking through to my proposed series shows
> the first paragraph crediting PaX/grsecurity. You seem to be arguing
> semantics, rather than credit?

Did you not see:
https://lwn.net/Articles/724396/
https://lwn.net/Articles/724401/

> this LWN article being published. And as I already said, it's not
> misattributed. You're just willfully misreading it.

Clearly based on other comments other people found it misleading as well --
perhaps you are just in denial about how damaging this kind of stuff is?
As was mentioned there, you properly credited it, but others misattributed
it to you.  It'd be as if I backported an ext4 encryption patch, and then
LWN writes an article about "my" implementation and "my" code and "my" work.
You don't find that misleading at all?  Assuming you had seen the article,
would you have corrected it yourself, or would you act in the same way as
you've demonstrated with every other misattribution and misleading marketing
that benefits you and the KSPP and ignore it, expecting it to magically
resolve itself?  Because going forward those kinds of lies and damaging
claims are going to be resolved with lawsuits.  This has been going on
for almost two years now and forced us to remove the public patches
entirely because of all this nonsense to try to put and end to it, but
clearly no matter of complaining is stopping it, so we have no other
option left.

> your tired rants about how things should be done "better" are hollow.

Oh man, you're going to have a rude awakening soon -- hold that thought
for now ;)  Here's a hash of the title of the blog post (with newline):
a7c3bde4c22b57a3edc03d40f4228300e6a022a00eeaccedfc06b31e0d8a3743

> Make up your mind about how you want grsecurity attributed and maybe
> people will actually do it "right". But you don't seem to actually
> want that, since you appear to just want to discourage anything that
> even looks like grsecurity from going upstream. If you think you're
> amply credited, you get mad that it's TOO MUCH credit because the
> resulting code is different from grsecurity and it's giving you a bad
> name somehow.

Yes, as I mentioned above, it's due to two separate issues.  One is using
the grsecurity reputation as a crutch for your own ability and marketing
based off it, and the other is ensuring attribution of the original
ideas/code.  It seems pretty simple to me.

> grsecurity. Just ask arm64 system builders how useful grsecurity was
> for them.

Yeah just ask those same system builders how much they were willing
to pay for any arm64 work, Google included.  ARM64 is your hobby horse,
you like bringing it out as an example every chance you can get, because
it's the only example you can bring up of any original work being done.
I learned my lesson with my ARM work not to do any more free work for
that industry.

> You've been upset in the past about seemingly NIHed code like
> VMAP_STACK or ARM's use of Domains, but those were implemented without
> those authors reading grsecurity, IIUC. In fact, you've regularly
> harassed them because you think their implementations are bad. That
> can hardly be considered uncredited derivative work.

I don't just think they're bad, they are bad -- I explained what's wrong
with them.  How many dozen CVEs for VMAP_STACK are needed to prove it in
your mind?  Three? Four?  Also I tend not to believe people who post on
LKML about deep details of some code they looked at, who then try to claim
later that they never looked at it deeply:
https://lwn.net/Articles/692208/

As for the ARM PAN code, I'm glad you brought it up because it's time to
put the facts of this one to rest.

I do hope one day for the mystery to be solved of how a public mail from Go=
ogle:
http://lists.infradead.org/pipermail/linux-arm-kernel/2015-August/365056.ht=
ml
magically got responded to within 3 days with a patch ready:
http://lists.infradead.org/pipermail/linux-arm-kernel/2015-August/365662.ht=
ml
mentioning prior private discussions (with Google?) and Catalin Marinas,
whom I had told explicitly of my ARM work (the LPAE TTBR0 trick, a bug
in marking sections read-only under LPAE, and the domain
implementation) in 3 emails on Jan 2nd 2013, Jan 3rd 2013, and Jan 21
2013, and then also followed up on Feb 19 2013 with a link to the ARM
KERNEXEC/UDEREF blog post.  Lo and behold, the patchset based on
private discussions with the person I directly shared the
implementation ideas with (and long after I had already presented on
them, published the code, and the detailed blog) appears without any
credit.  Perhaps caught the cryptomnesia bug that's been going around.

> You appear to be trying to bully people into not contributing to the
> upstream effort to make Linux more secure. Please stop.

You appear to be justifying plagiarism and copyright/trademark infringements
in the name of making Linux "more" secure.  Please stop.

> I have bent over backwards to credit grsecurity as best as I can see
> how, and you're still going on rants. If you want people to credit
> grsecurity in some specific way, then please detail the method they
> should follow. If you don't have a specific way you want to be
> credited, I must conclude that you're just trying to be an
> obstructionist.

I'm still going on "rants" because the KSPP as a whole continues to
surround itself with misleading marketing no member ever takes initiative
to correct, and continues to remove copyright notices and/or replace them
with someone else's.  A rant will be the least of your worries if this
continues, and as creator of the KSPP and effective figurehead/spokesperson
you'd be wise to start taking it seriously.

-Brad

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJZM/JRAAoJEETRwPglJf5Jud4P/048xLNJpHMtWzqNQFxewO2/
3Itjt8zBVrBH4oH5t6fOoSfHzKKE0U3UEa8jYduAEjIgOwEjcDfSiGaQGULl32cL
dlkYgYxGR83mpwXztet1X84lQC8SjWT93ozTVQ/Gb6vgvItPBLwj29vNpCZO9uzY
QqnCRINgYHo8FB+IHqV9Dp37tIIUIXCWSaoBv9yVoZRrYLLal4oJzKWcvqC/Na6q
aXaG9WGGIfnpqWqdtb8/emrXL8qdGHSA+geOq5omcnI0bzvleg3AS1RlocOUZCa2
Mqp34xRtIRTPnWa/CbH5Wudrh+67kUjzNmNcOYpvfR1FUOCq2xzJ1BJhaHtQOx+D
Stduu+dNxv010w76yDDUzTYiCUxbwnd976PXt15gKDLCe2JAWVBckiiV11WDt/Vv
edF3qvfwcrVpPphmgvmVLJ92h5cJKlt6CTz4v/waBzoFP1yXrRuDerO9W8aOb1g7
SJA9o/hGwPhmEgwHUyLV0YFWg5bgKj+sYeOpaSN283x1eGN7tiW4r+1+g7tWIKYH
4u0EjUlJcTSYgCaWFaQPUJJNZFlcWPFtMTwrNjk0xJG+wazSU1iRffagnESVobgM
VK/qyC0Vlza0Qdu0AMMBQPY8xOb0rwn6r24i99gZQhEYLJNU26w0Xu1ltVE5KcXM
mhyv97WzC0S4CVyWP9ev
=J+Fb
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
