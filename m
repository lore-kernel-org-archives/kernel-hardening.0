Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: penberg@gmail.com
In-Reply-To: <CAOJsxLE5TMXwAHPks-mvk0EPAHC18fDXf345uZ3umkzNkk7-cQ@mail.gmail.com>
References: <20110918170512.GA2351@albatros>
	<CAOJsxLF8DBEC9o9pSwa6c6pMg8ByFBdsDnzg22P3ucQcP98uzA@mail.gmail.com>
	<20110919144657.GA5928@albatros>
	<CAOJsxLG8gW=BLOptpULsaAEwTravADKbNbXp5e9Wd7xVEfR9AQ@mail.gmail.com>
	<20110919155718.GB16272@albatros>
	<CAOJsxLGZm+npcR0YgXSE2wLC2iXCtzYyCdTDCt1LN=Z28Rm_UA@mail.gmail.com>
	<20110919161837.GA2232@albatros>
	<CAOJsxLE2od0f+6cbL2hA_31CbrqS7AUofx5DT2L9fO_7gxH+PQ@mail.gmail.com>
	<20110919173539.GA3751@albatros>
	<CAOJsxLGc0bwCkDtk2PVe7c155a9wVoDAY0CmYDTLg8_bL4qxqg@mail.gmail.com>
	<20110919175856.GA4282@albatros>
	<CAOJsxLFdNVnW6Faap0UaqZQDQxbA_dEiR2HGdzZtGMJFsVR1WQ@mail.gmail.com>
	<CA+55aFwnxOvkS12i97kJcWFrH7n591vxq7vBXKzuROiirnYJ0g@mail.gmail.com>
	<CAOJsxLE5TMXwAHPks-mvk0EPAHC18fDXf345uZ3umkzNkk7-cQ@mail.gmail.com>
Date: Mon, 19 Sep 2011 22:45:07 +0300
Message-ID: <CAOJsxLE=w3_Q+bU4kVC=_g8YBAxXHy4cgfN3ihGVZVA6tytc3g@mail.gmail.com>
From: Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@linux-foundation.org>, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>, Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>, Jesper Juhl <jj@chaosbits.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 19, 2011 at 10:18 PM, Pekka Enberg <penberg@cs.helsinki.fi> wro=
te:
>> Having some aggregate number in /proc/meminfo would probably be fine.
>>
>> And yes, we probably should avoid giving page-level granularity in
>> /proc/meminfo too. Do it in megabytes instead. None of the information
>> there is really relevant at a page level, everybody just wants rough
>> aggregates.
>
> We have this in /proc/meminfo:
>
> Slab: =A0 =A0 =A0 =A0 =A0 =A0 =A020012 kB
>
> Or did you mean something even more specific?

Oh, sorry, I completely misread what you wrote above. Sure, we can
round the numbers into megabytes without breaking the ABI.

                        Pekka
