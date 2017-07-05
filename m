Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
From: Paul Koning <paulkoning@comcast.net>
In-Reply-To: <595C9079020000A100026F37@gwsmtp1.uni-regensburg.de>
Date: Wed, 5 Jul 2017 09:16:09 -0400
Content-Transfer-Encoding: quoted-printable
Message-Id: <8CC15605-CFF3-4D6E-ADBE-5EFC9F8E7CE7@comcast.net>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-7-Jason@zx2c4.com> <20170608024357.fhyyentj2qm7ti2q@thunk.org> <CAHmME9pViOqqDPyjXKLfCWSTnQrcE4OLJMdK1yaTiUvrOV+ecQ@mail.gmail.com> <fbca1b2b-c9ae-80ce-45ef-17c3d3b93e57@suse.com> <CAHmME9rU_H6Jq7ArjDq1yByrYf1P7nyC4Y8tqkzG585U39MFLg@mail.gmail.com> <02d60ed4-4207-dd7d-8826-0f9f7f4e966d@suse.com> <CAH8yC8nHX2r9cfQ0gNeJAUrgSfAS8V16dVHv35BRnLn-YprZCg@mail.gmail.com> <595C9079020000A100026F37@gwsmtp1.uni-regensburg.de>
Subject: Re: Antw: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi: ensure RNG is seeded before use
To: open-iscsi@googlegroups.com
Cc: Lee Duncan <lduncan@suse.com>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, "Nicholas A.Bellinger" <nab@linux-iscsi.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ted Ts'o <tytso@mit.edu>, Chris Leech <cleech@redhat.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org, "Jason A.Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>


> On Jul 5, 2017, at 3:08 AM, Ulrich Windl =
<Ulrich.Windl@rz.uni-regensburg.de> wrote:
>=20
>>>> Jeffrey Walton <noloader@gmail.com> schrieb am 17.06.2017 um 16:23 =
in Nachricht
> <CAH8yC8nHX2r9cfQ0gNeJAUrgSfAS8V16dVHv35BRnLn-YprZCg@mail.gmail.com>:
>=20
> [...]
>> But its not clear to me how to ensure uniqueness when its based on
>> randomness from the generators.
>=20
> Even with a perfect random generator non-unique values are possible =
(that's why it's random). It's unlikely, but it can happen. The question =
is whether the probability of non-unique values from /dev/urandom is any =
higher than that for values read from /dev/random. One _might_ be able =
to predict the values from /dev/urandom.

In the implementations I know, /dev/random and /dev/urandom are the same =
driver, the only difference is that when you read from /dev/random =
there's a check for the current entropy level.

If you haven't fed enough entropy yet to the driver since startup, and =
you read /dev/urandom, you get a value that isn't sufficiently secure. =20=


If you have a properly constructed RNG, as soon as it's been fed enough =
entropy it is secure (at least for the next 2^64 bits or so).  The =
notion of "using up entropy" is not meaningful for a good generator.   =
See Bruce Schneier's "Yarrow" paper for the details.

	paul
