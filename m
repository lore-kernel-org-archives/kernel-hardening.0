Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 10 May 2016 19:44:07 +0200
From: Borislav Petkov <bp@suse.de>
Message-ID: <20160510174407.GG28520@pd.tnic>
References: <1462900755-20005-1-git-send-email-keescook@chromium.org>
 <1462900755-20005-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1462900755-20005-2-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v8 1/4] x86/KASLR: Clarify identity map interface
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 10, 2016 at 10:19:12AM -0700, Kees Cook wrote:
> This extracts the call to prepare_level4() into a top-level function
> that the user of the pagetable.c interface must call to initialize
> the new page tables. For clarity and to match the "finalize" function,
> it has been renamed to initialize_identity_maps(). This function also
> gains the initialization of mapping_info so we don't have to do it each
> time in add_identity_map().
> 
> Additionally add copyright notice to the top, to make it clear that the
> bulk of the pagetable.c code was written by Yinghai, and that I just
> added bugs later. :)
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/boot/compressed/kaslr.c     |  3 +++
>  arch/x86/boot/compressed/misc.h      |  3 +++
>  arch/x86/boot/compressed/pagetable.c | 26 ++++++++++++++++----------
>  3 files changed, 22 insertions(+), 10 deletions(-)

Exactly!

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
