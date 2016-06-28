Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 28 Jun 2016 17:45:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20160628094522.GB16467@gondor.apana.org.au>
References: <20160628073742.GA15496@gondor.apana.org.au>
 <1eeb00c5098d8096cdb61dc7ee1ddc61b3e80f9e.1466974736.git.luto@kernel.org>
 <cover.1466974736.git.luto@kernel.org>
 <cover.1466974736.git.luto@kernel.org>
 <32026.1467099166@warthog.procyon.org.uk>
 <5182.1467104864@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5182.1467104864@warthog.procyon.org.uk>
Subject: [kernel-hardening] Re: [PATCH v4 02/29] rxrpc: Avoid using stack memory in SG lists in
 rxkad
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 28, 2016 at 10:07:44AM +0100, David Howells wrote:
>
> Since it's (more or less) a one off piece of memory, why not kmalloc it
> temporarily rather than expanding the connection struct?  Also, the bit where
> you put a second rxrpc_crypt in just so that it happens to give you a 16-byte
> slot by adjacency is pretty icky.  It would be much better to use a union
> instead:
> 
> 	union {
> 		struct rxrpc_crypt	csum_iv; /* packet checksum base */
> 		__be32 tmpbuf[4];
> 	};

Feel free to send your own patch to do this.

> Note also that the above doesn't guarantee that the struct will be inside of a
> single page.  It would need an alignment of 16 for that - but you only have
> one sg.  Could that be a problem?

No it's not a problem.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
