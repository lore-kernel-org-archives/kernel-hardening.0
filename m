Date: Tue, 16 Apr 2019 16:30:40 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH] mm: security: introduce CONFIG_INIT_HEAP_ALL
In-Reply-To: <CAG_fn=U6aWfBXdkcWs0_1pqggAC16Yg8Q6rxLiVeiO83q1hOCw@mail.gmail.com>
Message-ID: <0100016a26fc7605-a9c76ac4-387c-47a3-8c53-a8d208eb0925-000000@email.amazonses.com>
References: <20190412124501.132678-1-glider@google.com> <0100016a26c711be-b99971ca-49f5-482c-9028-962ee471f733-000000@email.amazonses.com> <CAG_fn=U6aWfBXdkcWs0_1pqggAC16Yg8Q6rxLiVeiO83q1hOCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitriy Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 16 Apr 2019, Alexander Potapenko wrote:

> > Hmmm... But we already have debugging options that poison objects and
> > pages?
> Laura Abbott mentioned in one of the previous threads
> (https://marc.info/?l=kernel-hardening&m=155474181528491&w=2) that:
>
> """
> I've looked at doing something similar in the past (failing to find
> the thread this morning...) and while this will work, it has pretty
> serious performance issues. It's not actually the poisoning which
> is expensive but that turning on debugging removes the cpu slab
> which has significant performance penalties.

Ok you could rework that logic to be able to keep the per cpu slabs?

Also if you do the zeroing then you need to do it in the hotpath. And this
patch introduces new instructions to that hotpath for checking and
executing the zeroing.
