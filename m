Message-Id: <595C9079020000A100026F37@gwsmtp1.uni-regensburg.de>
Date: Wed, 05 Jul 2017 09:08:41 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-7-Jason@zx2c4.com>
 <20170608024357.fhyyentj2qm7ti2q@thunk.org>
 <CAHmME9pViOqqDPyjXKLfCWSTnQrcE4OLJMdK1yaTiUvrOV+ecQ@mail.gmail.com>
 <fbca1b2b-c9ae-80ce-45ef-17c3d3b93e57@suse.com>
 <CAHmME9rU_H6Jq7ArjDq1yByrYf1P7nyC4Y8tqkzG585U39MFLg@mail.gmail.com>
 <02d60ed4-4207-dd7d-8826-0f9f7f4e966d@suse.com>
 <CAH8yC8nHX2r9cfQ0gNeJAUrgSfAS8V16dVHv35BRnLn-YprZCg@mail.gmail.com>
In-Reply-To: <CAH8yC8nHX2r9cfQ0gNeJAUrgSfAS8V16dVHv35BRnLn-YprZCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Subject: Antw: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi:
 ensure RNG is seeded before use
To: Lee Duncan <lduncan@suse.com>
Cc: David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, open-iscsi <open-iscsi@googlegroups.com>, "Nicholas A.Bellinger" <nab@linux-iscsi.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ted Ts'o <tytso@mit.edu>, Chris Leech <cleech@redhat.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org, "Jason A.Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

>>> Jeffrey Walton <noloader@gmail.com> schrieb am 17.06.2017 um 16:23 in =
Nachricht
<CAH8yC8nHX2r9cfQ0gNeJAUrgSfAS8V16dVHv35BRnLn-YprZCg@mail.gmail.com>:

[...]
> But its not clear to me how to ensure uniqueness when its based on
> randomness from the generators.

Even with a perfect random generator non-unique values are possible =
(that's why it's random). It's unlikely, but it can happen. The question =
is whether the probability of non-unique values from /dev/urandom is any =
higher than that for values read from /dev/random. One _might_ be able to =
predict the values from /dev/urandom.

Regards,
Ulrich

>=20
> Jeff
>=20
> --=20
> You received this message because you are subscribed to the Google =
Groups=20
> "open-iscsi" group.
> To unsubscribe from this group and stop receiving emails from it, send =
an=20
> email to open-iscsi+unsubscribe@googlegroups.com.
> To post to this group, send email to open-iscsi@googlegroups.com.
> Visit this group at https://groups.google.com/group/open-iscsi.
> For more options, visit https://groups.google.com/d/optout.
