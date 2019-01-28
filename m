Date: Mon, 28 Jan 2019 20:08:23 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH] mm: Prevent mapping slab pages to userspace
In-Reply-To: <CAGXu5jJkf4pKr0WVUcFitZnnUbq3annautZxzYPC0TQaB5HaGA@mail.gmail.com>
Message-ID: <010001689613c1b5-6539225d-b74e-4248-8d8f-5b801c1a333b-000000@email.amazonses.com>
References: <20190125173827.2658-1-willy@infradead.org> <20190128102055.5b0790549542891c4dca47a3@linux-foundation.org> <CAGXu5jJkf4pKr0WVUcFitZnnUbq3annautZxzYPC0TQaB5HaGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@surriel.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 29 Jan 2019, Kees Cook wrote:

> It seems like a fatal condition to me? There's nothing to check that
> such a page wouldn't get freed by the slab while still mapped to
> userspace, right?

Lets just fail the code.  Currently this may work with SLUB. But SLAB and
SLOB overlay fields with mapcount. So you would have a corrupted page
struct if you mapped a slab page to user space.
