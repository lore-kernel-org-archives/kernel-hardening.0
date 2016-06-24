Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 24 Jun 2016 10:35:03 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20160624153503.oeivkn7djnxdi5oq@treble>
References: <cover.1466741835.git.luto@kernel.org>
 <f76b49739625fce1264428155540ca7161925511.1466741835.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f76b49739625fce1264428155540ca7161925511.1466741835.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH v4 13/16] x86/dumpstack: Try harder to get a call trace
 on stack overflow
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 23, 2016 at 09:23:08PM -0700, Andy Lutomirski wrote:
> If we overflow the stack, print_context_stack will abort.  Detect
> this case and rewind back into the valid part of the stack so that
> we can trace it.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
