Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 12 Jan 2017 16:06:02 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170112160602.GA12583@leverpostej>
References: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>
Subject: Re: [kernel-hardening] Introduction
To: park jinbum <jinb.park7@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 13, 2017 at 12:06:31AM +0900, park jinbum wrote:
> Hello All,

Hi,

> I'd like to contribute to kernel self protection project.
> I've experienced ARM kernel, security solution on production.
> (kernel memory protection, contents protection, ...)
> 
> I'm interested in following topics.
> - Move kernel stack to vmap area (done on x86, other archs still need it)

FWIW, I'm looking at this for arm64 (and Takahiro-san is also looking at
this area). Making the stacks virtually mapped is fairly trivial, but
implementing reliable {under,over}flow handling is fairly involved.

32-bit ARM is also somewhat starved for vmalloc space, so ignoring the
difficulties in exception handling changes, I'm not sure that's going to
be widely deployable.

I believe it should be possible to implement THREAD_INFO_IN_TASK for arm
similarly to arm64, which would bring some benefit regardless.

Takahiro-san, were you looking into that at all?

> - KASLR for ARM

Given the small amount of VA space on 32-bit, and the potential of
kernel addresses to be determined by other means, I'm not sure that
there's much gain from this relative to the work involved.

> - protect ARM vector table as fixed-location kernel target

I'm not exactly sure what this means (I see it was taken from the KSPP
todo list?). Kees -- did you have a specific idea here?

On cores with VBAR, the vectors can be moved, so it might be possible to
dynamically allocate them at a random position. Otherwise, I was under
the impression that this was RO with DEBUG_RODATA selected.

... on that note, mandating DEBUG_RODATA for 32-bit ARM would be a good
step forward.

Thanks,
Mark.
