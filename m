Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <516DCEF3.6030803@zytor.com>
Date: Tue, 16 Apr 2013 15:21:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1365797627-20874-1-git-send-email-keescook@chromium.org> <1365797627-20874-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1365797627-20874-5-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 4/6] x86: relocs: build separate 32/64-bit tools
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/12/2013 01:13 PM, Kees Cook wrote:
> Since the ELF structures and access macros change size based on 32 vs
> 64 bits, build a separate 32-bit relocs tool (for handling realmode
> and 32-bit relocations), and a 64-bit relocs tool (for handling 64-bit
> kernel relocations).
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> --
> This is ugly with the "cp". Is there some other cleaner way to trigger
> two builds with different defines from the same source file?

There definitely is.

Have simple wrapper files which do:

/* relocs_32.c */
#define ELF_BITS 32
#include "relocs.c"

/* relocs_64.c */
#define ELF_BITS 64
#include "relocs.c"

	-hpa
