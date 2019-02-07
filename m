Date: Thu, 7 Feb 2019 12:48:50 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 01/27] x86/crypto: Adapt assembly for PIE support
Message-ID: <20190207114850.GD2414@zn.tnic>
References: <20190131192533.34130-1-thgarnie@chromium.org>
 <20190131192533.34130-2-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190131192533.34130-2-thgarnie@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 31, 2019 at 11:24:08AM -0800, Thomas Garnier wrote:
> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.

This sentence is auto-sprinkled in a bunch of commit messages. Sounds to
me it should be rather somewhere in the 0/n message as a justification
for the feature but not in every other commit message...?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
