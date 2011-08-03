Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <d844457bba74be419d2434c533fdb4e1@localhost>
References: <20110801180151.GA26686@albatros> <20110801112021.25ec9041.akpm@linux-foundation.org>
 <20110801190341.GA6898@albatros> <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
 <20110802124530.GA2543@albatros> <20110802135512.b49c9de1.akpm@linux-foundation.org>
 <d844457bba74be419d2434c533fdb4e1@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Aug 2011 22:19:24 -1000
Message-ID: <CA+55aFx+JOeDoNzs+1wfdK3kpNPyS9wpU1OT=VAwvWPXfMVuDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 2, 2011 at 10:05 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>
> Reordering the initcalls seems the easiest solution, but it is still very
> fragile...

So that's what I tried to do, by making it a "pure_initcall()". Even
that didn't seem to be enough according to Manuel.

Can you try my patch (that makes just that ipc ns init be a
pure_initcall(), together with your hack on top of Andrew's? What is
it that happens so early that even pure_initcall() hasn't been done
yet?

             Linus
