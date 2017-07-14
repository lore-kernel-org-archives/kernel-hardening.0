Date: Fri, 14 Jul 2017 16:25:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170714152503.GC16687@leverpostej>
References: <CAKv+Gu9eSX-f4uv3gaNw9_eKV0soe2-CqSnMaTjjEhMifxe_8g@mail.gmail.com>
 <20170713161050.GG26194@leverpostej>
 <20170713175543.GA32528@leverpostej>
 <CAKv+Gu_v3PO7=JSgCTb3aZu3sg4cwYYjy68VJnr58vzaMYvhTw@mail.gmail.com>
 <20170714103258.GA16128@leverpostej>
 <CAKv+Gu-FvfPFQooCie6HwP=mBng3C0jp9p8WMkFwTxctDu4JBA@mail.gmail.com>
 <CAKv+Gu96YHXDta7=YdYO4=wtR3mGVdkzAkG6tSzS-vo7toiPXA@mail.gmail.com>
 <20170714140605.GB16687@leverpostej>
 <188731af-269c-4197-1c55-78e485e7af46@arm.com>
 <8f805a19-19d1-3c97-c85b-510664d22dad@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f805a19-19d1-3c97-c85b-510664d22dad@arm.com>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 6/6] arm64: add VMAP_STACK and
 detect out-of-bounds SP
To: Robin Murphy <robin.murphy@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Morse <james.morse@arm.com>, Takahiro Akashi <akashi.takahiro@linaro.org>, Dave Martin <dave.martin@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 14, 2017 at 04:03:51PM +0100, Robin Murphy wrote:
> On 14/07/17 15:39, Robin Murphy wrote:
> > On 14/07/17 15:06, Mark Rutland wrote:

> >> 	add	sp, sp, x0	// sp = orig_sp + orig_x0
> >> 	sub	x0, sp, x0	// x0 = orig_sp
> >> 	< check > 
> >> 	sub	x0, sp, x0	// x0 = orig_x0
> > 
> > Haven't you now forcibly cleared the top bit of x0 thanks to overflow?
> 
> ...or maybe not. I still can't quite see it, but I suppose it must
> cancel out somewhere, since Mr. Helpful C Program[1] has apparently
> proven me mistaken :(
> 
> I guess that means I approve!
> 
> Robin.
> 
> [1]:
> #include <assert.h>
> #include <stdint.h>
> 
> int main(void) {
>         for (int i = 0; i < 256; i++) {
>                 for (int j = 0; j < 256; j++) {
>                         uint8_t x = i;
>                         uint8_t y = j;
>                         y = y + x;
>                         x = y - x;
>                         x = y - x;
>                         y = y - x;
>                         assert(x == i && y == j);
>                 }
>         }
> }

I guess we have our first Tested-by for this series. :)

Thanks for taking a look!

Mark.
