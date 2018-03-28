Date: Wed, 28 Mar 2018 05:54:55 +0200
From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 1/4] gpio: Remove VLA from gpiolib
Message-ID: <20180328035455.GA18149@wunner.de>
References: <20180310001021.6437-1-labbott@redhat.com>
 <20180310001021.6437-2-labbott@redhat.com>
 <a758ce3f-fed7-2ecf-94c5-ba133ea75bde@rasmusvillemoes.dk>
 <20180317082509.GA2579@wunner.de>
 <20180318142327.GA23761@wunner.de>
 <b162140d-5c71-196b-8f1f-555fd07810df@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b162140d-5c71-196b-8f1f-555fd07810df@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Mathias Duckeck <m.duckeck@kunbus.de>, Nandor Han <nandor.han@ge.com>, Semi Malinen <semi.malinen@ge.com>, Patrice Chotard <patrice.chotard@st.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 27, 2018 at 05:37:18PM -0700, Laura Abbott wrote:
> On 03/18/2018 07:23 AM, Lukas Wunner wrote:
> > Actually, scratch that.  If ngpio is usually smallish, we can just
> > allocate reasonably sized space for mask and bits on the stack,
> > and fall back to the kcalloc slowpath only if chip->ngpio exceeds
> > that limit.  Basically the below (likewise compile-tested only),
> > this is on top of Laura's patch, could be squashed together.
> > Let me know what you think, thanks.
> >
> 
> It seems like there's general consensus this is okay so I'm going
> to fold it into the next version. If not, we can discuss again.

Yes, feel free to squash into your original patch with my S-o-b,
keep your authorship.

You may want to raise FASTPATH_NGPIO to something like 384, 448 or 512
to accommodate for the Intel chips Andy mentioned.  It's kind of a
"640k should be enough for everyone" thing but I'd expect the performance
impact of the extra bytes on the stack / memsetting them to zero
to be absolutely negligible.

Thanks!

Lukas
