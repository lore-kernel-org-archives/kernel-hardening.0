MIME-Version: 1.0
References: <20190125173827.2658-1-willy@infradead.org> <20190128102055.5b0790549542891c4dca47a3@linux-foundation.org>
In-Reply-To: <20190128102055.5b0790549542891c4dca47a3@linux-foundation.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 29 Jan 2019 08:00:14 +1300
Message-ID: <CAGXu5jJkf4pKr0WVUcFitZnnUbq3annautZxzYPC0TQaB5HaGA@mail.gmail.com>
Subject: Re: [PATCH] mm: Prevent mapping slab pages to userspace
Content-Type: text/plain; charset="UTF-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 29, 2019 at 7:21 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Fri, 25 Jan 2019 09:38:27 -0800 Matthew Wilcox <willy@infradead.org> wrote:
>
> > It's never appropriate to map a page allocated by SLAB into userspace.
> > A buggy device driver might try this, or an attacker might be able to
> > find a way to make it happen.
>
> It wouldn't surprise me if someone somewhere is doing this.  Rather
> than mysteriously breaking their code, how about we emit a warning and
> still permit it to proceed, for a while?

It seems like a fatal condition to me? There's nothing to check that
such a page wouldn't get freed by the slab while still mapped to
userspace, right?

But I'll take warning over not checking. :)

-- 
Kees Cook
