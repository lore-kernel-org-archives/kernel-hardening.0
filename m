Date: Wed, 7 Mar 2018 16:03:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vsprintf: Remove accidental VLA usage
Message-Id: <20180307160322.e9f8a3fb462751d1efa3b09a@linux-foundation.org>
In-Reply-To: <CAGXu5j+d91dqTEPm13CXDvNzzaj01M-CYLYCqyMN5VjrD5Q4ww@mail.gmail.com>
References: <20180307230714.GA20797@beast>
	<20180307234238.yxbbaka35ck2xymw@smitten>
	<CAGXu5j+d91dqTEPm13CXDvNzzaj01M-CYLYCqyMN5VjrD5Q4ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Tycho Andersen <tycho@tycho.ws>, "Tobin C. Harding" <me@tobin.cc>, Jonathan Corbet <corbet@lwn.net>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 7 Mar 2018 15:59:27 -0800 Kees Cook <keescook@chromium.org> wrote:

> I didn't want to encourage a global macro that _lacked_ the safety
> built into the max*() family, though... thoughts for a reasonable
> approach?

I think SIMPLE_MAX() is OK.    Along with one of /* these */ things ;)
