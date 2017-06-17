Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
From: Paul Koning <paulkoning@comcast.net>
In-Reply-To: <CAH8yC8nHX2r9cfQ0gNeJAUrgSfAS8V16dVHv35BRnLn-YprZCg@mail.gmail.com>
Date: Sat, 17 Jun 2017 14:50:50 -0400
Content-Transfer-Encoding: quoted-printable
Message-Id: <46F035A7-5E63-4A96-8F45-45728222CF51@comcast.net>
References: <20170606174804.31124-1-Jason@zx2c4.com> <20170606174804.31124-7-Jason@zx2c4.com> <20170608024357.fhyyentj2qm7ti2q@thunk.org> <CAHmME9pViOqqDPyjXKLfCWSTnQrcE4OLJMdK1yaTiUvrOV+ecQ@mail.gmail.com> <fbca1b2b-c9ae-80ce-45ef-17c3d3b93e57@suse.com> <CAHmME9rU_H6Jq7ArjDq1yByrYf1P7nyC4Y8tqkzG585U39MFLg@mail.gmail.com> <02d60ed4-4207-dd7d-8826-0f9f7f4e966d@suse.com> <CAH8yC8nHX2r9cfQ0gNeJAUrgSfAS8V16dVHv35BRnLn-YprZCg@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH v4 06/13] iscsi: ensure RNG is seeded before use
To: open-iscsi@googlegroups.com
Cc: Lee Duncan <lduncan@suse.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Chris Leech <cleech@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>


> On Jun 17, 2017, at 10:23 AM, Jeffrey Walton <noloader@gmail.com> =
wrote:
>=20
> On Fri, Jun 16, 2017 at 11:45 PM, Lee Duncan <lduncan@suse.com> wrote:
>> On 06/16/2017 05:41 PM, Jason A. Donenfeld wrote:
>>> Hi Lee,
>>>=20
>>> On Fri, Jun 16, 2017 at 11:58 PM, Lee Duncan <lduncan@suse.com> =
wrote:
>>>> It seems like what you are doing is basically "good", i.e. if there =
is
>>>> not enough random data, don't use it. But what happens in that =
case? The
>>>> authentication fails? How does the user know to wait and try again?
>>>=20
>>> The process just remains in interruptible (kill-able) sleep until
>>> there is enough entropy, so the process doesn't need to do anything.
>>> If the waiting is interrupted by a signal, it returns -ESYSRESTART,
>>> which follows the usual semantics of restartable syscalls.
>>>=20
>> In your testing, how long might a process have to wait? Are we =
talking
>> seconds? Longer? What about timeouts?
>>=20
>> Sorry, but your changing something that isn't exactly broken, so I =
just
>> want to be sure we're not introducing some regression, like clients
>> can't connect the first 5 minutes are a reboot.
>=20
> CHAP (https://www.rfc-editor.org/rfc/rfc1994.txt) and iSCSI
> (https://www.ietf.org/rfc/rfc3720.txt) require random values. If iSCSI
> is operating without them, it seems like something is broken. =46rom =
RFC
> 3720, Section 8.2.1, CHAP Considerations:
>=20
>   When CHAP is performed over a non-encrypted channel, it is =
vulnerable
>   to an off-line dictionary attack.  Implementations MUST support use
>   of up to 128 bit random CHAP secrets, including the means to =
generate
>   such secrets and to accept them from an external generation source.
>   Implementations MUST NOT provide secret generation (or expansion)
>   means other than random generation.

That only applies to the generation of the secret, which is configured =
into iscsi, not created by it.  A utility to generate the secret might =
be supplied, of course, just as one might have utilities to generate =
strong passwords, but it's not a component of the iSCSI protocol.

> CHAP actually has a weaker requirement since it only requires _unique_
> (and not _random_). =46rom RFC 1994, Section 2.3, Design Requirements:
>=20
>   Each challenge value SHOULD be unique, since repetition of a
>   challenge value in conjunction with the same secret would permit an
>   attacker to reply with a previously intercepted response.  Since it
>   is expected that the same secret MAY be used to authenticate with
>   servers in disparate geographic regions, the challenge SHOULD =
exhibit
>   global and temporal uniqueness.
>=20
> But its not clear to me how to ensure uniqueness when its based on
> randomness from the generators.

A strong RNG of length n will produce numbers likely to be unique until =
you approach the birtday limit 2^(n/2).  So, say, a 128 bit challenge =
will be adequate.

	paul
