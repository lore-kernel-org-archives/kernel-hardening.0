Date: Mon, 28 Jan 2019 10:20:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Prevent mapping slab pages to userspace
Message-Id: <20190128102055.5b0790549542891c4dca47a3@linux-foundation.org>
In-Reply-To: <20190125173827.2658-1-willy@infradead.org>
References: <20190125173827.2658-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 25 Jan 2019 09:38:27 -0800 Matthew Wilcox <willy@infradead.org> wrote:

> It's never appropriate to map a page allocated by SLAB into userspace.
> A buggy device driver might try this, or an attacker might be able to
> find a way to make it happen.

It wouldn't surprise me if someone somewhere is doing this.  Rather
than mysteriously breaking their code, how about we emit a warning and
still permit it to proceed, for a while?
