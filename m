MIME-Version: 1.0
In-Reply-To: <20170917060457.GB10599@zzz.localdomain>
References: <20170916130034.17706-1-Jason@zx2c4.com> <20170916130533.23036-1-Jason@zx2c4.com>
 <20170917060457.GB10599@zzz.localdomain>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sun, 17 Sep 2017 13:50:40 +0200
Message-ID: <CAHmME9rjrz2Pn39ay3myApBeBtQAPNt0C+NvmFoV28NeT4_zLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5] security/keys: rewrite all of big_key crypto
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Sep 17, 2017 at 8:04 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> This should jump to 'err_enckey', otherwise it will leak 'enckey'.

Yikes, good catch, thanks!

>
> Otherwise the changes all look good; after fixing the above, feel free to add my
> Reviewed-by.

Ack.

> Yes, AES-GCM is the right choice here.  It is, however, almost
> certainly the case that if someone can modify your swap partition, they can
> already own your system in many other ways, so the "authenticated" portion of
> "authenticated encryption" may not actually buy much in this situation :-)

True, though this is slightly different from people putting their
big_keys on NFS, I guess (but who would do such a thing anyway?).

> The patch is a little long and perhaps should be split into several patches,
> each of which fixes one bug; but see what David thinks.

Meh, it's a rewrite, so sure, it's long. I saw a bunch of bugs and
rewrote the whole thing rather than going one-by-one with the bugs,
which would have produced a series. Personally I'd prefer to keep it
like this than spending the time needling away with git and extra
commit messages and struggling to make them each build separately.
Seems like very very little gain for the time required to do that
right. *shrug* Will wait to hear from David.

> I should also note, that while there definitely were some inadmissible bugs
> here, the support for encrypting big_key's was only added recently, in the v4.7
> kernel.  And obviously not encrypting at all is at least as much as a
> "vulnerability" as using weak encryption.

Yea that's fair. I'm mostly just running around like a headless
chicken after seeing ECB and wondering how this got committed in the
first place, but nobody really takes chickens seriously. But yes, I
suppose one way of considering this is just to say, "big_keys did not
use encryption before 4.14, even though the code was really
complicated."

> I'm also a little skeptical that
> people actually care enough about big_key's for it to be worthwhile to mark a
> rewrite like this for stable, though I suppose it wouldn't be *too* hard to at
> least cherry-pick this to 4.9 if you wanted.  (There is a small conflict so
> you'd have to send the backport yourself after this goes into mainline.)

I imagine the conflicts will be moving back from get_random_bytes_wait
to get_random_bytes and maybe the loff_t/kernel_{read,write} thing. Is
this what you had in mind too? I should be able to handle those fairly
easily and send it to Greg manually after this lands.

Thanks again for the review, very appreciated.

Regards,
Jason
