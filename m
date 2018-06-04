In-Reply-To: <20180514130316.23855-1-mpe@ellerman.id.au>
From: Michael Ellerman <patch-notifications@ellerman.id.au>
Subject: Re: [1/2] powerpc: Rename thread_struct.fs to addr_limit
Message-Id: <40zxg609Blz9ryk@ozlabs.org>
Date: Tue,  5 Jun 2018 00:10:57 +1000 (AEST)
To: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@ozlabs.org
Cc: thgarnie@google.com, keescook@chromium.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 2018-05-14 at 13:03:15 UTC, Michael Ellerman wrote:
> It's called 'fs' for historical reasons, it's named after the x86 'FS'
> register. But we don't have to use that name for the member of
> thread_struct, and in fact arch/x86 doesn't even call it 'fs' anymore.
> 
> So rename it to 'addr_limit', which better reflects what it's used
> for, and is also the name used on other arches.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Series applied to powerpc next.

https://git.kernel.org/powerpc/c/ba0635fcbe8c1ce83523c1ec797538

cheers
