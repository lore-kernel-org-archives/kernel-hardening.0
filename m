MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170808003345.GA107289@beast>
References: <20170808003345.GA107289@beast>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 8 Aug 2017 10:59:49 -0700
Message-ID: <CAGXu5jLruATwoSODWrj8oFX67OFaSTCygDXW0t2Ht7EX-M=bog@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC][PATCH] timer: Add function-change canary
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 7, 2017 at 5:33 PM, Kees Cook <keescook@chromium.org> wrote:
> This introduces canaries to struct timer_list in an effort to protect the
> function callback pointer from getting rewritten during stack or heap
> overflow attacks. The struct timer_list has become a recent target for
> security flaw exploitation because it includes the "data" argument in
> the structure, along with the function callback. This provides attackers
> with a ROP-like primitive for performing limited kernel function calls
> without needing all the prerequisites to stage a ROP attack.
>
> Recent examples of exploits using struct timer_list attacks:
>
> http://www.openwall.com/lists/oss-security/2016/12/06/1
> (https://www.exploit-db.com/exploits/40871/)
>
> https://googleprojectzero.blogspot.com/2017/05/exploiting-linux-kernel-via-packet.html
> (https://www.exploit-db.com/exploits/41458/)
>
> Timers normally have their callback functions initialized either via
> the setup_timer_*() macros or manually before calls to add_timer(). The
> per-timer canary gets set in either case, and then checked at timer
> expiration time before calling the function.

Har har, I missed DEFINE_TIMER() which is rather widely used. :P

I'll send a v2, though the canary may end up being a bit weaker to
deal with static initializers.

-Kees

-- 
Kees Cook
Pixel Security
