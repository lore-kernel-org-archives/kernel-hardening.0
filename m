Message-ID: <1498095554.13083.25.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Wed, 21 Jun 2017 21:39:14 -0400
In-Reply-To: <20170622001720.GA32173@beast>
References: <20170622001720.GA32173@beast>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH] exec: Account for argv/envp pointers
To: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Qualys Security Advisory <qsa@qualys.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-06-21 at 17:17 -0700, Kees Cook wrote:
> When limiting the argv/envp strings during exec to 1/4 of the stack
> limit,
> the storage of the pointers to the strings was not included. This
> means
> that an exec with huge numbers of tiny strings could eat 1/4 of the
> stack limit in strings and then additional space would be later used
> by the pointers to the strings. For example, on 32-bit with a 8MB
> stack
> rlimit, an exec with 1677721 single-byte strings would consume less
> than
> 2MB of stack, the max (8MB / 4) amount allowed, but the pointers to
> the
> strings would consume the remaining additional stack space (1677721 *
> 4 == 6710884). The result (1677721 + 6710884 == 8388605) would
> exhaust
> stack space entirely. Controlling this stack exhaustion could result
> in
> pathological behavior in setuid binaries (CVE-2017-1000365).
> 
> Fixes: b6a2fea39318 ("mm: variable length argument support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Rik van Riel <riel@redhat.com>
