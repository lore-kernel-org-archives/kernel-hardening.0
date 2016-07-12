Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 12 Jul 2016 16:56:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20160712085647.GA30201@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH v5 00/32] virtually mapped stacks and thread_info cleanup
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, bp@alien8.de, nadav.amit@gmail.com, keescook@chromium.org, brgerst@gmail.com, kernel-hardening@lists.openwall.com, torvalds@linux-foundation.org, jpoimboe@redhat.com, jann@thejh.net, heiko.carstens@de.ibm.com
List-ID: <kernel-hardening.lists.openwall.com>

Andy Lutomirski <luto@kernel.org> wrote:
>
> Known issues: - tcp md5, rxkad, virtio_net, and virtio_console will
> have issues.  Eric Dumazet has a patch for tcp md5, and Michael
> Tsirkin says he'll fix virtio_net and virtio_console.  rxkad will be
> fixed via net-next.

There is one more stack SG user within crypto, cts.  But I have
already posted a patch for that and I am intending to push this
at the next merge window.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
