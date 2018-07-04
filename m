Date: Wed, 4 Jul 2018 15:04:04 +0100
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: Clear the stack
Message-ID: <20180704140403.GE4828@arm.com>
References: <20180629190553.7282-1-labbott@redhat.com>
 <CAGXu5jL8kZHtg-MdScZ5m_6xH_Ho4TsdKGWH83zEL9Y5rutncw@mail.gmail.com>
 <706dc06b-0157-89cb-33a6-d0b9d811dcf0@redhat.com>
 <CAGXu5jLW5FJdRdRXcP=xPOEcQ=Tg+uSi=vj6vQ39iVp=QHSRAQ@mail.gmail.com>
 <20180702095931.GB28665@arm.com>
 <CAGXu5jJSUFFUpaWYToiKQymKR-wwem55WgAgbygWXdTfHQUs4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJSUFFUpaWYToiKQymKR-wwem55WgAgbygWXdTfHQUs4Q@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Alexander Popov <alex.popov@linux.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On Mon, Jul 02, 2018 at 10:29:24AM -0700, Kees Cook wrote:
> On Mon, Jul 2, 2018 at 2:59 AM, Will Deacon <will.deacon@arm.com> wrote:
> > On Fri, Jun 29, 2018 at 01:25:20PM -0700, Kees Cook wrote:
> >> No worries! I've made the change locally and will push this out to
> >> -next unless there are objections?
> >
> > I'm a bit wary of conflicts in entry.S, since it's likely that we're going
> > to have a lot going on in there for 4.19.
> >
> > Could I take this via arm64 instead, please, or are there dependencies
> > on other parts of your tree?
> 
> It depends on the plugin existing, but we could split it up so the
> arm64 part could go separately. It would just be a no-op in the arm64
> tree since CONFIG_GCC_PLUGIN_STACKLEAK won't exist there. Whatever
> works best for you!

If you could split it up then that would be really helpful, please.

Thanks,

Will
