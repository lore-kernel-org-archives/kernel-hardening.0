MIME-Version: 1.0
In-Reply-To: <20170817144043.GA10717@infradead.org>
References: <CAGXu5jKu6JWC6hw4BYGPA+qatMdd-SiaO2LiJy6XnAfjbU+1Rw@mail.gmail.com>
 <20170817144043.GA10717@infradead.org>
From: Kees Cook <keescook@google.com>
Date: Thu, 17 Aug 2017 08:08:38 -0700
Message-ID: <CAGXu5jKsZP-zc4zFMzysmnyw--Dh=4JxVWdsw+djChzENS2K_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: refactoring timers to avoid init_timer*()
To: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 17, 2017 at 7:40 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Instea of bloating the timer even more we should kill off
> the data field eventually, which should give you the same
> protection.
>
> See my proposal and the related discussion here:
>
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1397209.html

Ah! Yes, very cool. Most callbacks could be converted to the new timer
callback pretty easily. Some, though, pass non-pointer data in the
"data" argument. Those can likely be moved to somewhere else, though.
I think it should be possible to just perform all the conversions.

Regardless, getting rid of init_timer*() and eliminating the
open-coded callback assignments should help. I'll keep grinding on
that.

-Kees

-- 
Kees Cook
Pixel Security
