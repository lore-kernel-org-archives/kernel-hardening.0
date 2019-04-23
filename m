MIME-Version: 1.0
References: <20190418154208.131118-1-glider@google.com> <20190418154208.131118-4-glider@google.com>
In-Reply-To: <20190418154208.131118-4-glider@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 23 Apr 2019 12:17:33 -0700
Message-ID: <CAGXu5jKcBU43YGooE0NSk5BF9NhdHu6vuFOr8Zq6Fq-Dk4jNPA@mail.gmail.com>
Subject: Re: [PATCH 3/3] RFC: net: apply __GFP_NOINIT to AF_UNIX sk_buff allocations
Content-Type: text/plain; charset="UTF-8"
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Dmitry Vyukov <dvyukov@google.com>, Laura Abbott <labbott@redhat.com>, Linux-MM <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 18, 2019 at 8:42 AM Alexander Potapenko <glider@google.com> wrote:
>
> Add sock_alloc_send_pskb_noinit(), which is similar to
> sock_alloc_send_pskb(), but allocates with __GFP_NOINIT.
> This helps reduce the slowdown on hackbench from 9% to 0.1%.

I would include a detailed justification about why this is safe to do.
I imagine (but haven't looked) that the skb is immediately written to
after allocation, so this is basically avoiding a "double init". Is
that correct?

-- 
Kees Cook
