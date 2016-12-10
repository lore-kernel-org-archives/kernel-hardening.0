Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 9 Dec 2016 22:30:39 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20161210063039.GA8630@zzz>
References: <20161209230851.GB64048@google.com>
 <CALCETrW=+3u3P8Xva+0ck9=fr-mD6azPtTkOQ3uQO+GoOA6FcQ@mail.gmail.com>
 <20161210053711.GB27951@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161210053711.GB27951@gondor.apana.org.au>
Subject: Re: [kernel-hardening] Re: Remaining crypto API regressions with
 CONFIG_VMAP_STACK
To: kernel-hardening@lists.openwall.com
Cc: Andy Lutomirski <luto@amacapital.net>, linux-crypto@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Lutomirski <luto@kernel.org>, Stephan Mueller <smueller@chronox.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Dec 10, 2016 at 01:37:12PM +0800, Herbert Xu wrote:
> On Fri, Dec 09, 2016 at 09:25:38PM -0800, Andy Lutomirski wrote:
> >
> > Herbert, how hard would it be to teach the crypto code to use a more
> > sensible data structure than scatterlist and to use coccinelle fix
> > this stuff for real?
> 
> First of all we already have a sync non-SG hash interface, it's
> called shash.
> 
> If we had enough sync-only users of skcipher then I'll consider
> adding an interface for it.  However, at this point in time it
> appears to more sense to convert such users over to the async
> interface rather than the other way around.
> 
> As for AEAD we never had a sync interface to begin with and I
> don't think I'm going to add one.
> 

Isn't the question of "should the API use physical or virtual addresses"
independent of the question of "should the API support asynchronous requests"?
You can already choose, via the flags and mask arguments when allocating a
crypto transform, whether you want it to be synchronous or asynchronous or
whether you don't care.  I don't see what that says about whether the API should
take in physical memory (e.g. scatterlists or struct pages) or virtual memory
(e.g. iov_iters or just regular pointers).

And while it's true that asynchronous algorithms are often provided by hardware
drivers that operate on physical memory, it's not always the case.  For example
some of the AES-NI algorithms are asynchronous only because they use the SSE
registers which can't always available to kernel code, so the request may need
to be processed by another thread.

Eric
