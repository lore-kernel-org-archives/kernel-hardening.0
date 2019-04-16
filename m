MIME-Version: 1.0
References: <CAOfkYf7di0vusjs-woyqgUD3GGLAuP2drir=Td=3+TuE2sKvvA@mail.gmail.com>
 <CAGXu5jLSW==S9TL28Z7x-=3PCRVXXkxi4ce5YDu+X8nHfb71eQ@mail.gmail.com>
 <CAOfkYf4G_zV9v+GT4i=W+Zkkq32oPKFXH3E8kmMuDVS84r+AAQ@mail.gmail.com>
 <CAGXu5jJJbnhUMovTaG_U=vJijEWuWkM1dMoh6Mm4gUmN4Ua_Dg@mail.gmail.com> <CAOfkYf4SiLvReac4H0-w1nZLwXQqZD8xAbN_dffzppcmH3S2Gg@mail.gmail.com>
In-Reply-To: <CAOfkYf4SiLvReac4H0-w1nZLwXQqZD8xAbN_dffzppcmH3S2Gg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 15 Apr 2019 22:58:31 -0500
Message-ID: <CAGXu5jLSLFNypH-JxmdWXKXawC74oTjzzfX_Qn5Gix2oNawQSA@mail.gmail.com>
Subject: Re: willing to involve in KSPP
Content-Type: text/plain; charset="UTF-8"
To: Shyam Saini <mayhs11saini@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 15, 2019 at 10:44 PM Shyam Saini <mayhs11saini@gmail.com> wrote:
> As you may already know that I've submitted the patch as per your
> suggestion but I'm still not

Thanks, i saw that! I'm hoping akpm will take it.

> sure how this FIELD macro uniformity in kernel is related to security.
> Is there any future plans
> based on this cleanup ?  Please excuse my lack of knowledge on the subject.

It was noticed while doing the HARDENED_USERCOPY work, and was a small
task that I wrote down at the time. It's more "related" to security
than actually making a security change.

-- 
Kees Cook
