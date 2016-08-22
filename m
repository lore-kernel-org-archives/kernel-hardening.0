Reply-To: kernel-hardening@lists.openwall.com
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 22 Aug 2016 15:15:35 +0200
Message-ID: <4367840.AWTJIHYqbe@wuerfel>
In-Reply-To: <1471470132-29499-5-git-send-email-keescook@chromium.org>
References: <1471470132-29499-1-git-send-email-keescook@chromium.org> <1471470132-29499-5-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: [PATCH v3 4/5] bug: Provide toggle for BUG on data corruption
To: Kees Cook <keescook@chromium.org>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Laura Abbott <labbott@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Stephen Boyd <sboyd@codeaurora.org>, Syed Rameez Mustafa <rameezmustafa@codeaurora.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wednesday, August 17, 2016 2:42:11 PM CEST Kees Cook wrote:
> +
> +/*
> + * Since detected data corruption should stop operation on the affected
> + * structures, this returns false if the corruption condition is found.
> + */
> +#define CHECK_DATA_CORRUPTION(condition, fmt, ...)                      \
> +       do {                                                             \
> +               if (unlikely(condition)) {                               \
> +                       if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION)) { \
> +                               pr_err(fmt, ##__VA_ARGS__);              \
> +                               BUG();                                   \
> +                       } else                                           \
> +                               WARN(1, fmt, ##__VA_ARGS__);             \
> +                       return false;                                    \
> +               }                                                        \
> +       } while (0)
> +

I think the "return false" inside of the macro makes it easy to misread
what is actually going on.

How about making it a macro that returns the condition argument?

#define CHECK_DATA_CORRUPTION(condition, fmt, ...)	\
({	\
	bool _condition = unlikely(condition);	\
	if (_condition) {	\
		...
	}	\
	_condition;	\
})

	Arnd
