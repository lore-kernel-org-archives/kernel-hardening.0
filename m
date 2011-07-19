Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 19 Jul 2011 11:40:43 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110719074043.GA3942@albatros>
References: <20110703111028.GA2862@albatros>
 <CA+55aFzXEoTyK0Sm-y=6xGmLMWzQiSQ7ELJ2-WL_PrP3r44MSg@mail.gmail.com>
 <20110718183951.GA3748@albatros>
 <20110718115237.14d96c03.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718115237.14d96c03.akpm@linux-foundation.org>
Subject: Re: [kernel-hardening] Re: [RFC v2] implement SL*B and stack
 usercopy runtime checks
To: kernel-hardening@lists.openwall.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 18, 2011 at 11:52 -0700, Andrew Morton wrote:
> > +noinline bool __kernel_access_ok(const void *ptr, unsigned long len)
> 
> noinline seems unneeded

Ah, understood what you mean.  It is .c, and users are in other .c, so
it is indeed redundant.

Thanks!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
