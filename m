MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170623015010.GA137429@beast>
References: <20170623015010.GA137429@beast>
From: Kees Cook <keescook@chromium.org>
Date: Sun, 25 Jun 2017 12:56:21 -0700
Message-ID: <CAGXu5jJEi_CS-CB=-4369TFRyeN4oQdmGS+HV-zoi4rSPpq3Jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2] mm: Add SLUB free list pointer obfuscation
To: Christoph Lameter <cl@linux.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Laura Abbott <labbott@redhat.com>, Daniel Micay <danielmicay@gmail.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@kernel.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>, Daniel Mack <daniel@zonque.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 22, 2017 at 6:50 PM, Kees Cook <keescook@chromium.org> wrote:
> This SLUB free list pointer obfuscation code is modified from Brad
> Spengler/PaX Team's code in the last public patch of grsecurity/PaX based
> on my understanding of the code. Changes or omissions from the original
> code are mine and don't reflect the original grsecurity/PaX code.
>
> This adds a per-cache random value to SLUB caches that is XORed with
> their freelist pointers. This adds nearly zero overhead and frustrates the
> very common heap overflow exploitation method of overwriting freelist
> pointers. A recent example of the attack is written up here:
> http://cyseclabs.com/blog/cve-2016-6187-heap-off-by-one-exploit

BTW, to quantify "nearly zero overhead", I ran multiple 200-run cycles
of "hackbench -g 20 -l 1000", and saw:

before:
mean 10.11882499999999999995
variance .03320378329145728642
stdev .18221905304181911048

after:
mean 10.12654000000000000014
variance .04700556623115577889
stdev .21680767106160192064

The difference gets lost in the noise, but if the above is sensible,
it's 0.07% slower. ;)

-Kees

-- 
Kees Cook
Pixel Security
