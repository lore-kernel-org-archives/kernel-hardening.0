Reply-To: kernel-hardening@lists.openwall.com
From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <1468446964-22213-12-git-send-email-keescook@chromium.org>
References: <1468446964-22213-1-git-send-email-keescook@chromium.org> <1468446964-22213-12-git-send-email-keescook@chromium.org>
Date: Thu, 14 Jul 2016 20:07:01 +1000
Message-ID: <87k2goa5yy.fsf@@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] [PATCH v2 11/11] mm: SLUB hardened usercopy support
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@redhat.com>, Casey Schaufler <casey@schaufler-ca.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "David S. Miller" <davem@davemloft.net>, x86@kernel.org, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Mathias Krause <minipli@googlemail.com>, Jan Kara <jack@suse.cz>, Vitaly Wool <vitalywool@gmail.com>, Andrea Arcangeli <aarcange@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Laura Abbott <labbott@fedoraproject.org>, lin ux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> Under CONFIG_HARDENED_USERCOPY, this adds object size checking to the
> SLUB allocator to catch any copies that may span objects. Includes a
> redzone handling fix from Michael Ellerman.

Actually I think you wrote the fix, I just pointed you in that
direction. But anyway, this works for me, so if you like:

Tested-by: Michael Ellerman <mpe@ellerman.id.au>

cheers
