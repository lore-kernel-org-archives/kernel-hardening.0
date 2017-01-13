Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Fri, 13 Jan 2017 19:51:07 +0100
MIME-Version: 1.0
Message-ID: <5879219B.26854.33C60FDB@pageexec.freemail.hu>
In-reply-to: <CAGXu5jLUCH9S98YFV3Db4q4r1aTsxbF_v0JeivH01pBYWM-Qzg@mail.gmail.com>
References: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>, <20170113082347.GJ20972@linaro.org>, <CAGXu5jLUCH9S98YFV3Db4q4r1aTsxbF_v0JeivH01pBYWM-Qzg@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Introduction
To: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 13 Jan 2017 at 9:54, Kees Cook wrote:

> PaX Team, the heuristic for STRUCTLEAK appears to be "does the struct
> contain anything marked __user". Is this actually a meaningful
> information exposure case? It seems like there are a lot more cases
> for exposures where there is nothing marked __user. Is that the
> meaning of "much smaller coverage" compared to STACKLEAK in the
> Kconfig?

STRUCTLEAK was written in response to a particular bug a few years ago
where we didn't want to give the bug away but still wanted to fix it
during the embargo. the struct in question could be matched by this
heuristics, matching everything else (however little of it) is really
just a free side effect. could coverage be improved? of course but that
would take a whole lot more work (manual markups and/or data flow analysis
in LTO mode).
