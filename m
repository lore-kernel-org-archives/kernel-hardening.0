Date: Thu, 10 May 2018 05:19:31 +1000 (AEST)
From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v3 1/3] big key: get rid of stack array allocation
In-Reply-To: <CAGXu5jLL7NeX+zUNqcYW_LDF87CPg-5Z4R5+FZ5uPDT-sTisng@mail.gmail.com>
Message-ID: <alpine.LRH.2.21.1805100519200.12749@namei.org>
References: <20180424202639.19830-1-tycho@tycho.ws> <CAGXu5jLL7NeX+zUNqcYW_LDF87CPg-5Z4R5+FZ5uPDT-sTisng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: Tycho Andersen <tycho@tycho.ws>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Jason A . Donenfeld" <Jason@zx2c4.com>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 8 May 2018, Kees Cook wrote:

> On Tue, Apr 24, 2018 at 1:26 PM, Tycho Andersen <tycho@tycho.ws> wrote:
> > We're interested in getting rid of all of the stack allocated arrays in the
> > kernel [1]. This patch simply hardcodes the iv length to match that of the
> > hardcoded cipher.
> >
> > [1]: https://lkml.org/lkml/2018/3/7/621
> >
> > v2: hardcode the length of the nonce to be the GCM AES IV length, and do a
> >     sanity check in init(), Eric Biggers
> > v3: * remember to free big_key_aead when sanity check fails
> >     * define a constant for big key IV size so it can be changed along side
> >       the algorithm in the code
> >
> > Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> > CC: David Howells <dhowells@redhat.com>
> > CC: James Morris <jmorris@namei.org>
> > CC: "Serge E. Hallyn" <serge@hallyn.com>
> > CC: Jason A. Donenfeld <Jason@zx2c4.com>
> > CC: Eric Biggers <ebiggers3@gmail.com>
> 
> Please consider this and patches 2 and 3:
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> James, are these something you can take into your tree?

> 
> Thanks!
> 
> -Kees
> 
> > ---
> >  security/keys/big_key.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/security/keys/big_key.c b/security/keys/big_key.c
> > index 933623784ccd..2806e70d7f8f 100644
> > --- a/security/keys/big_key.c
> > +++ b/security/keys/big_key.c
> > @@ -22,6 +22,7 @@
> >  #include <keys/user-type.h>
> >  #include <keys/big_key-type.h>
> >  #include <crypto/aead.h>
> > +#include <crypto/gcm.h>
> >
> >  struct big_key_buf {
> >         unsigned int            nr_pages;
> > @@ -85,6 +86,7 @@ struct key_type key_type_big_key = {
Sure!

-- 
James Morris
<jmorris@namei.org>
