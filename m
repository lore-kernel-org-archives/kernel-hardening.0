MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20170208192659.GA32582@beast>
References: <20170208192659.GA32582@beast>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Feb 2017 11:54:30 -0800
Message-ID: <CA+55aFzz25AxbG7vJNNKAOEpAJFYnd=D0wJrL-tEN-SREk6kSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] time: Remove CONFIG_TIMER_STATS
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Xing Gao <xgao01@email.wm.edu>, Jessica Frazelle <me@jessfraz.com>, John Stultz <john.stultz@linaro.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Richard Cochran <richardcochran@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Michal Marek <mmarek@suse.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Shuah Khan <shuah@kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 8, 2017 at 11:26 AM, Kees Cook <keescook@chromium.org> wrote:
>
> Given that the tracer can give the same information, this patch entirely
> removes CONFIG_TIMER_STATS.
>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: John Stultz <john.stultz@linaro.org>

Looks good to me. Let's wait for the 4.11 merge window though. I'm
assuming I'll get this through the tip timer tree..

               Linus
