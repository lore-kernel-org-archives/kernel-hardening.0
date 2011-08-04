Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 3 Aug 2011 17:50:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20110803175016.fb80b7f3.akpm@linux-foundation.org>
In-Reply-To: <CA+55aFzw-K6XvDzTwHRyqQWdkDO8Zqz8Ak1qgNTzf6a3L9=80A@mail.gmail.com>
References: <20110801180151.GA26686@albatros>
	<20110801112021.25ec9041.akpm@linux-foundation.org>
	<20110801190341.GA6898@albatros>
	<CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
	<20110802124530.GA2543@albatros>
	<20110802135512.b49c9de1.akpm@linux-foundation.org>
	<d844457bba74be419d2434c533fdb4e1@localhost>
	<CA+55aFx+JOeDoNzs+1wfdK3kpNPyS9wpU1OT=VAwvWPXfMVuDQ@mail.gmail.com>
	<20110803113033.1c3c6960@taxman.wild-wind.fr.eu.org>
	<CA+55aFzw-K6XvDzTwHRyqQWdkDO8Zqz8Ak1qgNTzf6a3L9=80A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vasiliy Kulikov <segoon@openwall.com>, Manuel Lauss <manuel.lauss@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@elte.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Paul E. McKenney" <paul.mckenney@linaro.org>, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 3 Aug 2011 14:35:09 -1000 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> --- a/init/main.c
> +++ b/init/main.c
> @@ -369,9 +369,12 @@ static noinline void __init_refok rest_init(void)
>  	init_idle_bootup_task(current);
>  	preempt_enable_no_resched();
>  	schedule();
> -	preempt_disable();
> +
> +	/* At this point, we can enable user mode helper functionality */
> +	usermodehelper_enable();
>  
>  	/* Call into cpu_idle with preempt disabled */
> +	preempt_disable();
>  	cpu_idle();
>  }

Well, it's still a workaround.  We'll still have driver_init() trying
to run userspace helpers at an inappropriate time, and failing to do
so.  Either something will break or it should not be attempting
attempting to do this at all.

Perhaps Kay and Greg can suggest how we can fix all this up?
