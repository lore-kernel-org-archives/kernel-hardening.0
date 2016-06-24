Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 24 Jun 2016 10:36:18 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20160624153618.gbl2qzlbkapfbngs@treble>
References: <cover.1466741835.git.luto@kernel.org>
 <cdc5198de169727bea97a4209864e7cb3c97ea76.1466741835.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cdc5198de169727bea97a4209864e7cb3c97ea76.1466741835.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH v4 14/16] x86/dumpstack/64: Handle faults when printing
 the "Stack:" part of an OOPS
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 23, 2016 at 09:23:09PM -0700, Andy Lutomirski wrote:
> If we overflow the stack into a guard page, we'll recursively fault
> when trying to dump the contents of the guard page.  Use
> probe_kernel_address so we can recover if this happens.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
